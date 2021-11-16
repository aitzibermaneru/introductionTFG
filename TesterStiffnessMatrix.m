classdef TesterStiffnessMatrix < handle

    properties (Access = public)
        stiffnessMatrix 
    end

    properties (Access = private )
        data
        dim
        loadedKG
    end

    methods (Access = public)

         function obj = TesterStiffnessMatrix(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)  
           obj.computeStiffnessMatrix();
           obj.checkStiffnessMatrix();
        end

     end

    methods (Access = private)

        function obj = init(obj,cParams)
             obj.loadedKG = cParams.loadedKG ;
             obj.data     = cParams.data;
             obj.dim      = cParams.dim;
        end

        function computeStiffnessMatrix(obj)
            s.data = obj.data;
            s.dim  = obj.dim;
            solution = StiffnessMatrixComputer(s);
            solution.compute();
            obj.stiffnessMatrix = solution.stiffnessMatrix;
        end

        function checkStiffnessMatrix(obj)
            s.parameter       = obj.stiffnessMatrix;
            s.loadedParameter = obj.loadedKG;
            s.parameterName            = 'Stiffness matrix is';
            solution = CheckComputer(s);
            solution.compute();
        end

    end
end

           