classdef StiffnessMatrixTester < handle

    properties (Access = private )
        data
        dim
        loadedKG
        stiffnessMatrix
        value
        check
    end

    methods (Access = public)

        function obj = StiffnessMatrixTester(cParams)
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
             obj.check    = cParams.check;
        end

        function computeStiffnessMatrix(obj)
            s.data = obj.data;
            s.dim  = obj.dim;
            solution = StiffnessMatrixComputer(s);
            solution.compute();
            obj.stiffnessMatrix = solution.stiffnessMatrix;
        end

        function checkStiffnessMatrix(obj)
            KG       = obj.stiffnessMatrix;
            lKG = obj.loadedKG;
            value = obj.check.checking(KG,lKG);
        end

    end
end
