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

        function compute(obj)
            obj.computeForceVector();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
        end
        

        function computeForceVector(obj)
            nDof  = obj.dim.ndof;
            Fnod  = obj.data.fdata1(:,1);
            Fmag  = obj.data.fdata1(:,3);
            Fext = zeros(nDof,1);
            for i = 1:size(Fnod,1)
                iDof = obj.computeDOF(i);
                Fext(iDof)=Fmag(i);
            end
            obj.forceVector = Fext;
        end

        function iDof = computeDOF(obj,i)
            nDofN = obj.dim.ni;
            Fnod  = obj.data.fdata1(:,1);
            Fdim  = obj.data.fdata1(:,2);
            iDof = nDofN*Fnod(i) - (nDofN-Fdim(i));
        end
    end
end