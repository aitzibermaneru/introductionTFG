%% -------- OBJECT ORIENTED PROGRAMMING --------
% 
%           2D beams: Aircraft catapult 
%

function main

fileName = 'Data.m';

[data,dim,loadedDisplacements] = loadData(fileName);

s.data = data;
s.dim = dim;
s.loadedDisplacements = loadedDisplacements;


FEMsolverdisplacements = FEMsolver(s);
FEMsolverdisplacements.compute();
displacements = FEMsolverdisplacements.displacements;
%dim = FEMsolverdisplacements.dim;
loadedDisplacements = FEMsolverdisplacements.loadedDisplacements;
value = FEMsolverdisplacements.value;

end

function [data,dim,loadedDisplacements] = loadData(fileName)
run(fileName)
end
