function [x,feasibility] = phase1_newton_descent_w_inequality_constraints(f,C,x0_feasible, finite_diff_eps, stopping_eps, alpha, beta)

% min s
% s.t. Cx = d
%  and g(x) <=s
% newton descent with backtracking line search for Phase 1
t=0.01;
mu=10;
traj=[];
m=size(f,2)-1; %number of inequality constraints

%let us change the original inequalities, g(x)<=0 to g(x)-x(end)<=0, where x(end)
%is the slack variable s

%now let us select the slack variable as max of the (g_is), to make sure
%all inequalities becomes strictly feasible at the initial point. 

temp=-1e8; %initial value, temporary.

for i=2:size(f,2) %loop through all the inequality constraints, so we can set s slighter higher than max of g_is.
    temp=max(temp,f{i}(x0_feasible));
end

x0_feasible=[x0_feasible;temp+1e-1]; %appending the slack variable as an extra variable.
C=[C,0]; %extra dimension for slack variable

f_c=f; %duplicate copy.
f_c{1}=@(x)(x(end)); %evaluating the objective function, which is just the slack variable 's' for Phase 1.

for i=2:size(f,2)
    f_c{i}=@(x)(f{i}(x(1:(size(x,1)-1)))-x(end)); 
end

%now, let us assign f to the changed f_c
f=f_c;
x=x0_feasible;
feasibility=1; %assuming problem is feasible. If not this variable will be set to 0 and returned. 

while(x(end)>=0) %as soon as s becomes negative, we can quit, as we have found strictly feasible point
    x=x0_feasible;
    traj=[traj,x];
    while(1) 
        
        g=modified_gradient(f,x,t,finite_diff_eps);
        H=modified_hessian(f,x,t,finite_diff_eps);
        KKT_matrix=[H,C';C,zeros(size(C,1),size(H,1)+size(C,1)-size(C,2))]; %kkt matrix, assuming invertability.
        y=[-g;zeros(size(C,1),1)];
        sol=KKT_matrix\y;
        descent=sol(1:size(C,2));
        step_size=1;
        while (1)
            fail=0; %check goldstein condition, as well as whether within domain of log function
            for m=2:size(f,2)
                if (f{m}(x+step_size*descent)>=0)
                    fail=1;
                end
            end
            if (modified_f(f,x+step_size*descent,t))>(modified_f(f,x,t)+alpha*step_size*descent'*modified_gradient(f,x,t,finite_diff_eps))
                fail=1;   
            end
            if fail==1
               step_size=step_size*beta;
            else
                break
            end      
        end

        %step_size
        x_new=x+step_size*descent;
        
        if(abs(x_new-x)<stopping_eps)
            break
        end
        x=x_new;
     end
    
    if t>(m/stopping_eps)
        feasibility=0;
        break
    else
        t=mu*t;%go to next centering step
        x0_feasible=x;
        x(end);
    end
end
end

function [hess]=modified_hessian(f,x,t,epsilon) %hessian of the function t*f(x) +  -sum_i log(-g(x_i))

hess=t*hessian(f{1},x,epsilon); %hessian of objective, which is slack

    for m=2:size(f,2) % now we add the hessians of inequalities
        hess=hess+(1/((f{m}(x))^2))*gradient(f{m},x,epsilon)*gradient(f{m},x,epsilon)' + (-1/(f{m}(x)))*hessian(f{m},x,epsilon);
    end

 end

function [grad]=modified_gradient(f,x,t,epsilon) %gradient of the function t*f(x) + -sum_i log(-g(x_i))

    grad=t*gradient(f{1},x,epsilon);  %gradient of objective, which is the slack
    
    for m=2:size(f,2)  %now we add the grad of other part
        grad=grad+(-1/(f{m}(x)))*(gradient(f{m},x,epsilon));
    end
end

function [val]=modified_f(f,x,t) %value of the function t*slack + -sum_i log(-g(x_i))


    val=t*f{1}(x);
    for m=2:size(f,2) %loop through inequalities
        val=val+ (-1)*log(-f{m}(x));
        %val
    end
end