classdef ForceVectorComputer < handle

    properties (Access = public)
        forceVector
    end

    properties (Access = private)
        data
        dim
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
            Fnod  = obj.data.fdata1(:,1);
            Fdof  = obj.data.fdata1(:,2);
            Fmag  = obj.data.fdata1(:,3);
            Fext=zeros(nDof,1);
            for i=1:size(Fnod,1)
                a=nDofN*Fnod(i)-(nDofN-Fdof(i));
                Fext(a)=Fmag(i);
            end
            obj.forceVector = Fext;
        end
    end
end