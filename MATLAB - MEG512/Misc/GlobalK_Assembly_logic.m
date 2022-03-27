x_cord = 0:0.25:1;
y_cord = 0:0.25:1;

[X_cord,Y_cord] = meshgrid(x_cord,y_cord);
rows = 4;
cols = 4;
elem_conn = [];
for i = 1:rows
    for j = 1:cols
        elem_conn = [elem_conn; (i-1)*(cols+1)+j, (i-1)*(cols+1)+j+1, i*(cols+1)+j+1, i*(cols+1)+j];
    end
end

elem_type = 'QUAD';

if(~strcmp(elem_type,'QUAD'))
    K_elem = ones(4,4);
    number_nodes_elem = 4;
elseif (~strcmp(elem_type,'TRI'))
    K_elem = ones(3,3);
    number_nodes_elem = 3;
end
K_global = zeros(25,25);
for i=1:size(elem_conn,1)
    for j = 1:number_nodes_elem
        for k = 1:number_nodes_elem
    K_global(elem_conn(i,j),elem_conn(i,k)) = K_global(elem_conn(i,j),elem_conn(i,k))+ K_elem(j,k);
        end
    end 
end