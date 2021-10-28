classdef Tester < handle 

    properties

        loadedDisplacements
        displacements
        value

    end

     methods (Access = public)

        function obj = Tester(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)  
           obj.testerCompute();
        end

     end


     methods (Access = private)
         function obj = init(obj,cParams)
             obj.loadedDisplacements = cParams.loadedDisplacements;
             obj.displacements = cParams.displacements;
         end

         function obj = testerCompute(obj)
             displacementsv = obj.displacements;
             loadedDisplacementsv = obj.loadedDisplacements;
             loadedDisplacementsv = loadedDisplacementsv.';
             valuev = 1;
             for i=1:length(displacementsv)
                 if abs(displacementsv(i,1)-loadedDisplacementsv(i,1)) > 1e-10
                     valuev = 0;
                     error='Uncorrect displacement';
                     disp(error)
                 end
             end
             if valuev == 1
                 sol='Displacements are correct';
                 disp(sol)
             end
             obj.value = valuev;
         end

     end
end


