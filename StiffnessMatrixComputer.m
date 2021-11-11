classdef StiffnessMatrixComputer < handle 
 
    properties (Access = public)
        stiffnessMatrix 
    end

    properties (Access = private)
        data
        dim
        connectivityMatrix
        elementMatrix
    end


    methods (Access = public)

        function obj = StiffnessMatrixComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.computeConnectivityMatrix();
            obj.computeElementMatrix();
            obj.computeGlobalStiffnessMatrix();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
        end

        function computeConnectivityMatrix(obj)
            nElem = obj.dim.nel; 
            nNodE = obj.dim.nne;
            nDofN = obj.dim.ni;
            Tn    = obj.data.Tnod;
            T = zeros(nElem,nNodE*nDofN);
            for iElem=1:nElem
                for iNod=1:nNodE
                    for iDof=1 : nDofN
                        I = nDofN *(iNod-1)+iDof;
                        T(iElem,I)= nDofN *(Tn(iElem,iNod)-1)+iDof;
                    end
                end
            end
            obj.connectivityMatrix = T;

        end

        function computeElementMatrix(obj)
            nElem = obj.dim.nel;
            nDofN = obj.dim.ni;
            nNodE = obj.dim.nne;
            Edof  = nNodE*nDofN;
            R   = zeros(Edof ,Edof);
            K   = zeros(Edof ,Edof);
            Kel = zeros(Edof ,Edof ,nElem);
            for iElem=1:nElem
                [l,cx,cy] = obj.computeGeometry(iElem);
                R         = obj.computeRotationMatrix(R,cx,cy);
                K         = obj.computeElementalMatrix(iElem,K,l);
                Kel       = obj.computeRotateMatrix(iElem,Kel,K,R);
            end
            obj.elementMatrix = Kel;
        end

        function [l,cx,cy] = computeGeometry (obj,iElem)
            Tn = obj.data.Tnod;
            x  = obj.data.x;
            x1 = x(Tn(iElem,1),1);
            y1 = x(Tn(iElem,1),2);
            x2 = x(Tn(iElem,2),1);
            y2 = x(Tn(iElem,2),2);
            l  = sqrt((x2-x1)^2+(y2-y1)^2);
            cx = (x2-x1)/l;
            cy = (y2-y1)/l;
        end


        function R = computeRotationMatrix(obj,R,cx,cy)
            c1 = [cx cy];
            c2 = [-cy cx];
            R(1,1:2) = c1;   
            R(2,1:2) = c2;
            R(3,3) = 1;
            R(4,4:5) = c1;
            R(5,4:5) = c2;
            R(6,6) = 1;
        end


        function K = computeElementalMatrix(obj,iElem,K,l)
            [c1,c2,c3,c4,c5,c6] = obj.computeCoeffs(iElem,l);
            K(1,1:4) = [c2 0 0 -c2];
            K(2,2:3) = c1*[c3 c4];
            K(2,5:6) = c1*[-c3 c4];
            K(3,2:3) = c1*[c4 c5];
            K(3,5:6) = c1*[-c4 c6];
            K(4,1:4) = [-c2 0 0 c2];
            K(5,2:3) = c1*[-c3 -c4];
            K(5,5:6) = c1*[c3 -c4];
            K(6,2:3) = c1*[c4 c6];
            K(6,5:6) = c1*[-c4 c5];  
        end

        function [c1,c2,c3,c4,c5,c6] = computeCoeffs(obj,iElem,l)
            mat  = obj.data.mat;
            Tmat = obj.data.Tmat;
            c1 = 1/l^3*mat(Tmat(iElem),3)*mat(Tmat(iElem),1);
            c2 = mat(Tmat(iElem),1)*mat(Tmat(iElem),2)/l;
            c3 = 12;
            c4 = 6*l;
            c5 = 4*l^2;
            c6 = 2*l^2;
        end



        function Kel = computeRotateMatrix(obj,iElem,Kel,K,R)
            Kel(:,:,iElem)=Kel(:,:,iElem)+R.'*K*R;
        end


        function computeGlobalStiffnessMatrix(obj)
            nElem = obj.dim.nel;
            nDofN = obj.dim.ni;
            nNodE = obj.dim.nne;
            nDof  = obj.dim.ndof;
            Edof  = nNodE*nDofN;
            T = obj.connectivityMatrix;
            Kel = obj.elementMatrix;
            KG = zeros(nDof,nDof);
            for iElem=1:nElem
                for iRow=1:Edof
                    I=T(iElem,iRow);
                    for iColum=1:Edof
                        J=T(iElem,iColum);
                        KG(I,J)=KG(I,J)+Kel(iRow,iColum,iElem);
                    end
                end
            end
            obj.stiffnessMatrix = KG;
        end
    end

end