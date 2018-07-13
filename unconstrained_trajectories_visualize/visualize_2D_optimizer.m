function[]=visualize_2D_optimizer(f,traj)
%For 2D function contour + trajectory visualization.
    x = linspace(-3,3,30); %change range if desired.
    y = linspace(-3,3,30);
    [X,Y] = meshgrid(x,y);
    val=zeros(size(X));
    for m=1:size(X,1)
        for n=1:size(X,2)
            val(m,n)=f([X(m,n);Y(m,n)]);
            
        end
    end
    contour(X,Y,val,60)
    hold on;
    
    
%we now have the function evaluated. Let us plot the contours.
    for k=1:size(traj,2)
        plot(traj(1,k),traj(2,k),'*');
        if k>1
            line([traj(1,k-1),traj(1,k)],[traj(2,k-1),traj(2,k)]) 
        end
    end
    hold off

