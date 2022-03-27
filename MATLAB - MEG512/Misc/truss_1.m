function truss_1()
    
    %nodes = linspace(0,len_d,n_e+1)';
    nodes = [0 0; 40 0; 40 30; 0 30];
    n_nodes = size(nodes,1);

    
    elem_connect = [1 2; 2 3; 1 3; 3 4];
    n_e = 4

    


    A = 1;
    E = 29.5E6;

    

   dof = 2;

   k_global = zeros(n_nodes*dof,n_nodes*dof);
    
   F_B = zeros(n_nodes*dof,1); %quad elemen
   F_T = zeros(n_nodes*dof,1); %quad elemen
   F_P = zeros(n_nodes*dof,1); %quad elemen
    
   %f_b = repmat(27000,n_nodes,1);
   %f_t = repmat(100,n_nodes,1);
   ele = 1;


        
    while ele <= n_e
        l_e = sqrt((nodes(elem_connect(ele,2),1)-nodes(elem_connect(ele,1),1))^2 + (nodes(elem_connect(ele,2),2)-nodes(elem_connect(ele,1),2))^2);
        l = (nodes(elem_connect(ele,2),1)-nodes(elem_connect(ele,1),1))/l_e;
        m = (nodes(elem_connect(ele,2),2)-nodes(elem_connect(ele,1),2))/l_e;
                
        k_elem = E*A/l_e*[l m 0 0; 0 0 l m]'*[1 ,-1; -1, 1]*[l m 0 0; 0 0 l m]; %quad elemen
       %first node x_disp
        k_global(elem_connect(ele,1)*2-1,elem_connect(ele,1)*2-1) = k_global(elem_connect(ele,1)*2-1,elem_connect(ele,1)*2-1) + k_elem(1,1);
        k_global(elem_connect(ele,1)*2-1,elem_connect(ele,1)*2) = k_global(elem_connect(ele,1)*2-1,elem_connect(ele,1)*2) + k_elem(1,2);
        k_global(elem_connect(ele,1)*2-1,elem_connect(ele,2)*2-1) = k_global(elem_connect(ele,1)*2-1,elem_connect(ele,2)*2-1) + k_elem(1,3);
        k_global(elem_connect(ele,1)*2-1,elem_connect(ele,2)*2) = k_global(elem_connect(ele,1)*2-1,elem_connect(ele,2)*2) + k_elem(1,4);
        
        %first node y_disp
        k_global(elem_connect(ele,1)*2,elem_connect(ele,1)*2-1) = k_global(elem_connect(ele,1)*2,elem_connect(ele,1)*2-1) + k_elem(2,1);
        k_global(elem_connect(ele,1)*2,elem_connect(ele,1)*2) = k_global(elem_connect(ele,1)*2,elem_connect(ele,1)*2) + k_elem(2,2);
        k_global(elem_connect(ele,1)*2,elem_connect(ele,2)*2-1) = k_global(elem_connect(ele,1)*2,elem_connect(ele,2)*2-1) + k_elem(2,3);
        k_global(elem_connect(ele,1)*2,elem_connect(ele,2)*2) = k_global(elem_connect(ele,1)*2,elem_connect(ele,2)*2) + k_elem(2,4);
        
        %second node x_disp
        k_global(elem_connect(ele,2)*2-1,elem_connect(ele,1)*2-1) = k_global(elem_connect(ele,2)*2-1,elem_connect(ele,1)*2-1) + k_elem(3,1);
        k_global(elem_connect(ele,2)*2-1,elem_connect(ele,1)*2) = k_global(elem_connect(ele,2)*2-1,elem_connect(ele,1)*2) + k_elem(3,2);
        k_global(elem_connect(ele,2)*2-1,elem_connect(ele,2)*2-1) = k_global(elem_connect(ele,2)*2-1,elem_connect(ele,2)*2-1) + k_elem(3,3);
        k_global(elem_connect(ele,2)*2-1,elem_connect(ele,2)*2) = k_global(elem_connect(ele,2)*2-1,elem_connect(ele,2)*2) + k_elem(3,4);
        
        %second node y_disp
        k_global(elem_connect(ele,2)*2,elem_connect(ele,1)*2-1) = k_global(elem_connect(ele,2)*2,elem_connect(ele,1)*2-1) + k_elem(4,1);
        k_global(elem_connect(ele,2)*2,elem_connect(ele,1)*2) = k_global(elem_connect(ele,2)*2,elem_connect(ele,1)*2) + k_elem(4,2);
        k_global(elem_connect(ele,2)*2,elem_connect(ele,2)*2-1) = k_global(elem_connect(ele,2)*2,elem_connect(ele,2)*2-1) + k_elem(4,3);
        k_global(elem_connect(ele,2)*2,elem_connect(ele,2)*2) = k_global(elem_connect(ele,2)*2,elem_connect(ele,2)*2) + k_elem(4,4);
        
      
        
        
        %F_B(elem_connect(ele,1)) = F_B(elem_connect(ele,1)) + (2/3*f_b(elem_connect(ele,1)) + 1/3*f_b(elem_connect(ele,2)))*A*l_e(ele)*0.5;
        %F_B(elem_connect(ele,2)) = F_B(elem_connect(ele,2)) + (1/3*f_b(elem_connect(ele,1)) + 2/3*f_b(elem_connect(ele,2)))*A*l_e(ele)*0.5;
        %F_T(elem_connect(ele,1)) = F_T(elem_connect(ele,1)) + (2/3*f_t(elem_connect(ele,1)) + 1/3*f_t(elem_connect(ele,2)))*l_e(ele)*0.5;
        %F_T(elem_connect(ele,2)) = F_T(elem_connect(ele,2)) + (1/3*f_t(elem_connect(ele,1)) + 2/3*f_t(elem_connect(ele,2)))*l_e(ele)*0.5;

        ele = ele+ 1;
    end
    
    F_P(3) = 20000;
    F_P(6) = -25000;
    
    u = zeros(n_nodes*dof,1);
    fixed_nodes = [1 4];
    fixed_nodes_x = [ ];
    fixed_nodes_y = [2];
    dirichlet_rows = [fixed_nodes*2-1, fixed_nodes*2, fixed_nodes_x*2-1, fixed_nodes_y*2];

    F = F_B + F_T + F_P;
    rhs = F - k_global*u;
    Dir_Nodes = dirichlet_rows;
    free_nodes = setdiff(1:n_nodes*dof, Dir_Nodes);
    u(free_nodes) = k_global(free_nodes,free_nodes)\rhs(free_nodes);
    
    u(free_nodes)
