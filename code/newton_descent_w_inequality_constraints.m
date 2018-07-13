function [x,traj] = newton_descent_w_inequality_constraints(f,C,x0_feasible, finite_diff_eps, stopping_eps, alpha, beta)


%This is an implementation of the barrier method with the log barrier
%function.  Refer Convex optimization by Boyd, page 569.
% we minimize t*f(x) + phi, for increasing values of t.

t=0.1; 
mu=10; %factory by which mu is multiplied by each iteration.

traj=[]; %trajectory of feasible points. 

m=size(f,2)-1; %number of inequality constraints, used as stopping criterion
while(1)
    x=x0_feasible;
    traj=[traj,x0_feasible];
    %This is the beginning of a centering step.
    while(1)
        
        g=modified_gradient(f,x,t,finite_diff_eps);
        H=modified_hessian(f,x,t,finite_diff_eps);
        if rank(H)<size(H,1)
            H=H+eye(size(H,1))*1e-4; %making it positive definite
        end
        KKT_matrix=[H,C';C,zeros(size(C,1),size(H,1)+size(C,1)-size(C,2))]; %kkt matrix, assuming invertability.
        y=[-g;zeros(size(C,1),1)];
        if rank(KKT_matrix)<4
            disp(KKT_matrix)
        end
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
        
        x_new=x+step_size*descent;
        if(norm(x_new-x,inf)<stopping_eps)
            break
        end
        x=x_new;
     end
    
    if t>(m/stopping_eps)
        break
    else
        t=mu*t;%go to next centering step
        x0_feasible=x;
        
    end
end
end

function [hess]=modified_hessian(f,x,t,epsilon) %hessian of the function t*f(x) + -sum_i log(-g(x_i))

hess=t*hessian(f{1},x,epsilon); %hessian of t*objective
    for m=2:size(f,2) %now we add the hessians of inequalities
        hess=hess+(1/((f{m}(x)+1e-20)^2))*gradient(f{m},x,epsilon)*gradient(f{m},x,epsilon)' + (-1/(f{m}(x)+1e-20))*hessian(f{m},x,epsilon);
    end

 end

function [grad]=modified_gradient(f,x,t,epsilon) %gradient of the function t*f(x) + -sum_i log(-g(x_i))

    grad=t*gradient(f{1},x,epsilon); %gradient of t*objective
    
    for m=2:size(f,2)  %now we add the gradient of other part
        grad=grad+(-1/(f{m}(x)+1e-20))*(gradient(f{m},x,epsilon));
    end
end

function [val]=modified_f(f,x,t)

    val=t*f{1}(x); %value of t*objective
    for m=2:size(f,2) 
        val=val+ (-1)*log(-f{m}(x));

    end
end