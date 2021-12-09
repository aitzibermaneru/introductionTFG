%% -------- OBJECT ORIENTED PROGRAMMING --------
% 
%           2D beams: Aircraft catapult 
%

function FEMrunner
input = 'inputData.m';
s.input = loadInputData(input);
s.type = loadSolverType();
FEMsolverdisplacements = FEMcomputer(s);
FEMsolverdisplacements.compute();
displacements = FEMsolverdisplacements.displacements
end

function s = loadInputData(input)
run(input)
s.data = data;
s.dim = dim;
end

function s = loadSolverType()
solver_type = 'Solver type (Iterative or Direct): '; 
s.solverType = input(solver_type,"s");
end