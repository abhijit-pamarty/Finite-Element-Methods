function GMSH_reader(filename)
    addpath("mesh")
    meshfl = fopen(filename);
    line = fgetl(meshfl);
    nodes = [];
    point_elem = [];
    line_elem = [];
    tri_elem = [];
    quad_elem = [];
    %this flag keeps an eye if unsupported element types are encountered.
    flag = 0;
    %this next variable is for all the unsupported elements.
    unsup_elem = [ 4, 5 , 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 92, 93];
    while ischar(line)
        
        %error handling for mesh format being incorrect
        if strcmp(line, "$MeshFormat")
            format_code = fgetl(meshfl);
            if contains(format_code,"2.2")
                disp("mesh format is correct, reading")
            else
                disp("mesh format is incorrect")
                disp("exiting")
                return
            end
        end
        
        %error handling for physical names
        if strcmp(line, "$PhysicalNames")
            disp("mesh reader does not support physical names")
            disp("exiting")
            return
        end

        %read nodes
        if strcmp(line, "$Nodes")
                
            nNodes = fscanf(meshfl,'%d',[1]);
       
            nodes = fscanf(meshfl,'%d %f %f %f',[4, nNodes]);
            nodes = nodes';
        end

        if strcmp(line, "$Elements")
            nElems = fscanf(meshfl,'%d',[1]);
            line = fgetl(meshfl);
            i = 1;
            while i < nElems-1
                line = fgetl(meshfl);
                nline = split(line,' ');
                nline = str2double(nline);
                nline = nline';

                if nline(2) == 15
                    point_elem = [point_elem; nline(end)];
                end

                if nline(2) == 1
                    line_elem = [line_elem; nline(end-1:end )];
                end
                
                if nline(2) == 2
                    tri_elem = [tri_elem; nline(end-2:end )];
                end

                if nline(2) == 3
                    quad_elem = [quad_elem; nline(end-3:end )];
                end
                if ismember(nline(2),unsup_elem)
                    flag =1;
                end

                i = i+ 1;
                
            end
        end

        line = fgetl(meshfl);
        end
    if flag == 1
        disp("one or more element types are not supported")
    end
    disp("done")