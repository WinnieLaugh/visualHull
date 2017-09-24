function [xlimts, ylimts, zlimts] = myIO()

Dir = fullfile( fileparts( mfilename( 'fullpath' ) ), 'obj' );
filename = fullfile(Dir, 'final_bird.obj');


Obj_data = importdata(filename);

kind = Obj_data.textdata;

x = Obj_data.data(:,1);
y = Obj_data.data(:,2);
z = Obj_data.data(:,3);

N = size(Obj_data.textdata,1);

index = 1;

for i=2:N    
    if kind{i} ~= 'v'
        index = i;
        break;
    end         
end

if index > 1
    index = index - 1;
else
    error('wrong data at %s', filename);
end


v_del = index:N-1;

x(v_del,:) = [];
x(1,:) = [];
y(v_del,:) = [];
y(1,:) = [];
z(v_del,:) = [];
z(1,:) = [];

xlimts = [min( x(:,1) ), max( x(:,1) )];
ylimts = [min( y(:,1) ), max( y(:,1) )];
zlimts = [min( z(:,1) ), max( z(:,1) )];








