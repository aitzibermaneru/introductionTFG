classdef Tester < handle

    properties (Access = public)
        stiffnessMatrix
        forceVector
    end

    properties (Access = protected)
        solverType
    end

    properties (Access = private)
        dim
        data
        loadedKG
        loadedFext
        loadedDisplacements
    end

     methods (Access = public)

        function obj = Tester(cParams)
            obj.init(cParams);
        end

        function compute(obj)  
           obj.computeTesterStiffnesMatrix();
           obj.computeTesterForceVector();
           obj.computeTesterDisplacements();
        end

     end

     methods (Access = private)

         function init(obj,cParams)
             obj.data                = cParams.input.data;
             obj.dim                 = cParams.input.dim;
             obj.loadedKG            = cParams.loaded.KG;
             obj.loadedFext          = cParams.loaded.Fext;
             obj.loadedDisplacements = cParams.loaded.u;
             obj.solverType          = cParams.solverType;
         end

         function computeTesterStiffnesMatrix(obj)
             s.data     = obj.data;
             s.dim      = obj.dim;
             s.loadedKG = obj.loadedKG;
             solution = TesterStiffnessMatrix(s);
             solution.compute();
             obj.stiffnessMatrix = solution.stiffnessMatrix;
         end

         function computeTesterForceVector(obj)
             s.data     = obj.data;
             s.dim      = obj.dim;
             s.loadedFext = obj.loadedFext;
             solution = TesterForceVector(s);
             solution.compute();
             obj.forceVector = solution.forceVector;
         end

         function computeTesterDisplacements(obj)
             s.data                = obj.data;
             s.dim                 = obj.dim;
             s.loadedDisplacements = obj.loadedDisplacements;
             s.stiffnessMatrix     = obj.stiffnessMatrix;
             s.forceVector         = obj.forceVector;
             s.solverType          = obj.solverType;
             solution = TesterDisplacements(s);
             solution.compute();
         end

     end
end


