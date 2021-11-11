classdef TesterStiffnessMatrix < handle

 
   properties (Access = public )
        loadedKG
        KG
        value
   end

     methods (Access = public)

         function obj = TesterStiffnessMatrix(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)  
           obj.computeTesterStiffnessMatrix();
        end

     end

    methods (Access = private)

        function obj = init(obj,cParams)
             obj.loadedKG = cParams.loadedKG ;
             obj.KG       = cParams.KG;
        end

        function obj = computeTesterStiffnessMatrix(obj)
            Kg     = obj.KG;
            loadKg = obj.loadedKG;
            v = 1;
            for irow=1:size(Kg,1)
                for icolum=1:size(Kg,2)
                    if abs(Kg(irow,icolum)-loadKg(irow,icolum)) > 1e-3
                        v = 0;
                        error = 'Uncorrect stiffness matrix';
                        disp(error)
                    end
                end
            end
            if v == 1
                sol = 'Stiffness Matrix is correct';
                disp(sol)
            end
            obj.value = v;
        end
    end
end