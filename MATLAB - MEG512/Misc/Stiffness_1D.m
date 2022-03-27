function Stiffness_1D(len_d, n_e)
    nodes = linspace(0,len_d,n_e+1)';
    n_nodes = size(nodes,1);
    elem_connect = [];
    F_B_elem = [0 0];
    F_T_elem = [0 0];
    
    for i = 1:n_e
        elem_connect = [elem_connect; i, i+1];
    end
    i = 0;
    A = 0.01;
    E = 10E9;
    l_e = abs(nodes(elem_connect(:,2))-nodes(elem_connect(:,1)));
    

    k_elem = E*A./l_e*[1 ,-1, -1, 1];
    k_global = zeros(n_nodes,n_nodes);
    F_B = zeros(n_nodes,1);
    F_T = zeros(n_nodes,1);
    F_P = zeros(n_nodes,1);

    ele = 1;


        
    while ele <= n_e
        k_global(elem_connect(ele,1),elem_connect(ele,1)) = k_global(elem_connect(ele,1),elem_connect(ele,1)) + k_elem(ele,1);
        k_global(elem_connect(ele,2),elem_connect(ele,1)) = k_global(elem_connect(ele,2),elem_connect(ele,1)) + k_elem(ele,2);
        k_global(elem_connect(ele,1),elem_connect(ele,2)) = k_global(elem_connect(ele,1),elem_connect(ele,2)) + k_elem(ele,3);
        k_global(elem_connect(ele,2),elem_connect(ele,2)) = k_global(elem_connect(ele,2),elem_connect(ele,2)) + k_elem(ele,4);
        
        
        F_B(elem_connect(ele,1)) = F_B(elem_connect(ele,1)) + F_B_elem(:,1);
        F_B(elem_connect(ele,2)) = F_B(elem_connect(ele,2)) + F_B_elem(:,2);

        F_T(elem_connect(ele,1)) = F_T(elem_connect(ele,1)) + F_T_elem(:,1);
        F_T(elem_connect(ele,2)) = F_T(elem_connect(ele,2)) + F_T_elem(:,2);

        ele = ele+ 1;
    end
    
    
    F_P(11) = 100;
    u = zeros(n_nodes,1);
    u(1) = 0;
    F = F_B + F_T + F_P;
    rhs = F - k_global*u;
    Dir_Nodes = 1;
    free_nodes = setdiff(1:n_nodes, Dir_Nodes);
    u(free_nodes) = k_global(free_nodes,free_nodes)\rhs(free_nodes);
    
    u
