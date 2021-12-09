classdef (Abstract) Solver < handle

properties (Access = protected)
    LHS
    RHS
end

    methods (Static, Access = public)

        function type = create (cParams)
            switch cParams.type
                case {'Direct'}
                    type = DirectSolver(cParams);
                case {'Iterative'}
                    type = IterativeSolver(cParams);
                otherwise
                    error('Invalid solver type')
            end
        end

    end

    methods (Access = protected)

        function obj = init(obj,cParams)
            obj.LHS = cParams.LHS;
            obj.RHS = cParams.RHS;
        end
        
    end

     methods (Abstract)
        solve(obj)
     end
end

     