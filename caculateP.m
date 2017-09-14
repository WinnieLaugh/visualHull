function P = caculateP()
%DECOMPOSEP  decompose a projection matrix into internal and external params
%
%   [K,R,T] = DECOMPOSEP(P) decomposes projection matrix P into the
%   internal camera parameter matrix K and external params for rotation R
%   and translation t. The original matrix is then recomposed as P=K*[R,t]

R = [-0.0101, -0.9992, 0.0395; 0.0469, 0.0390, 0.9981; -0.9989, 0.0119, 0.0464];

t = [-0.0092; 0.0468; 0.9989];

K = [-39.4552, 0.9640, -3.5547; 0, -28.1128, 13.1281; 0, 0, -0.0123];

P = K * [R, t];


