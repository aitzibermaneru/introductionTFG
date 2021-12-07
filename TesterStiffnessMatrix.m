classdef TesterStiffnessMatrix < TestComputer

    properties (Access = public)
        stiffnessMatrix 
    end

    properties (Access = private )
        data
        dim
    end

    methods (Access = public)

         function obj = TesterStiffnessMatrix(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)  
           obj.computeStiffnessMatrix();
           obj.checking();
           obj.result();
        end

     end

    methods (Access = private)

        function obj = init(obj,cParams)
             obj.data     = cParams.data;
             obj.dim      = cParams.dim;
             obj.parameterName  = 'Stiffness Matrix:';
             obj.loadedParameter = cParams.loadedKG ;
        end

        function computeStiffnessMatrix(obj)
            s.data = obj.data;
            s.dim  = obj.dim;
            solution = StiffnessMatrixComputer(s);
            solution.compute();
            obj.stiffnessMatrix = solution.stiffnessMatrix;
            obj.parameter = solution.stiffnessMatrix;
        end
        
    end
end

           