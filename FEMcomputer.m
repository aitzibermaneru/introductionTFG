classdef FEMcomputer < handle

    properties (Access = public)
        stiffnessMatrix
        forceVector
        displacements
    end

    properties (Access = private)
        data
        dim
        solverType
        dofManager
    end

    methods (Access = public)

        function obj = FEMcomputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.computeStiffnessMatrix();
            obj.computeForceVector();
            obj.computeDOFmanagement();
            obj.computeDisplacements();
        end

    end

    methods (Access = private)

        function obj = init(obj,cParams)
            obj.solverType = cParams.type.solverType;
            obj.data       = cParams.input.data;
            obj.dim        = cParams.input.dim;
        end

        function obj = computeStiffnessMatrix(obj)
            s.data = obj.data;
            s.dim  = obj.dim;
            solution = StiffnessMatrixComputer(s);
            solution.compute();
            obj.stiffnessMatrix = solution.stiffnessMatrix;
        end

        function obj = computeForceVector(obj)
            s.data = obj.data;
            s.dim  = obj.dim;
            solution = ForceVectorComputer(s);
            solution.compute();
            obj.forceVector = solution.forceVector;
        end

        function computeDOFmanagement(obj)
            s.data  = obj.data;
            s.dim   = obj.dim;
            solution = DOFmanager(s);
            solution.compute();
            obj.dofManager = solution;
        end

        function computeDisplacements(obj)
            s.data            = obj.data;
            s.dim             = obj.dim;
            s.dofManager      = obj.dofManager;
            s.stiffnessMatrix = obj.stiffnessMatrix;
            s.forceVector     = obj.forceVector;
            s.solverType      = obj.solverType;
            solution = DisplacementsComputer(s);
            solution.compute();
            obj.displacements = solution.displacements;
        end

    end
end