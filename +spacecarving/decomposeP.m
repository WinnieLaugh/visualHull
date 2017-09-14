function [K,R,t] = decomposeP(P)
%DECOMPOSEP  decompose a projection matrix into internal and external params
%
%   [K,R,T] = DECOMPOSEP(P) decomposes projection matrix P into the
%   internal camera parameter matrix K and external params for rotation R
%   and translation t. The original matrix is then recomposed as P=K*[R,t]

[q,r] = qr(inv(P(1:3,1:3)));
invK = r(1:3,1:3);
R = inv(q);
% A rotation matrix should have unity determinant, but QR only gaurantees
% a unitary matrix Q. Correct for sign here.
if det( R ) < 0
    R = -R;
    invK = -invK;
end
K = inv(invK);
t = invK*P(:,4);
