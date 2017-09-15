%% Setup
import spacecarving.*;

t1 = clock;
datadir = fullfile( fileparts( mfilename( 'fullpath' ) ), 'Data' );
close all;


%% Load the Camera and Image Data.
cameras = loadcameradata( datadir );

%% Silhouettes
for c=1:numel(cameras)
    cameras(c).Silhouette = getsilhouette( cameras(c).Image );
end


%% Work out the space
[xlim,ylim,zlim] = findmodel( cameras );

t2 = clock;
etime(t2,t1);

%% Create a Voxel Array
voxels = makevoxels( xlim, ylim, zlim, 600000 );
starting_volume = numel( voxels.XData );

figure('Position',[100 100 600 400]);
showscene( cameras, voxels );


%% Include All the Views
for ii=1:numel(cameras)
    voxels = carve( voxels, cameras(ii) );
end

figure('Position',[100 100 600 700]);
showsurface(voxels)

set(gca,'Position',[-0.2 0 1.4 0.95])

title( 'Result after 10 carvings' )
az = 0;
% changet the vertical elevation of the view point in degree to make the
% upside up in the view 180
el = 180;
view(az, el);
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
title( 'Result after 10 carvings with refinement' )


%% Final Result
figure('Position',[100 100 600 700]);
ptch = showsurface( voxels );
colorsurface( ptch, cameras );
set(gca,'Position',[-0.2 0 1.4 0.95])
axis off
title( 'Result after 10 carvings with refinement and colour' )

t3 = clock;
etime(t3,t2);