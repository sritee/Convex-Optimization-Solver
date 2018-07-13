
%In this, we write our own primal interior point method for solving convex
%optimization problems. Feasible start path following algorithm used, with
%backtracking line search to select step size.

%Boyd & Vandenberghe used as reference.

CVX_CHECK='ON'; %Set it to 'ON' to verify our solution with CVX's solution

finite_diff_eps = 1e-4;         %finite difference to calculate the numerical gradient
stopping_eps = 1e-4;            %stopping check (xnew -x) < epsilon, terminate. 
alpha =  0.3; % in (0, 0.5)  -- backtracking line search parameter
beta = 0.9; % in (0,1)       -- backtracking line search parameter



%let's state our problem
% min_x f(x) 
%  s.t. Cx = d
%       g_i(x) <= 0 for all i.

C = [ 0.189653747547175   0.682223223591384   0.541673853898088];
d = 1;


indexat = @(expr, index) expr(index); %helper function to encode inequality constraints. 

fi{1}=@(x)(exp(x(1))-x(2)-log(1+x(3))); %This is our OBJECTIVE function. 2 other samples are given below to try

%fi{1} = @(x)(exp(x(1)*3) + exp(x(2)*1) +exp(x(3))- 4); 
%fi{1}=@(x)(-2*log(x(1)+1)+3*x(2)^2+x(3)^2);

%Now, we have some sample inequality constraints to try! In this problem,
%we have constraints of the form x_low<=x<=x_high, box constraints. Feel
%free to modify for other types, like quadratic constraints.

x_low = -0.5*ones(3,1); %[-0.5; -0.5; -0.5];
x_high = 1*ones(3,1); %[1;1;1];

fi{2}=@(x)indexat((x-x_high),1);  %our inequality constraints are added after, as fi{2}, fi{3} etc
fi{3}=@(x)indexat((x-x_high),2);  %this evaluates x(2)-x_high i.e g_2(x)
fi{4}=@(x)indexat((x-x_high),3);
fi{5}=@(x)indexat((x_low-x),1);
fi{6}=@(x)indexat((x_low -x),2);  %this evaluates x_low(2) -x(2)
fi{7}=@(x)indexat((x_low -x),3);




x0_feasible = C\d; %only satisfies the equality constraint, not necessarily the inequality one.

% % we need to first find a feasible point to initialize our actual proble

%We implement phase 1!

%For this, we implemented Phase1
% min s
% subject to
% g_i(x)<=s for all i
% C*x=d

[x_feasible, feasibility] = firstphase_newton_descent_w_inequality_constraints(fi, C, x0_feasible, finite_diff_eps, stopping_eps, alpha, beta);% YOURS to implement

%The final element of x_feasible containts the value of s, we can discard
%it.
x_feasible=x_feasible(1:size(x_feasible)-1);

if feasibility==0
    error('Infeasible problem') %if problem is infeasible, error is called!
end


% % now let's solve our actual problem:
 
[x_sol,trajectory] = newton_descent_w_inequality_constraints(fi,C,x_feasible, finite_diff_eps, stopping_eps, alpha, beta);% YOURS to implement


if strcmp(CVX_CHECK,'ON')
   
    cvx_begin
    variable x(3);
    minimize (exp(x(1))-x(2)-log(1+x(3)));  %change this according to the function being verified
    subject to
    C*x==d;  %equality constraint
    x_low<=x<=x_high;
    cvx_end
 
fprintf('CVX found optimal value as %d and the solution is \n',fi{1}(x))
disp(x);
end

fprintf('Our solver found optimal value as %d and the solution is \n',fi{1}(x_sol))
disp(x_sol);





