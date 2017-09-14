function voxels = carveall( voxels, cameras )


for ii=1:numel(cameras);
    voxels = carve(voxels,cameras(ii));
end