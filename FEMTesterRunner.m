%% ------------- TESTER --------
% 
%     2D beams: Aircraft catapult 
% ------------------------------

function FEMTesterRunner
inputData = 'inputData.m';
loadedData = 'loadedData.m';
s.input = loadInputData(inputData);
s.loaded = loadLoadedData(loadedData);
s.solverType = 'Iterative';
test = Tester(s);
test.compute();
end

function s = loadInputData(input)
run(input)
s.data = data;
s.dim = dim;
end

function s = loadLoadedData(loaded)
run(loaded)
s.KG   = load.KG;
s.Fext = load.Fext;
s.u    = load.u;
end


