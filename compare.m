function [ dis ] = compare(percentage)
%COMPARE Summary of this function goes here
%   Detailed explanation goes here

import spacecarving.*

%%Set the data path
dataDir = fullfile( fileparts( mfilename( 'fullpath' ) ), 'bird' );
dataDir_noise = fullfile( fileparts( mfilename( 'fullpath' ) ), sprintf('NoiseImage\%.4f', percentage) );

dataDit_out_origin = fullfile( fileparts( mfilename( 'fullpath' ) ), Sprintf('Thin\Origin\%.4f', percentage) );
dataDit_out_noise = fullfile( fileparts( mfilename( 'fullpath' ) ), Sprintf('Thin\Noise\%.4f', percentage) );


threhold = 50;
percentage = zeros(100,1);

%% load the images and do the line thining
for i = 1:100
% i = 84;

    % -----------------------------load the images-------------------------
    filename = fullfile( dataDir, sprintf( 'turtle%04d.jpg', i ) );
    if exist( filename, 'file' )~=2
        % Try PPM
        filename = fullfile( dataDir, sprintf( 'viff.%03d.ppm', i ) );
        if exist( filename, 'file' )~=2
            % Failed
            error( 'SpaceCarving:ImageNotFound', ...
                'Could not find image %d (''turtle%04d.jpg/.ppm'')', ...
                i, i );
        end
    end
    
    
    filename_noise = fullfile( dataDir_noise, sprintf( 'bird%04d.jpg', i ) );
    if exist( filename_noise, 'file' )~=2
        % Try PPM
        filename_noise = fullfile( dataDir_noise, sprintf( 'viff.%03d.ppm', i ) );
        if exist( filename_noise, 'file' )~=2
            % Failed
            error( 'SpaceCarving:ImageNotFound', ...
                'Could not find image %d (''bird%04d.jpg/.ppm'')', ...
                i, i );
        end
    end
 
    Image = imread( filename );
    Image_Noise = imread(filename_noise);
    
    [a0,b0] = size(Image);
    b0 = b0/3;
    
    S = Image(:,:,1) > threhold;
    S_noise = Image_Noise(:,:,1) > threhold;
    
    S = uint8(S);
    S_noise = uint8(S_noise);
    
    Diff = zeros(a0,b0);

    %----------------------------Line thining------------------------------

    S_out = bwmorph(S, 'thin', Inf);
    S_noise_out = bwmorph(S_noise, 'thin', Inf);
    

    filenameOut = fullfile( dataDit_out_origin, sprintf( 'birdorigin%04d.jpg', i ));
    imwrite(S_out, filenameOut, 'jpg');
    filenameOut_Noise = fullfile( dataDit_out_noise, sprintf( 'birdnoise%04d.jpg', i ));
    imwrite(S_noise_out, filenameOut_Noise, 'jpg');
    
    
    
    %% Calculate the distance
    for ii = 10:a0-10
        for ij = 10:b0-10
            
            if(S_out(ii,ij)==1)
                mymin = 100;
                for indx = (ii-9):(ii+9)
                    for indy = (ij-9):(ij+9)
                        if S_noise_out(indx, indy) == 1
                            mymin = min(mymin, sqrt((ii-indx)*(ii-indx) + (ij-indy)*(ij-indy)));
                        end
                    end
                end
                
                Diff(ii,ij) = mymin;
            end
            
        end
    end
    
    count = 0;
    distance = 0;
    for ii = 1:a0
        for ij = 1:b0
            if Diff(ii,ij) ~= 0 && Diff(ii,ij) ~= 100
               distance = distance + Diff(ii,ij);
               count = count + 1;
            end
        end
    end
      
    
    percentage(i) = distance / count;
end

dis = mean(percentage);
