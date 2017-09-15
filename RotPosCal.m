function cameras = RotPosCal()

nw = 320;
nh = 240;

w = 36;
ratio = 1.333;
h = w/ratio;

f = 52.5;


cx = nw/2;
cy = nh/2;

dx = w/nw;
dy = h/nh;

fx = f/dx;
fy = f/dy;

K = [fx, 0, cx; 0, fy, cy; 0, 0, 1];

cameras = struct( ...
    'P', {}, ...
    'K', {}, ...
    'R', {}, ...
    'T', {});

for i=1:10
    
    cameras(i).K = K;
    
    thetaY = -(pi/5) * i;
    posx = 80 * cos( pi/2 + thetaY);
    posy = 80 * sin( pi/2 + thetaY);
    posz = 0;
    T = [posx; posy; posz];
    cameras(i).T = T;

    iB = [1;0;0];
    jB = [0;1;0];
    kB = [0;0;1];
    
    iA = [cos(pi + thetaY), sin(pi + thetaY), 0];
    jA = [0,0,1];
    kA = [cos(pi*1.5 + thetaY), sin(pi*1.5 + thetaY), 0];
    
    aRb = [iA*iB, iA*jB, iA*kB; jA*iB, jA*jB, jA*kB; kA*iB, kA*jB, kA*kB];
    cameras(i).R = aRb;
        
    T = - aRb*T;
    
    comRP =[aRb, T];
    
    p0 = K * comRP ;
    
    cameras(i).P = p0;
    
end

