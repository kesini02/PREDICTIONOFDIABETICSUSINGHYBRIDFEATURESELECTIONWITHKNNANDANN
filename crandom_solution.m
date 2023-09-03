function so=crandom_solution(data)
    nx=data.nx;  
    sol=randperm(nx);    
%       save s sol
    load s
    so=sol;
end