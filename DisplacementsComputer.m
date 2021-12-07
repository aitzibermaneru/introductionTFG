classdef DisplacementsComputer < handle
    
    properties (Access = public)
        displacements
        reactions
    end

    properties (Access = protected)
        solverType
    end

    properties (Access = private)
        dim
        data
        stiffnessMatrix
        forceVector
        ur
        LHS
        RHS
    end

    properties (Access = private)
        splitedStiffnessMatrix
        splitedForceVector
        dofManager
        uL
        RR
    end

    methods (Access = public)

        function obj = DisplacementsComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
           obj.splitStiffnessMatrix();
           obj.splitForceVector();
           obj.solveParameters();
           obj.solveSystem();
           obj.computeReactions();
           obj.jointDisplacements();
           obj.jointReactions();
        end

    end

    methods (Access = private)

        function obj = init(obj,cParams)
            obj.solverType      = cParams.solverType;
            obj.data            = cParams.data;
            obj.dim             = cParams.dim;
            obj.stiffnessMatrix = cParams.stiffnessMatrix;
            obj.forceVector     = cParams.forceVector;
            obj.dofManager      = cParams.dofManager;
            obj.ur              = cParams.dofManager.ur;
        end

        function splitStiffnessMatrix(obj)
            KG = obj.stiffnessMatrix;
            K = obj.dofManager.splitMatrix(KG);
            obj.splitedStiffnessMatrix = K;
        end

        function splitForceVector(obj)
            Fext = obj.forceVector;
            F = obj.dofManager.splitVector(Fext);
            obj.splitedForceVector = F;
        end

        function solveParameters(obj)
            K = obj.splitedStiffnessMatrix;
            F = obj.splitedForceVector;
            KLL = K.LL;
            KLR = K.LR;
            FL  = F.L;
            uR = obj.ur;
            obj.LHS  = KLL;
            obj.RHS = (FL-KLR*uR);
        end

        function solveSystem(obj)
            s.type = obj.solverType;
            s.LHS  = obj.LHS;
            s.RHS  = obj.RHS;
            solver   = Solver.create(s);
            solution = solver.solve();
            obj.uL   = solution;
        end

        function computeReactions(obj)
            K = obj.splitedStiffnessMatrix;
            KRR = K.RR;
            KRL = K.RL;
            F = obj.splitedForceVector;
            FR = F.R;
            urv = obj.ur;
            ul = obj.uL;
            obj.RR = KRR*urv+KRL*ul-FR;
        end

        function jointDisplacements(obj)
            ul = obj.uL;
            obj.displacements = obj.dofManager.addRestrictedDOFs(ul);
        end

        function jointReactions (obj)
            Rr = obj.RR;
            ul = obj.uL;
            Rl = zeros(size(ul,1),1);
            obj.reactions = obj.dofManager.joinRestrictedFree(Rl,Rr);
        end

    end
end


   