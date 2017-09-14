function [voxels,keep] = carve( voxels, camera )


% Project into image
[x,y] = spacecarving.project( camera, voxels.XData, voxels.YData, voxels.ZData );

% Clear any that are out of the image
[h,w,d] = size(camera.Image); 
keep = find( (x>=1) & (x<=w) & (y>=1) & (y<=h) );
x = x(keep);
y = y(keep);

% Now clear any that are not inside the silhouette
ind = sub2ind( [h,w], round(y), round(x) );
keep = keep(camera.Silhouette(ind) >= 1);

voxels.XData = voxels.XData(keep);
voxels.YData = voxels.YData(keep);
voxels.ZData = voxels.ZData(keep);
voxels.Value = voxels.Value(keep);
