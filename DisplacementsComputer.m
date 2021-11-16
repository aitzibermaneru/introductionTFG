classdef DisplacementsComputer < handle
    
    properties (Access = public)
        displacements
        reactions
    end

    properties (Access = private)
        dim
        data
        stiffnessMatrix
        forceVector
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
            obj.dofManager      = cParams.dofManager;
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


        function solveSystem(obj)
            urv = obj.dofManager.ur;
            K   = obj.splitedStiffnessMatrix;
            F   = obj.splitedForceVector;
            KLL = K.LL;
            KLR = K.LR;
            KRL = K.RL;
            KRR = K.RR;
            FL  = F.L;
            FR  = F.R;
            obj.uL = KLL\(FL-KLR*urv);
            obj.RR = KRR*urv+KRL*obj.uL-FR;
        end

        function jointDisplacements(obj)
            ul = obj.uL;
            ur = obj.dofManager.ur;
            obj.displacements = obj.dofManager.joinVector(ul,ur);
        end

        function jointReactions (obj)
            Rr = obj.RR;
            ul = obj.uL;
            Rl = zeros(size(ul,1),1);
            obj.reactions = obj.dofManager.joinVector(Rl,Rr);
        end

    end
end


   