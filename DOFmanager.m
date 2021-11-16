classdef DOFmanager < handle
    
    properties (Access = public)
        KLL
        KLR
        KRR
        KRL
        FL 
        FR
        ur
        vector
    end
    
    properties (Access = private)
        dim
        data
        vl
        vr
    end

    methods (Access = public)
        
        function obj = DOFmanager(cParams)
            obj.init(cParams);
        end

        function compute(obj)
        obj.computefixedDOF();
        obj.computeFreeDOF();
        end

        function K = splitMatrix(obj,KG)
            vlv = obj.vl;
            vrv = obj.vr;
            K.LL = KG(vlv,vlv);
            K.LR = KG(vlv,vrv);
            K.RL = KG(vrv,vlv);
            K.RR = KG(vrv,vrv);
        end

        function F = splitVector (obj,Fext)
            vlv = obj.vl;
            vrv = obj.vr;
            F.L = Fext(vlv);
            F.R = Fext(vrv);
        end

        function vector = joinVector(obj,vecL,vecR)
            vlv = obj.vl;
            vrv = obj.vr;
            vec = zeros(length(vecL)+length(vecR),1);
            for i=1:size(vrv,2)
                vec(vrv(i)) = vecR(i);
            end
            for i=1:size(vlv,1)
                vec(vlv(i)) = vecL(i);
            end
            vector = vec;
        end

    end
        
    methods (Access = private)

        function obj = init(obj,cParams)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
        end

         function computefixedDOF(obj)
            nDofN = obj.dim.ni;
            fxnod = obj.data.fixnod;    
            vrv = zeros(size(fxnod,1),1);            
            for i=1:size(fxnod,1)
                node = fxnod(i,1);
                dof  = fxnod(i,2);
                a = nDofN*node-(nDofN-dof);
                vrv(i) = a;
            end 
            urv = fxnod(:,3);
            obj.ur = urv;
            obj.vr = vrv;
        end

        function computeFreeDOF(obj)
            nDof = obj.dim.ndof;
            vrv = obj.vr;
            vlv = setdiff(1:nDof,vrv);
            vlv = vlv';
            obj.vl = vlv;
        end
        
    end
    
end