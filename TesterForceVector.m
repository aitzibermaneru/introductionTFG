classdef TesterForceVector < handle

    properties (Access = public)
        forceVector 
    end
   
      properties(Access = private )
        data
        dim
        loadedFext
      end
      
      methods(Access = public)
          
          function obj = TesterForceVector(cParams)
            obj.init(cParams)
          end
          
          function obj = compute(obj)
              obj.computeForceVector();
              obj.checkForceVector();
          end
          
      end
      
    methods(Access = private)
        
        function init(obj,cParams)
             obj.loadedFext = cParams.loadedFext ;
             obj.data       = cParams.data;
             obj.dim        = cParams.dim;
        end
        
        function computeForceVector(obj)
            s.data = obj.data;
            s.dim  = obj.dim;
            solution = ForceVectorComputer(s);
            solution.compute();
            obj.forceVector = solution.forceVector;
        end
        
        function checkForceVector(obj)
            s.parameter       = obj.forceVector;
            s.loadedParameter = obj.loadedFext;
            s.parameterName   = 'Force vector is';
            solution = CheckComputer(s);
            solution.compute();
        end      
   
    end
    
end