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
            nodeA = Tn(iElem,1);
            nodeB = Tn(iElem,2);
            xA = x(nodeA,1);
            yA = x(nodeA,2);
            xB = x(nodeB,1);
            yB = x(nodeB,2);
            l  = sqrt((xB-xA)^2+(yB-yA)^2);
            cx = (xB-xA)/l;
            cy = (yB-yA)/l;
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

        function computeGlobalStiffnessMatrix(obj)
            nElem = obj.dim.nel;
            nDofN = obj.dim.ni;
            nNodE = obj.dim.nne;
            nDof  = obj.dim.ndof;
            Edof  = nNodE*nDofN;
            T   = obj.connectivityMatrix;
            Kel = obj.elementMatrix;
            KG = zeros(nDof,nDof);
            for iElem = 1:nElem
                for iRow = 1:Edof
                    iDof = T(iElem,iRow);
                    for iColum = 1:Edof 
                        Kij = Kel(iRow,iColum,iElem);
                        jDof = T(iElem,iColum);
                        KG(iDof,jDof) = KG(iDof,jDof) + Kij;
                    end
                end
            end
            obj.stiffnessMatrix = KG;
        end
    end

    methods (Access = private, Static)

        function R = computeRotationMatrix(R,cx,cy)
            c1 = [cx cy];
            c2 = [-cy cx];
            R(1,1:2) = c1;   
            R(2,1:2) = c2;
            R(3,3)   = 1;
            R(4,4:5) = c1;
            R(5,4:5) = c2;
            R(6,6)   = 1;
        end

        function Kel = computeRotateMatrix(iElem,Kel,K,R)
            Kel(:,:,iElem)=Kel(:,:,iElem)+R.'*K*R;
        end

    end

end