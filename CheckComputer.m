classdef CheckComputer < handle

    properties (Access = private)
        loadedParameter
        parameter
        parameterName
        correct
    end
    
    methods (Access = public)
        
        function obj = CheckComputer(cParams)
           obj.init(cParams);
        end
        
        function compute(obj)
             obj.checking();
             obj.result();
        end

    end

    methods (Access = private)

        function obj = init(obj,cParams)
            obj.loadedParameter = cParams.loadedParameter ;
            obj.parameter       = cParams.parameter;
            obj.parameterName   = cParams.parameterName;
        end

        function checking(obj)
            param    = obj.parameter;
            loadParam = obj.loadedParameter;
            v = 1;
            for irow=1:size(param,1)
                for icolum=1:size(param,2)
                    dif = abs(param(irow,icolum)-loadParam(irow,icolum));
                    if dif > 1e-3
                        v = 0;
                    end
                end
            end
            obj.correct = v;
        end

        function result(obj)
            value = obj.correct;
            name = obj.parameterName;
            if value
                disp([name,' correct '])
            else
                disp([name,' incorrect '])
            end
        end
    end
end