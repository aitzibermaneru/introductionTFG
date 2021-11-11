classdef FEMsolver < handle

    properties (Access = public)
        stiffnessMatrix
        forceVector
        displacements
    end

    properties (Access = private)
        data
        dim
    end


    methods (Access = public)

        function obj = FEMsolver(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.computeStiffnessMatrix();
            obj.computeForceVector();
            obj.computeDisplacements();
        end

    end

    methods (Access = private)

        function obj = init(obj,cParams)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
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

        function obj = computeDisplacements(obj)
            s.data            = obj.data;
            s.dim             = obj.dim;
            s.stiffnessMatrix = obj.stiffnessMatrix;
            s.forceVector     = obj.forceVector;
            solution = DisplacementsComputer(s);
            solution.compute();
            obj.displacements = solution.displacements;
        end

    end
end