function [] = Magn2Movie_update(M_evolution_allspins,fps,timestep,spininterval,siminterval)

% M must be a 3D matrix with different time-points in 2nd dimension and
% different spin isochromats on 3th dimensions
%v spininterval/siminterval reduces the number of simulated spins and timepoints by these factors.

if nargin < 4
    spininterval = 1;
    siminterval = 1;
end

if nargin < 5
    siminterval = 1;
end

M_evolution_allspins = M_evolution_allspins(:,1:siminterval:end,1:spininterval:end);

%initializing movie
outfile = sprintf('%s','movie');
mov = VideoWriter('movie.avi') %,'compression','Cinepak');
mov.FrameRate = fps;
mov.Quality = 100;

open(mov)

%initializing figures
fig1 = figure;
h = fig1;
set(h,'Color',[1 1 1]);
set(h,'Position',[100, 100, 800, 300])
winsize = get(fig1,'Position');
winsize(1:2) = [0 0];
title('simulation');

markersize = 30;
for i = 1:size(M_evolution_allspins,2);
    M = squeeze(M_evolution_allspins(:,i,:));
    if i == 1
        subplot_tight(1,3,1,[0.1 0.1]); h1(1) = cline(M(1,:),M(2,:),M(3,:),M(3,:)); caxis([-1 1]); axis([-1 1 -1 1 -1 1]); xlabel('x'); ylabel('y'); zlabel('z'); view(142.5,30); axis vis3d; grid on; 
        subplot_tight(1,3,2,[0.1 0.1]); h1(2) = cline(M(1,:),M(2,:),M(3,:),M(3,:)); caxis([-1 1]); xlabel('x'); ylabel('y'); zlabel('z'); axis equal; axis([-1 1 -1 1 -1 1]); view(0,90); grid on; 
        subplot_tight(1,3,3,[0.1 0.1]); h1(3) = cline(M(1,:),M(2,:),M(3,:),M(3,:)); caxis([-1 1]); xlabel('x'); ylabel('y'); zlabel('z'); axis equal; axis([-1 1 -1 1 -1 1]); view(90,0); grid on;    
        set(h1(1),'Marker','.','MarkerSize',[markersize],'LineStyle','none');
        set(h1(2),'Marker','.','MarkerSize',[markersize],'LineStyle','none');
        if nargin > 2
        ha = gca;
        title(ha,sprintf('t = %f (s)',i*timestep));
        end
        set(h1(3),'Marker','.','MarkerSize',[markersize],'LineStyle','none');


        
    else
        set(h1(1),'Xdata',M(1,:)',...
                  'Ydata',M(2,:)',...
                  'Zdata',M(3,:)',...
                  'CData',M(3,:)');
              
        set(h1(2),'Xdata',M(1,:)',...
                  'Ydata',M(2,:)',...
                  'Zdata',M(3,:)',...
                  'CData',M(3,:)'); 
              
        set(h1(3),'Xdata',M(1,:)',...
                  'Ydata',M(2,:)',...
                  'Zdata',M(3,:)',...
                  'CData',M(3,:)');
              
        if nargin > 2
        title(ha,sprintf('t = %f (s)',i*timestep*siminterval));
        end
    end
    drawnow
    hold on
    h = figure(1);
    F = getframe(h);
    writeVideo(mov,F);
end

close(mov);
disp('FINISHED MOVIE');

end