classdef DisplacementsComputer < handle
    

    properties
        dim
        data
        
        displacements
        stiffnessMatrix
        forceVector
        ur
        vl
        vr

    end


    methods (Access = public)

        function obj = DisplacementsComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
           
           obj.fixedDOFCompute();
           obj.solveSystemCompute();
        end

    end

    methods (Access = private)

        function obj = init(obj,cParams)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
            obj.stiffnessMatrix = cParams.stiffnessMatrix;
            obj.forceVector = cParams.forceVector;
        end


        function obj = fixedDOFCompute(obj)
            d = obj.dim;
            dat = obj.data;
            vrv = zeros(size(dat.fixnod,1),1);

            vlv =zeros(d.ndof-size(dat.fixnod,1),1);

            for i=1:size(dat.fixnod,1)
                a = d.ni*dat.fixnod(i,1)-(d.ni-dat.fixnod(i,2));
                vrv(i) = a;
            end

            vlv = setdiff(1:d.ndof,vrv);
            urv = dat.fixnod(:,3);
            vlv=vlv';

            obj.ur = urv;
            obj.vl = vlv;
            obj.vr = vrv;

         
        end

        function obj = solveSystemCompute(obj)
            urv = obj.ur;
            vlv = obj.vl;
            vrv = obj.vr;
            stiffnessMatrixv = obj.stiffnessMatrix;
            forceVectorv = obj.forceVector;
 
            KLL = stiffnessMatrixv(vlv,vlv);
            KLR = stiffnessMatrixv(vlv,vrv);
            KRL = stiffnessMatrixv(vrv,vlv);
            KRR = stiffnessMatrixv(vrv,vrv);
            FextL = forceVectorv(vlv);
            FextR = forceVectorv(vrv);

            uL = KLL\(FextL-KLR*urv);
            RR = KRR*urv+KRL*uL-FextR;

            u = zeros(size(stiffnessMatrixv,1),1);
            R = zeros(size(stiffnessMatrixv,1),1);

            for i=1:size(vrv,2)
                u(vrv(i)) = urv(i);
                R(vrv(i)) = RR(i);
            end

            for i=1:size(vlv,1)
                u(vlv(i)) = uL(i);
            end

            obj.displacements = u;

        end

    end
end


   