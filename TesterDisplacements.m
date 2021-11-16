classdef TesterDisplacements < handle 

   properties (Access = private )
       data
       dim
       stiffnessMatrix
       forceVector
       loadedDisplacements
       displacements
       dofManager
   end

     methods (Access = public)

         function obj = TesterDisplacements(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.computeDOFmanagement();
            obj.computeDisplacements();
            obj.checkDisplacements();
        end

     end

     methods (Access = private)

         function obj = init(obj,cParams)
             obj.loadedDisplacements = cParams.loadedDisplacements ;
             obj.data                = cParams.data;
             obj.dim                 = cParams.dim;
             obj.forceVector         = cParams.forceVector;
             obj.stiffnessMatrix     = cParams.stiffnessMatrix;
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
             solution = DisplacementsComputer(s);
             solution.compute();
             obj.displacements = solution.displacements;
         end

         function checkDisplacements(obj)
            s.parameter       = obj.displacements;
            s.loadedParameter = obj.loadedDisplacements;
            s.parameterName   = 'Displacements are';
            solution = CheckComputer(s);
            solution.compute();
         end


     end
end