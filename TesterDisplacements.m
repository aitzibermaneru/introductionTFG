classdef TesterDisplacements < TestComputer

   properties (Access = private )
       data
       dim
       stiffnessMatrix
       forceVector
       loadedDisplacements
       displacements
       dofManager
       solverType
   end

     methods (Access = public)

         function obj = TesterDisplacements(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.computeDOFmanagement();
            obj.computeDisplacements();
            obj.checking();
            obj.result();
        end

     end

     methods (Access = private)

         function obj = init(obj,cParams)
             obj.data                = cParams.data;
             obj.dim                 = cParams.dim;
             obj.forceVector         = cParams.forceVector;
             obj.stiffnessMatrix     = cParams.stiffnessMatrix;
             obj.solverType          = cParams.solverType;
             obj.parameterName  = 'Displacements:';
             obj.loadedParameter = cParams.loadedDisplacements ;
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
             obj.parameter = solution.displacements;
         end

     end
end