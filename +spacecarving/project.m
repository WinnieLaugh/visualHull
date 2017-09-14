function [im_x, im_y] = project( camera, world_X, world_Y, world_Z )
%PROJECT: project a 3D point into an image
%
%   [IM_X,IM_Y] = PROJECT(CAMERA,WORLD_X,WORLD_Y,WORLD_Z) projects one or
%   more 3D point in the world coordinate frame into image coordinates

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $

z = camera.rawP(3,1) * world_X ...
    + camera.rawP(3,2) * world_Y ...
    + camera.rawP(3,3) * world_Z ...
    + camera.rawP(3,4);
im_y = round( (camera.rawP(2,1) * world_X ...
    + camera.rawP(2,2) * world_Y ...
    + camera.rawP(2,3) * world_Z ...
    + camera.rawP(2,4)) ./ z);
im_x = round( (camera.rawP(1,1) * world_X ...
    + camera.rawP(1,2) * world_Y ...
    + camera.rawP(1,3) * world_Z ...
    + camera.rawP(1,4)) ./ z);
