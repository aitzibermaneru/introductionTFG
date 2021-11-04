classdef StiffnessMatrixComputer < handle 
 

    properties (Access = public)
        data
        dim
        stiffnessMatrix 
    end

    properties (Access = private)
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

        function obj = init(obj,cParams)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
        end

        function obj = computeConnectivityMatrix(obj)
            nElem = obj.dim.nel; 
            nNodE = obj.dim.nne;
            nDofN = obj.dim.ni;
            Tn    = obj.data.Tnod;

            T = zeros(nElem,nNodE*nDofN );

            for iElem=1:nElem
                for n=1:nNodE
                    for j=1 : nDofN
                        I = nDofN *(n-1)+j;
                        T(iElem,I)= nDofN  *(Tn(iElem,n)-1)+j;
                    end
                end
            end
            obj.connectivityMatrix = T;

        end

        function obj = computeElementMatrix(obj)

            nElem = obj.dim.nel;
            nDofN = obj.dim.ni;
            nNodE = obj.dim.nne;

            R   = zeros(nNodE*nDofN ,nNodE*nDofN);
            K   = zeros(nNodE*nDofN ,nNodE*nDofN);
            Kel = zeros(nNodE*nDofN ,nNodE*nDofN ,nElem);


            for iElem=1:nElem
                [R,l]   = obj.computeRotationMatrix(iElem,R);
                K   = obj.computeElementalMatrix(iElem,K,l);
                Kel = obj.computeRotateMatrix(iElem,Kel,K,R);
            end

            obj.elementMatrix = Kel;

        end


        function [R,l] = computeRotationMatrix (obj,iElem,R)
            Tn = obj.data.Tnod;
            x  = obj.data.x;
            
                  x1 = x(Tn(iElem,1),1);
                  y1 = x(Tn(iElem,1),2);
                  x2 = x(Tn(iElem,2),1);
                  y2 = x(Tn(iElem,2),2);

                  l = sqrt((x2-x1)^2+(y2-y1)^2);

                  cx = (x2-x1)/l;
                  cy = (y2-y1)/l;

                  R(1,1) = cx;
                  R(1,2) = cy;
                  R(2,1) = -cy;
                  R(2,2) = cx;
                  R(3,3) = 1;
                  R(4,4) = cx;
                  R(4,5) = cy;
                  R(5,4) = -cy;
                  R(5,5) = cx;
                  R(6,6) = 1;    
        end


        function K = computeElementalMatrix(obj,iElem,K,l)
            mat  = obj.data.mat;
            Tmat = obj.data.Tmat;
            c1 = 1/l^3*mat(Tmat(iElem),3)*mat(Tmat(iElem),1);
            c2 = mat(Tmat(iElem),1)*mat(Tmat(iElem),2)/l;
            c3 = 12;
            c4 = 6*l;
            c5 = 4*l^2;
            c6 = 2*l^2;

            K(1,1) = c2;
            K(1,4) = -c2;
            K(2,2) = c1*c3;
            K(2,3) = c1*c4;
            K(2,5) = -c1*c3;
            K(2,6) = c1*c4;
            K(3,2) = c1*c4;
            K(3,3) = c1*c5;
            K(3,5) = -c1*c4;
            K(3,6) = c1*c6;
            K(4,1) = -c2;
            K(4,4) = c2;
            K(5,2) = -c1*c3;
            K(5,3) = -c1*c4;
            K(5,5) = c1*c3;
            K(5,6) = -c1*c4;
            K(6,2) = c1*c4;
            K(6,3) = c1*c6;
            K(6,5) = -c1*c4;
            K(6,6) = c1*c5;    
        end

        function Kel = computeRotateMatrix(obj,iElem,Kel,K,R)
            Kel(:,:,iElem)=Kel(:,:,iElem)+R.'*K*R;
        end


        function obj = computeGlobalStiffnessMatrix(obj)
            nElem = obj.dim.nel;
            nDofN = obj.dim.ni;
            nNodE = obj.dim.nne;
            nDof  = obj.dim.ndof; 

            T = obj.connectivityMatrix;
            Kel = obj.elementMatrix;

            KG = zeros(nDof,nDof);

            for iElem=1:nElem
                for n=1:nNodE*nDofN
                    I=T(iElem,n);                  
                    for j=1:nNodE*nDofN 
                        J=T(iElem,j);
                        KG(I,J)=KG(I,J)+Kel(n,j,iElem);
                    end
                end
            end

            obj.stiffnessMatrix = KG;
        end

    end
    
end