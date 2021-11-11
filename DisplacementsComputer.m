classdef DisplacementsComputer < handle
    

    properties (Access = public)
        displacements
        Reactions
    end

    properties (Access = private)
        dim
        data
        stiffnessMatrix
        forceVector
        K
        F
        uL
        ur
        vl
        vr
        RR
    end


    methods (Access = public)

        function obj = DisplacementsComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
           obj.computefixedDOF();
           obj.computeFreeDOF();
           obj.splitStiffnessMatrix();
           obj.splitForceVector();
           obj.solveSystem();
           obj.jointDisplacements();
           obj.jointReactions();
        end

    end

    methods (Access = private)

        function obj = init(obj,cParams)
            obj.data            = cParams.data;
            obj.dim             = cParams.dim;
            obj.stiffnessMatrix = cParams.stiffnessMatrix;
            obj.forceVector     = cParams.forceVector;
        end


        function computefixedDOF(obj)
            nDofN = obj.dim.ni;
            fxnod = obj.data.fixnod;    
            vrv = zeros(size(fxnod,1),1);            
            for i=1:size(fxnod,1)
                node = fxnod(i,1);
                dof  = fxnod(i,2);
                a = nDofN*node-(nDofN-dof);
                vrv(i) = a;
            end 
            urv = fxnod(:,3);
            obj.ur = urv;
            obj.vr = vrv;
        end

        function computeFreeDOF(obj)
            nDof = obj.dim.ndof;
            vrv = obj.vr;
            vlv = setdiff(1:nDof,vrv);
            vlv = vlv';
            obj.vl = vlv;
        end

        function splitStiffnessMatrix(obj)
            vlv = obj.vl;
            vrv = obj.vr;
            KG = obj.stiffnessMatrix;
            obj.K.LL = KG(vlv,vlv);
            obj.K.LR = KG(vlv,vrv);
            obj.K.RL = KG(vrv,vlv);
            obj.K.RR = KG(vrv,vrv);
        end

        function splitForceVector(obj)
            vlv = obj.vl;
            vrv = obj.vr;
            Fext = obj.forceVector;
            obj.F.L = Fext(vlv);
            obj.F.R = Fext(vrv);
        end


        function solveSystem(obj)
            urv = obj.ur;
            KLL = obj.K.LL;
            KLR = obj.K.LR;
            KRL = obj.K.RL;
            KRR = obj.K.RR;
            FextL = obj.F.L;
            FextR = obj.F.R;
            obj.uL = KLL\(FextL-KLR*urv);
            obj.RR = KRR*urv+KRL*obj.uL-FextR;
        end

        function jointDisplacements(obj)
            KG = obj.stiffnessMatrix;
            urv = obj.ur;
            vrv = obj.vr;
            vlv = obj.vl;
            ul = obj.uL;
            u = zeros(size(KG,1),1);
            for i=1:size(vrv,2)
                u(vrv(i)) = urv(i);
            end

            for i=1:size(vlv,1)
                u(vlv(i)) = ul(i);
            end

            obj.displacements = u;

        end

        function jointReactions (obj)
            KG = obj.stiffnessMatrix;
            vrv = obj.vr;
            Rr  = obj.RR;
            R = zeros(size(KG,1),1);
             for i=1:size(vrv,2)
                R(vrv(i)) = Rr(i);
             end
             obj.Reactions = R;
        end

    end
end


   