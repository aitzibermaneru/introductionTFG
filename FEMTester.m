%% ------------- TESTER --------
% 
%     2D beams: Aircraft catapult 
% ------------------------------

function FEMTester
inputData = 'inputData.m';
loadedData = 'loadedData.m';
s.input = loadInputData(inputData);
s.loaded = loadLoadedData(loadedData);
FEMTester = Tester(s);
FEMTester.compute();
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


