classdef Tester < handle 

    properties (Access = public)
        loadedDisplacements
        displacements
         value
    end

     methods (Access = public)

        function obj = Tester(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)  
           obj.computeTesterDisplacements();
        end

     end


     methods (Access = private)
         function obj = init(obj,cParams)
             obj.loadedDisplacements = cParams.loadedDisplacements;
             obj.displacements = cParams.displacements;
         end

         function obj = computeTesterDisplacements(obj)
             s.displacements = obj.displacements;
             s.loadedDisplacements = obj.loadedDisplacements;
             solution = TesterDisplacements(s);
             solution.compute();
             obj.value = solution.value;
         end

     end
end


