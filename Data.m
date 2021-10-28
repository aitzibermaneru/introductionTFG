%% Data and results 

%% INPUT DATA

% Material properties
E = 200e9; % Pa

% Cross-section parameters
d = 110e-3; % m
tA = 5e-3; % m
a = 25e-3; % m
b = 75e-3; % m
tB = 3e-3; % m

% Other data
T = 15e3; % N
Vto = 70; % m/s
dto = 65; % m
Mt = 15800; % kg
sig_rot = 230; % MPa
g = 9.81; % m/s2

% Geometric data
H1 = 0.22; % m
H2 = 0.36; % m
H3 = 0.48; % m
H4 = 0.55; % m
H5 = 2.1; % m
L1 = 0.9; % m
L2 = 0.5; % m
L3 = 0.5; % m
L4 = 2.5; % m
L5 = 4.2; % m
%% PREPROCESS

% Nodal coordinates
%  x(a,j) = coordinate of node a in the dimension j
data.x = [
      0,          H1; % Node 1
      0,       H1+H2; % Node 2
      0,    H1+H2+H3; % Node 3
      0, H1+H2+H3+H4; % Node 4
    -L1, H1+H2+H3+H4; % Node 5
];

% Nodal connectivities  
%  Tnod(e,a) = global nodal number associated to node a of element e
data.Tnod = [
    1, 2; % Element 1-2
    2, 3; % Element 2-3
    3, 4; % Element 3-4
    3, 5; % Element 3-5
];

% Material properties matrix
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  mat(m,3) = Section inertia of material m

IzA = pi*(((d+tA)/2)^4-((d-tA)/2)^4)/4 ;
IzB = 1/12*b*tB^3+2*(1/12*a^3*tB+a*tB*(b/2)^2);


AA = pi*(((d+tA)/2)^2-((d-tA)/2)^2);
AB = (b-tB)*tB+2*a*tB;
data.mat = [% Young M.        Section A.    Inertia 
               E,               AA,        IzA;  % Material 1
               E,               AB,        IzB;  % Material 2
];

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
data.Tmat = [
    1; % Element 1-2 / Material 1 (A)
    1; % Element 2-3 / Material 1 (A)
    1; % Element 3-4 / Material 1 (A)
    2; % Element 3-5 / Material 2 (B)
    
];

     
data.fixnod = [  
    4 1 0;
    4 2 0;
    4 3 0;
    5 1 0;
    5 2 0;
    5 3 0;
   
];

%% PRECOMPUTATIONS

% B.1
syms a t Pmax
resol1 = vpasolve(dto == 1/2*a*t^2, Vto == a*t, T+Pmax-Mt*a==0); 

a = eval(resol1.a);
t = eval(resol1.t);
Pmax = eval(resol1.Pmax);

% B.2

syms Nn6

alpha=atan(H1/L2);
resol2 = solve(T+Pmax/2-Nn6*cos(alpha)==0); 
Nn6 = double(resol2);

A_min = Nn6/sig_rot*10^-6;

% C.1

beta = atan((H2+H1)/L3);
Nn7 = (Pmax/2)/cos(beta);

syms N1 N2
resol3 = vpasolve(N1+N2-Mt*g-Nn6*sin(alpha)-Nn7*sin(beta)==0, (-N1*L5-Nn6*sin(alpha)*L4-Nn7*sin(beta)*L4+N2*L4)+(-Nn6*cos(alpha)*(H5-H1)+Nn7*cos(beta)*(H5-H1-H2))==0);

N1 = eval(resol3.N1);
N2 = eval(resol3.N2);

% C.2 

Nn7a = Pmax/cos(beta);

syms N1a N2a
resol4 = vpasolve(N1a+N2a-Nn7a*sin(beta)-Mt*g==0,-N1a*L5-Nn7a*sin(beta)*L4+N2a*L4+Nn7a*cos(beta)*(H5-H1-H2)==0);

N1a = eval(resol4.N1a);
N2a = eval(resol4.N2a);

%% External forces data 

data.fdata1=[                        % Static conditions
    1 1 -Nn6*cos(alpha);
    1 2 N2-Nn6*sin(alpha);
    2 1 Nn7*cos(beta);
    2 2 -Nn7*sin(beta);
    ];

data.fdata2=[                        % Dinamic conditions
    1 2 N2a;
    2 1 Pmax;
    2 2 -Pmax*tan(beta);
    ];

%% SOLVER 
    % Dimensions
dim.nd = size(data.x,2);   % Problem dimension
dim.nel = size(data.Tnod,1); % Number of elements (bars)
dim.nnod = size(data.x,1); % Number of nodes (joints)
dim.nne = size(data.Tnod,2); % Number of nodes in a bar
dim.ni = 3;           % Degrees of freedom per node
dim.ndof = dim.nnod*dim.ni;  % Total number of degrees of freedom


%% Displacements
loadedDisplacements = [-0.113878856337495, 0.000546255188627794, -0.185522553424696, -0.0516228943145986, 7.36371545191331e-05, -0.147754576674741, -0.00540007557439205, -8.88306693620010e-05, -0.0437407661100829, 0, 0, 0, 0, 0, 0];



