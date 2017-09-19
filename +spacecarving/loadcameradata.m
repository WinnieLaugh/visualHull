function cameras = loadcameradata(dataDir, idx)
%LOADCAMERADATA: Load the dino data
%
%   CAMERAS = LOADCAMERADATA() loads the dinosaur data and returns a
%   structure array containing the camera definitions. Each camera contains
%   the image, internal calibration and external calibration.
%
%   CAMERAS = LOADCAMERADATA(IDX) loads only the specified file indices.



%Here is camera definition.
%K represents camera Intrinsic matrix  (focal length+ distortion)3*3
%p: principle point
%R,T represents the external parameters of camera(3*4).
cameras = struct( ...
    'Image', {}, ...
    'P', {}, ...
    'K', {}, ...
    'R', {}, ...
    'T', {}, ...
    'Silhouette', {} );


%% First, import the camera Pmatrices
load( fullfile( dataDir, 'dino_Ps.mat') );


%% The index of the rotate should be decided by the number of rawP
if nargin<2
    idx = 1:numel(rawP);
end


%% Now loop through loading the images
tmwMultiWaitbar('Loading images',0);
for ii=idx(:)'
    % We try both JPG and PPM extensions, trying JPG first since it is
    % the faster to load
    filename = fullfile( dataDir, sprintf( 'cart%04d.jpg', ii ) );
    if exist( filename, 'file' )~=2
        % Try PPM
        filename = fullfile( dataDir, sprintf( 'viff.%03d.ppm', ii ) );
        if exist( filename, 'file' )~=2
            % Failed
            error( 'SpaceCarving:ImageNotFound', ...
                'Could not find image %d (''cart%04d.jpg/.ppm'')', ...
                ii, ii );
        end
    end
     
%     [K,R,t] = spacecarving.decomposeP(rawP.p{ii});
    cameras(ii).rawP = rawP(ii).P;
    cameras(ii).P = rawP(ii).P;
%     cameras(ii).K = K/K(3,3);
    cameras(ii).K = rawP(ii).K;
    cameras(ii).R = rawP(ii).R;
    cameras(ii).T = rawP(ii).T;
    cameras(ii).Image = imread( filename );
    cameras(ii).Silhouette = [];
    tmwMultiWaitbar('Loading images',ii/max(idx));
end
tmwMultiWaitbar('Loading images','close');

