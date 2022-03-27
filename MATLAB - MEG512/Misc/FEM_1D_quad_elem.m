function FEM_1D_quad_elem(len_d, n_e)
    nodes = linspace(0,len_d,2*(n_e)+1)';
    n_nodes = size(nodes,1);
    elem_connect = [];
    
    for i = 1:n_e
            elem_connect = [elem_connect; i  i + 1 i + n_e + 1]; %quad elemen
    end
    i = 0;
    A = 0.01;
    E = 10E9;

    l_e = abs(nodes(elem_connect(:,2))-nodes(elem_connect(:,1))).*2;

    k_elem = ((E*A)./(3*l_e))*[7 ,1, -8, 1 , 7, -8, -8, -8, 16]; 
    F_B_elem = [4/15 -1/15 2/15 -1/15 4/15 2/15 2/15 2/15 16/15];
    F_T_elem = [4/15 -1/15 2/15 -1/15 4/15 2/15 2/15 2/15 16/15];


    k_global = zeros(n_nodes,n_nodes);
    F_B = zeros(n_nodes,1); %quad elemen
    F_T = zeros(n_nodes,1); %quad elemen
    F_P = zeros(n_nodes,1); %quad elemen
    f_b = repmat(27000,n_nodes,1);
    f_t = repmat(100,n_nodes,1);
    ele = 1;


        
    while ele <= n_e
        k_global(elem_connect(ele,1),elem_connect(ele,1)) = k_global(elem_connect(ele,1),elem_connect(ele,1)) + k_elem(ele,1);
        k_global(elem_connect(ele,2),elem_connect(ele,1)) = k_global(elem_connect(ele,2),elem_connect(ele,1)) + k_elem(ele,4);
        k_global(elem_connect(ele,1),elem_connect(ele,2)) = k_global(elem_connect(ele,1),elem_connect(ele,2)) + k_elem(ele,2);
        k_global(elem_connect(ele,2),elem_connect(ele,2)) = k_global(elem_connect(ele,2),elem_connect(ele,2)) + k_elem(ele,5);
        k_global(elem_connect(ele,1),elem_connect(ele,3)) = k_global(elem_connect(ele,1),elem_connect(ele,3)) + k_elem(ele,3);
        k_global(elem_connect(ele,3),elem_connect(ele,1)) = k_global(elem_connect(ele,3),elem_connect(ele,1)) + k_elem(ele,7);
        k_global(elem_connect(ele,3),elem_connect(ele,2)) = k_global(elem_connect(ele,3),elem_connect(ele,2)) + k_elem(ele,6);
        k_global(elem_connect(ele,2),elem_connect(ele,3)) = k_global(elem_connect(ele,2),elem_connect(ele,3)) + k_elem(ele,8);
        k_global(elem_connect(ele,3),elem_connect(ele,3)) = k_global(elem_connect(ele,3),elem_connect(ele,3)) + k_elem(ele,9);



        F_B(elem_connect(ele,1)) = F_B(elem_connect(ele,1)) + (F_B_elem(1)*f_b(elem_connect(ele,1)) + F_B_elem(2)*f_b(elem_connect(ele,2)) + F_B_elem(3)*f_b(elem_connect(ele,3)))*A*l_e(ele)*0.5;
        F_B(elem_connect(ele,2)) = F_B(elem_connect(ele,2)) + (F_B_elem(4)*f_b(elem_connect(ele,1)) + F_B_elem(5)*f_b(elem_connect(ele,2)) + F_B_elem(6)*f_b(elem_connect(ele,3)))*A*l_e(ele)*0.5;
        F_B(elem_connect(ele,3)) = F_B(elem_connect(ele,3)) + (F_B_elem(7)*f_b(elem_connect(ele,1)) + F_B_elem(8)*f_b(elem_connect(ele,2)) + F_B_elem(9)*f_b(elem_connect(ele,3)))*A*l_e(ele)*0.5;

        F_T(elem_connect(ele,1)) = F_T(elem_connect(ele,1)) + (F_T_elem(1)*f_t(elem_connect(ele,1)) + F_T_elem(2)*f_t(elem_connect(ele,2)) + F_T_elem(3)*f_t(elem_connect(ele,3)))*l_e(ele)*0.5;
        F_T(elem_connect(ele,2)) = F_T(elem_connect(ele,2)) + (F_T_elem(4)*f_t(elem_connect(ele,1)) + F_T_elem(5)*f_t(elem_connect(ele,2)) + F_T_elem(6)*f_t(elem_connect(ele,3)))*l_e(ele)*0.5;
        F_T(elem_connect(ele,3)) = F_T(elem_connect(ele,3)) + (F_T_elem(7)*f_t(elem_connect(ele,1)) + F_T_elem(8)*f_t(elem_connect(ele,2)) + F_T_elem(9)*f_t(elem_connect(ele,3)))*l_e(ele)*0.5;

        ele = ele+ 1;
    end
    
    
    
    u = zeros(n_nodes,1);
    u(1) = 0;
    F = F_B + F_T + F_P;
    rhs = F - k_global*u;
    Dir_Nodes = 1;
    free_nodes = setdiff(1:n_nodes, Dir_Nodes);
    u(free_nodes) = k_global(free_nodes,free_nodes)\rhs(free_nodes);
    
    u
