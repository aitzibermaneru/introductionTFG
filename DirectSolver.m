classdef DirectSolver < Solver

    methods (Access = public)
        function obj = DirectSolver(cParams)
            obj.init(cParams);
        end
    end

    methods (Access = public)

        function solution = solve(obj)
            solution = obj.LHS\obj.RHS;
        end

    end

end