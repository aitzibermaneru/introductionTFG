%% ------------- TESTER --------
% 
%     2D beams: Aircraft catapult 
% ------------------------------

function FEMTester
output = 'outputData.m';
input = 'inputData.m';
s.input = loadInputData(input)
s.output = loadOutputData(output)
FEMTester = Tester(s);
FEMTester.compute();

end

function s = loadInputData (input)
run(input)
s.data = data;
s.dim = dim;
end

function s = loadOutputData(output)
run(output)
s.KG   = output.KG;
s.Fext = output.Fext;
s.u    = output.u;
end


