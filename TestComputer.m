classdef TestComputer < handle
  
    properties (Access = protected)
        loadedParameter
        parameter
        parameterName
        correct
    end
    
    methods (Access = public)
        
        function obj = TestComputer()
        end
        

    end

    methods (Access = protected)

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
                disp([name,' Correct!'])
            else
                disp([name,' Incorrect! '])
            end
        end
    end
        
 end
    