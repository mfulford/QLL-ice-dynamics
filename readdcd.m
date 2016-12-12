
function [xx, yy, zz] = readdcd(filename, ind, import_x, import_y, import_z)

% xyz = readdcd(filename, indices)
% reads an dcd and puts the x,y,z coordinates corresponding to indices 
% in the rows of x,y,z

h = read_dcdheader(filename);
nsets = h.NSET;
natoms = h.N;
numind = length(ind);

x = zeros(natoms,1);
y = zeros(natoms,1);
z = zeros(natoms,1);

if nsets == 0
  nsets = 99999;
  
  if import_x
      xx = zeros(1,numind);
  end
  if import_y
      yy = zeros(1,numind);
  end
  if import_z
      zz = zeros(1,numind);
  end
   
else
%   xyz = zeros(nsets, 3*numind);

  if import_x
      xx = zeros(nsets,numind);
  end
  if import_y
      yy = zeros(nsets,numind);
  end
  if import_z
      zz = zeros(nsets,numind);
  end

end

for i=1:nsets
  pos = ftell(h.fid);
  if pos == h.endoffile 
    break;
  end
  [x,y,z] = read_dcdstep(h);
  
  if import_x
      xx(i,1:numind) = x(ind)';
  end
  if import_y
      yy(i,1:numind) = y(ind)';
  end
  if import_z
      zz(i,1:numind) = z(ind)';
  end
  
   % If any of the variables don't exist. Create a dummy so can export
   % Won't be using the data - just means function won't crash
   if exist('xx') == 0
    xx=1;
   end
   if exist('yy') == 0
    yy=1;
   end
   if exist('zz') == 0
    zz=1;
   end
      

end

close_dcd(h);

