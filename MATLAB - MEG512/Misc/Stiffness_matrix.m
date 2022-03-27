function Stiffness_matrix(row_number, column_number)
    node_x = row_number+1;
    node_y = column_number+1;
    elem_connect = [];
    for i = 1:row_number
        para = column_number+1;
        for j = 1:column_number
            elem_connect = [elem_connect; (para*(i-1))+j, (para*(i-1))+(j+1), (para*(i-1))+(j+column_number+2), (para*(i-1))+(j+column_number+1)];
        end
        %elem_connect = [elem_connect; (para*(i-1))+1, (para*(i-1))+2, (para*(i-1))+7, (para*(i-1))+6];
        %elem_connect = [elem_connect; (para*(i-1))+2, (para*(i-1))+3, (para*(i-1))+8, (para*(i-1))+7];
        %elem_connect = [elem_connect; (para*(i-1))+3, (para*(i-1))+4, (para*(i-1))+9, (para*(i-1))+8];
        %elem_connect = [elem_connect; (para*(i-1))+4, (para*(i-1))+5, (para*(i-1))+10, (para*(i-1))+9];
    end
    %only works with quad elements for now
    locals = ones(2,2);
    K = zeros(node_x*node_y,node_x*node_y);
    for i=1:size(elem_connect,1)
        for j = 1:4
            for k = 1:4
                K(elem_connect(i,j),elem_connect(i,k)) = K(elem_connect(i,j),elem_connect(i,k))+ locals(j,k);
            end
        end 
    end
    K