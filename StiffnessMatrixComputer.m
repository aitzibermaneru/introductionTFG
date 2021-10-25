classdef StiffnessMatrixComputer < handle 
 

    properties
        data
        dim

        connectivityMatrix
        elementMatrix
        stiffnessMatrix   

    end

    methods (Access = public)

        function obj = StiffnessMatrixComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.connectivityMatrixCompute();
            obj.elementMatrixCompute();
            obj.stiffnessMatrixCompute();
        end

    end

    methods (Access = private)

        function obj = init(obj,cParams)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
        end

        function obj = connectivityMatrixCompute(obj)
            d = obj.dim;
            dat = obj.data;
            connectivityMatrixv= zeros(d.nel,d.nne*d.ni);
         
            for e=1:d.nel
                for i=1:d.nne
                    for j=1:d.ni  
                        I = d.ni*(i-1)+j;
                        connectivityMatrixv(e,I)= + d.ni *(dat.Tnod(e,i)-1)+j;
                    end
                end
            end
            obj.connectivityMatrix = connectivityMatrixv;
        end

        function obj = elementMatrixCompute(obj)

            d = obj.dim;
            dat = obj.data;
            connectivityMatrixv = obj.connectivityMatrix;
            Kel = zeros(d.nne*d.ni,d.nne*d.ni,d.nel);

            for e = 1:d.nel
                x1 = dat.x(dat.Tnod(e,1),1);
                y1 = dat.x(dat.Tnod(e,1),2);
                x2 = dat.x(dat.Tnod(e,2),1);
                y2 = dat.x(dat.Tnod(e,2),2);


                l=sqrt((x2-x1)^2+(y2-y1)^2);

                R = 1/l*[x2-x1 y2-y1 0 0 0 0;
                    -(y2-y1) x2-x1 0 0 0 0;
                    0 0 l 0 0 0;
                    0 0 0 x2-x1 y2-y1 0;
                    0 0 0 -(y2-y1) x2-x1 0;
                    0 0 0 0 0 l];

                elementMatrixv = 1/l^3*dat.mat(dat.Tmat(e),3)*dat.mat(dat.Tmat(e),1)*[0 0 0 0 0 0;
                    0 12 6*l 0 -12 6*l;
                    0 6*l 4*l^2 0 -6*l 2*l^2;
                    0 0 0 0 0 0;
                    0 -12 -6*l 0 12 -6*l;
                    0 6*l 2*l^2 0 -6*l 4*l^2]+...
                    dat.mat(dat.Tmat(e),1)*dat.mat(dat.Tmat(e),2)/l*[1 0 0 -1 0 0;
                    0 0 0 0 0 0;
                    0 0 0 0 0 0;
                    -1 0 0 1 0 0;
                    0 0 0 0 0 0;
                    0 0 0 0 0 0];

                Kel(:,:,e)=Kel(:,:,e)+R.'*elementMatrixv*R;

            end
            obj.elementMatrix = Kel;
        end

        function obj = stiffnessMatrixCompute(obj)
            connectivityMatrixv = obj.connectivityMatrix;
            d = obj.dim;
            elementMatrixv = obj.elementMatrix;

            KG = zeros(d.ndof,d.ndof);
            for e=1:d.nel             
                for i=1:d.nne*d.ni   
                    I=connectivityMatrixv(e,i);
                    for j=1:d.nne*d.ni
                        J=connectivityMatrixv(e,j);
                        KG(I,J)=KG(I,J)+elementMatrixv(i,j,e);
                    end
                end
            end
            obj.stiffnessMatrix = KG;

        end

    end
    
end