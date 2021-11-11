classdef TesterDisplacements < handle 

   properties (Access = public )
        loadedDisplacements
        displacements
        value
   end

     methods (Access = public)

         function obj = TesterDisplacements(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)  
           obj.computeTesterDisplacements();
        end

     end

    methods (Access = private)

        function obj = init(obj,cParams)
             obj.loadedDisplacements = cParams.loadedDisplacements;
             obj.displacements       = cParams.displacements;
        end

        function obj = computeTesterDisplacements(obj)
            u     = obj.displacements;
            loadu = obj.loadedDisplacements;
            loadu = loadu.';
            v     = 1;
            for i=1:length(u)
                if abs(u(i,1)-loadu(i,1)) > 1e-10
                    v = 0;
                    error = 'Uncorrect displacement';
                    disp(error)
                end
            end
            if v == 1
                sol = 'Displacements are correct';
                disp(sol)
            end
            obj.value = v;
        end
    end
end