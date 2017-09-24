function [ ] = ImageNoise()
%IMAGENOISE Summary of this function goes here
%   Detailed explanation goes here

dataDir = fullfile( fileparts( mfilename( 'fullpath' ) ), 'Data' );
datadir = fullfile( fileparts( mfilename( 'fullpath' ) ), 'Noise' );

noise_size = 1;


for i = 1:2
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
    
    I = imread( filename );
    [row,column] = size(I);
    column = column / 3;
    I0 = zeros(row, column, 3);
    
    I0 = im2uint8(I0);
    
    for ii = 1:row
        for ij = 1:column
                noisex = normrnd(0,noise_size);
                noisey = normrnd(0,noise_size);
                
                x = ii + round(noisex);
                y = ij + round(noisey);
                
                if (x>=1) && (x<=row) && (y>=1) && (y<=column)
                    I0(x,y,1) = I(ii,ij,1);
                    I0(x,y,2) = I(ii,ij,2);
                    I0(x,y,3) = I(ii,ij,3);
                end
            
        end
    end
    
    filenameOut = fullfile( datadir, sprintf( 'good%04d.jpg', i ));
    imwrite(I0, filenameOut, 'jpg');

end

