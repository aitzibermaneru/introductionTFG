classdef Tester < handle

    properties (Access = private)
        dim
        data
        loadedKG
        loadedFext
        loadedDisplacements
        stiffnessMatrix
        forceVector
        displacements
    end

     methods (Access = public)

        function obj = Tester(cParams)
            obj.init(cParams);
        end

        function compute(obj)  
           obj.computeFEMSolver();
           obj.computeTesterStiffnesMatrix();
           obj.computeTesterForceVector();
           obj.computeTesterDisplacements();
        end

     end


     methods (Access = private)

         function init(obj,cParams)
             obj.data                = cParams.input.data;
             obj.dim                 = cParams.input.dim;
             obj.loadedKG            = cParams.output.KG;
             obj.loadedFext          = cParams.output.Fext;
             obj.loadedDisplacements = cParams.output.u;
         end

         function computeFEMSolver(obj)
            s.data = obj.data;
            s.dim  = obj.dim;
            solution = FEMsolver(s);
            solution.compute();
            obj.stiffnessMatrix = solution.stiffnessMatrix;
            obj.forceVector     = solution.forceVector;
            obj.displacements   = solution.displacements;
         end

         function computeTesterStiffnesMatrix(obj)
             s.loadedKG = obj.loadedKG;
             s.KG       = obj.stiffnessMatrix;
             solution = TesterStiffnessMatrix(s);
             solution.compute();
         end

         function computeTesterForceVector(obj)
             s.loadedFext = obj.loadedFext;
             s.Fext       = obj.forceVector;
             solution = TesterForceVector(s);
             solution.compute();
         end

         function computeTesterDisplacements(obj)
             s.displacements       = obj.displacements;
             s.loadedDisplacements = obj.loadedDisplacements;
             solution = TesterDisplacements(s);
             solution.compute();
         end

     end
end


