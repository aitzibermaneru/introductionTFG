classdef FEMsolver < handle
    % 2D beams: Aircraft catapult


    properties (Access = public)

        loadedDisplacements
        data
        dim

        stiffnessMatrix
        forceVector

        displacements
        value

    end


    methods (Access = public)    

        function obj = FEMsolver(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.stiffnessMatrixCompute();
            obj.forceVectorCompute();
            obj.displacementsCompute();
            obj.checkout();
        end

    end

    methods (Access = private)

        function obj = init(obj,cParams)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
            obj.loadedDisplacements = cParams.loadedDisplacements;
        end
 

        function obj = stiffnessMatrixCompute(obj)      
            s.data = obj.data;
            s.dim  = obj.dim;
            solution = StiffnessMatrixComputer(s);
            solution.compute();
            obj.stiffnessMatrix = solution.stiffnessMatrix;
        end


        function obj = forceVectorCompute(obj)
            d   = obj.dim;
            dat = obj.data ;

            Fext=zeros(d.ndof,1);

            for i=1:size(dat.fdata1,1)
                a=d.ni*dat.fdata1(i,1)-(d.ni-dat.fdata1(i,2));
                Fext(a)=dat.fdata1(i,3);
            end

            obj.forceVector = Fext;

        end

        
        function obj = displacementsCompute(obj)
            s.data = obj.data;
            s.dim = obj.dim;
            s.stiffnessMatrix = obj.stiffnessMatrix;
            s.forceVector = obj.forceVector;
            solution = DisplacementsComputer(s);
            solution.compute();
            obj.displacements = solution.displacements;
        end


        function obj = checkout(obj)
            s.loadedDisplacements = obj.loadedDisplacements;
            s.displacements = obj.displacements;
            solution = Tester(s);
            solution.compute();
            obj.value = solution.value;
        end

    end
end