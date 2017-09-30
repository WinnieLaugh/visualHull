function cameras = RotPosCalNoise(percentage, percentageRot)

%% intrinsic Parameters
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



%% Noise Parameters
[xlim, ylim, zlim] = myIO();

sigmax = diff(xlim) * percentage;
sigmay = diff(ylim) * percentage;
sigmaz = diff(zlim) * percentage;

%% Ouput filepath
dataDir = fullfile( fileparts( mfilename( 'fullpath' ) ), 'Noise' );
filename_pos = fullfile( dataDir, sprintf('Pos%.4f.txt', percentage) );
filename_rot = fullfile( dataDir, sprintf('Rot%.4f.txt', percentageRot) );

fid_pos = fopen(filename_pos, 'w');
fid_rot = fopen(filename_rot, 'w');    

%% Generating Camera Parameters with noise
for i=1:100
    
    cameras(i).K = K;
    
    thetaY = -(pi/50) * i;
    posx = 80 * cos( pi/2 + thetaY);
    posy = 80 * sin( pi/2 + thetaY);
    posz = 0;
    T = [posx; posy; posz];
%  
    noisex = normrnd(0,sigmax);
    noisey = normrnd(0,sigmay);
    noisez = normrnd(0,sigmaz);
    
    T = T + [noisex; noisey; noisez];
    
    fprintf(fid_pos, '%d\n%f\n%f\n%f\n', i, T(1), T(2), T(3));
    
    iB = [1;0;0];
    jB = [0;1;0];
    kB = [0;0;1];
    
    noise_theta = normrnd(0, 2* pi * percentageRot);
    thetaY = thetaY + noise_theta;
    
    iA = [cos(pi + thetaY), sin(pi + thetaY), 0];
    %in 3ds max, it is a little bit different from the typical camera
    %parameters, ie. z is the opposite and y is the opposite
    jA = [0,0,1];
    kA = [-cos(pi*1.5 + thetaY), -sin(pi*1.5 + thetaY), 0];

    aRb = [iA*iB, iA*jB, iA*kB; jA*iB, jA*jB, jA*kB; kA*iB, kA*jB, kA*kB];
%     eulZYX = rotm2eul(aRb,'ZYX');
%     
%     eulZYX(1) = eulZYX(1) / pi * 180;
%     eulZYX(2) = eulZYX(2) / pi * 180;
%     eulZYX(3) = eulZYX(3) / pi * 180;
%     
%     fprintf(fid_rot, '%d\n%f\n%f\n%f\n', i, eulZYX(1), eulZYX(2), eulZYX(3));

    fprintf(fid_rot, '%d\n%f\n%f\n%f\n%f\n%f\n%f\n%f\n%f\n%f\n',...
            i,...
            aRb(1,1), aRb(1,2), aRb(1,3),...
            aRb(2,1), aRb(2,2), aRb(2,3),...
            aRb(3,1), aRb(3,2), aRb(3,3));

end

%%
fclose(fid_pos);
fclose(fid_rot);

