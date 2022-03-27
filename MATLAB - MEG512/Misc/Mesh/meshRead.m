fid = fopen('test1.msh','r');

if fid == -1
    error('Filename does not exist');
end

while (~feof(fid))
   line = fgetl(fid); 
   
   if (strcmp(line,'$Nodes'))
       disp('Nodes key word found');
       
       % The below line is perfectly good to be used
       % nNodes = str2num( fgetl(fid));
       
       nNodes = fscanf(fid,'%d',[1]);
       
       nodes = fscanf(fid,'%f %f %f %f',[4, nNodes]);
       nodes = nodes';
   end
   
   
end