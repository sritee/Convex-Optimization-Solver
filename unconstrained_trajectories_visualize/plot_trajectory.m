function visualize_2D_optimizer(f,traj)

    traj=load('t.mat');
    t=traj.traj;
    figure;
    hold on;
    for k=1:size(t,2)
        plot(t(1,k),t(2,k),'*');
        if k>1
            line([t(1,k-1),t(1,k)],[t(2,k-1),t(2,k)]) 
        end
    end
    hold off;
end

