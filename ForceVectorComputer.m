classdef ForceVectorComputer < handle

    properties (Access = public)
        data
        dim
        forceVector
    end

    methods (Access = public)

        function obj = ForceVectorComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.computeForceVector();
        end

    end

    methods (Access = private)

        function obj = init(obj,cParams)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
        end
        

        function obj = computeForceVector(obj)
            nDofN = obj.dim.ni;
            nDof  = obj.dim.ndof;
            f     = obj.data.fdata1;

            Fext=zeros(nDof,1);

            for i=1:size(f,1)
                a=nDofN*f(i,1)-(nDofN-f(i,2));
                Fext(a)=f(i,3);
            end

            obj.forceVector = Fext;

        end
    end
end