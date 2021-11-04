%% -------- OBJECT ORIENTED PROGRAMMING --------
% 
%           2D beams: Aircraft catapult 
%

function main

fileName = 'Data.m';

[data,dim] = loadData(fileName);

s.data = data;
s.dim = dim;

FEMsolverdisplacements = FEMsolver(s);
FEMsolverdisplacements.compute();
displacements = FEMsolverdisplacements.displacements;

loadedDisplacements = loadDisplacements(fileName);
sT.displacements = displacements;
sT.loadedDisplacements = loadedDisplacements;
TesterDisplacements = Tester(sT);
TesterDisplacements.compute();
value = TesterDisplacements.value;


end

function [data,dim] = loadData(fileName)
run(fileName)
end

function loadedDisplacements = loadDisplacements(fileName)
run(fileName)
end