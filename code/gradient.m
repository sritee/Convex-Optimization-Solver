function [grad]=gradient(f,x,epsilon)
    indexat = @(expr, index) expr(index);
    dimension=size(x,1);
    grad=zeros(dimension,1);
    for k=1:dimension
        x_forward=x;
        x_backward=x;
        x_forward(k)=x_forward(k)+epsilon;
        x_backward(k)=x_backward(k)-epsilon;
        grad(k)=(f(x_forward)-f(x_backward))/(2*epsilon);
    end