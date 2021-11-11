%% -------- OBJECT ORIENTED PROGRAMMING --------
% 
%           2D beams: Aircraft catapult 
%

function FEM
input = 'inputData.m';
s = loadInputData(input);
FEMsolverdisplacements = FEMsolver(s);
FEMsolverdisplacements.compute();
displacements = FEMsolverdisplacements.displacements;
end

function s = loadInputData(input)
run(input)
s.data = data;
s.dim = dim;
end

