classdef IterativeSolver < Solver

    methods (Access = public)
        function obj = IterativeSolver(cParams)
            obj.init(cParams);
        end
    end

    methods (Access = public)
        
        function solution = solve(obj)
            solution = pcg(obj.LHS,obj.RHS,[],1000);
        end

    end
end