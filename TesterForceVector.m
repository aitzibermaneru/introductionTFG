classdef TesterForceVector < TestComputer

    properties (Access = public)
        forceVector 
    end
   
      properties(Access = private )
        data
        dim
      end
      
      methods(Access = public)
          
          function obj = TesterForceVector(cParams)
            obj.init(cParams)
          end
          
          function obj = compute(obj)
              obj.computeForceVector();
              obj.checking();
              obj.result();
          end

      end
      
    methods(Access = private)
        
        function init(obj,cParams)
             obj.data       = cParams.data;
             obj.dim        = cParams.dim;
             obj.parameterName  = 'Force Vector:';
             obj.loadedParameter = cParams.loadedFext ;
        end
        
        function computeForceVector(obj)
            s.data = obj.data;
            s.dim  = obj.dim;
            solution = ForceVectorComputer(s);
            solution.compute();
            obj.forceVector = solution.forceVector;
            obj.parameter   = solution.forceVector;
        end  
   
    end
    
end