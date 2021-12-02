classdef (Abstract) Solver < handle

    methods (Static, Access = public)

        function type = create (solverType)
            switch solverType
                case {'Direct'}
                    type = DirectSolver();
                case {'Iterative'}
                    type = IterativeSolver();
                otherwise
                    error('Invalid solver type')
            end
        end
    end
end

     