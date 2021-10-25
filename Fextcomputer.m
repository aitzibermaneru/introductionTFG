classdef Fextcomputer < handle 
    % Computer of global external forces vector

    properties
        dim
        data

        forcesvector
    end

    methods
        function obj = Fextcomputer(data,dim)
           obj.data = data;
           obj.dim = dim;
           
           obj.Fextcomputation();
        end

        function obj = Fextcomputation(obj)
            dimv = obj.dim;
            datav = obj.data;
            % Definición de las fuerzas externas
            Fext=zeros(dimv.ndof,1);

            for i=1:size(fdata,1)
                a=dimv.ni*datav.fdata1(i,1)-(dimv.ni-datav.fdata1(i,2));
                Fext(a)=fdata1(i,3);
            end

            obj.forcesvector = Fext;

        end

    end
end