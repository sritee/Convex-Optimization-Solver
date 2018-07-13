function [hess]=hessian(f,x,epsilon)
    indexat = @(expr, index) expr(index);
    dimension=size(x,1);
    hess=zeros(dimension,dimension);
    for row=1:dimension
        x_forward=x;
        x_backward=x;
        x_forward(row)=x_forward(row)+epsilon;
        x_backward(row)=x_backward(row)-epsilon;
        grad_forward=gradient(f,x_forward,epsilon);
        grad_backward=gradient(f,x_backward,epsilon);
        hess(row,:)=(grad_forward-grad_backward)/(2*epsilon);
    end
end