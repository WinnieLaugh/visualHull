%% Setup
import spacecarving.*;

t1 = clock;
datadir = fullfile( fileparts( mfilename( 'fullpath' ) ), 'Data' );
close all;


%% Load the Camera and Image Data.
cameras = loadcameradata( datadir );

montage( cat( 4, cameras.Image ) );
set( gcf(), 'Position', [100 100 600 600] )
title( 'Dataset' )
axis off;

%% Silhouettes
for c=1:numel(cameras)
    cameras(c).Silhouette = getsilhouette( cameras(c).Image );
end

figure('Position',[100 100 600 300]);

subplot(1,2,1)
imshow( cameras(c).Image );
title( 'Original Image' )
axis off

subplot(1,2,2)
imshow( cameras(c).Silhouette );
title( 'Silhouette' )
axis off

makeFullAxes( gcf );

%% Work out the space
[xlim,ylim,zlim] = findmodel( cameras );

t2 = clock;
etime(t2,t1);

%% Create a Voxel Array
voxels = makevoxels( xlim, ylim, zlim, 6000000 );
starting_volume = numel( voxels.XData );

figure('Position',[100 100 600 400]);
showscene( cameras, voxels );

%% Carve the Voxels Using the First Camera Image

voxels = carve( voxels, cameras(1) );

% Show Result
figure('Position',[100 100 600 300]);
subplot(1,2,1)
showscene( cameras(1), voxels );
title( '1 camera' )
subplot(1,2,2)
showsurface( voxels )
title( 'Result after 1 carving' )


% Add More Views
% Adding more views refines the shape. If we include two more, we already
% have something recognisable, albeit a bit "boxy".
voxels = carve( voxels, cameras(4) );
voxels = carve( voxels, cameras(7) );

% Show Result
figure('Position',[100 100 600 300]);
subplot(1,2,1)
title( '3 cameras' )
showscene( cameras([1 4 7]), voxels );
subplot(1,2,2)
showsurface(voxels)
title( 'Result after 3 carvings' )


%% Now Include All the Views

for ii=1:numel(cameras)
    voxels = carve( voxels, cameras(ii) );
end
figure('Position',[100 100 600 700]);
showsurface(voxels)

set(gca,'Position',[-0.2 0 1.4 0.95])

title( 'Result after 100 carvings' )
az = 0;
el = 90;
view(az, el);
%view(3);
axis off
final_volume = numel( voxels.XData );
fprintf( 'Final volume is %d (%1.2f%%)\n', ...
    final_volume, 100 * final_volume / starting_volume )

%% Get real values
offset_vec = 1/3 * voxels.Resolution * [-1 0 1];
[off_x, off_y, off_z] = meshgrid( offset_vec, offset_vec, offset_vec );

num_voxels = numel( voxels.Value );
num_offsets = numel( off_x );
scores = zeros( num_voxels, 1 );
for jj=1:num_offsets
    keep = true( num_voxels, 1 );
    myvoxels = voxels;
    myvoxels.XData = voxels.XData + off_x(jj);
    myvoxels.YData = voxels.YData + off_y(jj);
    myvoxels.ZData = voxels.ZData + off_z(jj);
    for ii=1:numel( cameras )
        [~,mykeep] = carve( myvoxels, cameras(ii) );
        keep(setdiff( 1:num_voxels, mykeep )) = false;
    end
    scores(keep) = scores(keep) + 1;
end
voxels.Value = scores / num_offsets;
figure('Position',[100 100 600 700]);
showsurface( voxels );
set(gca,'Position',[-0.2 0 1.4 0.95])
axis off
title( 'Result after 100 carvings with refinement' )


%% Final Result
figure('Position',[100 100 600 700]);
ptch = showsurface( voxels );
colorsurface( ptch, cameras );
set(gca,'Position',[-0.2 0 1.4 0.95])
axis off
title( 'Result after 100 carvings with refinement and colour' )

t3 = clock;
etime(t3,t2);