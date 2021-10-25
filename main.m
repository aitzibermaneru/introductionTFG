%% -------- OBJECT ORIENTED PROGRAMMING --------
% 
%           2D beams: Aircraft catapult 
%

function main

fileName = 'Data.m';

[data,dim,loadeddisplacement] = loadData(fileName);

s.data = data;
s.dim = dim;
s.loadeddisplacement = loadeddisplacement;


FEMsolverdisplacements = FEMsolver(s);
FEMsolverdisplacements.compute();
displacements = FEMsolverdisplacements.displacements

end

function [data,dim,loadeddisplacement] = loadData(fileName)
run(fileName)
end
