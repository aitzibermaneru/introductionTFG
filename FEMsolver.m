classdef FEMsolver < handle
    % 2D beams: Aircraft catapult


    properties (Access = public)

        loadedDisplacements
        data
        dim

        stiffnessMatrix
        forceVector

        displacements

    end


    methods (Access = public)    

        function obj = FEMsolver(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.stiffnessMatrixCompute();
            obj.forceVectorCompute();
            obj.displacementsCompute();
        end

    end

    methods (Access = private)

        function obj = init(obj,cParams)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
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

%         function checktext
%           cuando compile comprobar que los resultados estan bien
%         end
    end
end