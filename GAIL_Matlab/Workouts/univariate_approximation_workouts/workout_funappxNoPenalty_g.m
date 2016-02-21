%comparison between funappxNoPenalty_g and funappxglobal_g
function [timeratio,timelgratio,npointsratio,npointslgratio]=workout_funappxNoPenalty_g(nrep,abstol,nlo,nhi)
% user can choose absolut error tolerance, initial number of points, number
% of iteration or can use the following parameters
% nrep = 100; abstol = 1e-7; nlo = 100; nhi = 1000;
c = rand(nrep,1)*4;
n = 3;
npoints = zeros(n,2,nrep);
time = zeros(n,2,nrep);
warning('off','GAIL:funappxNoPenalty_g:peaky')
warning('off','GAIL:funappxNoPenalty_g:exceedbudget')
warning('off','GAIL:funappxglobal_g:peaky')
warning('off','GAIL:funappxglobal_g:exceedbudget')
for i = 1:nrep;
    a = 0;
    b = c(i)+1;
    f1 = @(x) (x-c(i)).^2;
    f2 = @(x) c(i)*sin(c(i)*pi*x);
    f3 = @(x) 10*exp(-1000*(x-c(i)).^2);
%     f4 = @(x) 1/4*c(i)*exp(-2*x).*(c(i)-2*exp(x).*(-1 +...
%         c(i)*cos(x) - c(i)*sin(x))+exp(2*x).*(c(i) + 2*cos(x)...
%         - 2* sin(x) - c(i)*sin(2*x)));
    tic;
    [~, out_param] = funappxNoPenalty_g(f1,a,b,abstol,nlo,nhi);
    t=toc;
    time(1,1,i) = t;
    npoints(1,1,i) = out_param.npoints;
    tic;
    [~, out_param] = funappxglobal_g(f1,a,b,abstol,nlo,nhi);
    t=toc;
    time(1,2,i) = t;
    npoints(1,2,i) = out_param.npoints;
    tic;
    [~, out_param] = funappxNoPenalty_g(f2,a,b,abstol,nlo,nhi);
    t=toc;
    time(2,1,i) =  t;
    npoints(2,1,i) = out_param.npoints;
    tic;
    [~, out_param] = funappxglobal_g(f2,a,b,abstol,nlo,nhi);
    t=toc;
    time(2,2,i) =  t;
    npoints(2,2,i) = out_param.npoints;
    %if npoints(2,1,i)*1.0/npoints(2,2,i) > 3
    %    disp(['slow']), c(i), a, b
    %end
    tic;
    [~, out_param] = funappxNoPenalty_g(f3,a,b,abstol,nlo,nhi);
    t=toc;
    time(3,1,i) =   t;
    npoints(3,1,i) = out_param.npoints;
    tic;
    [~, out_param] = funappxglobal_g(f3,a,b,abstol,nlo,nhi);
    t=toc;
    time(3,2,i) =   t;
    npoints(3,2,i) = out_param.npoints;
    %if npoints(3,1,i)*1.0/npoints(3,2,i) < 0.05
    %    disp(['fast']), c(i), a, b
    %end
%     tic;
%     [~, out_param] = funappxNoPenalty_g(f4,a,b,abstol,nlo,nhi);
%     t=toc;
%     time(4,1,i) = t;
%     npoints(4,1,i) = out_param.npoints;
%     tic;
%     [~, out_param] = funappxglobal_g(f4,a,b,abstol,nlo,nhi);
%     t=toc;
%     time(4,2,i) =   t;
%     npoints(4,2,i) = out_param.npoints;
%     tic;
end;
warning('on','GAIL:funappxglobal_g:exceedbudget')
warning('on','GAIL:funappxNoPenalty_g:peaky')
warning('on','GAIL:funappxNoPenalty_g:exceedbudget')
warning('on','GAIL:funappxglobal_g:peaky')

cc = 2.5;
test1 = @(x) (x-cc).^2;
test2 = @(x) cc*sin(cc*pi*x);
test3 = @(x) 10*exp(-1000*(x-cc).^2);
% test4 = @(x) 1/4*cc*exp(-2*x).*(cc-2*exp(x).*(-1 +...
%     cc*cos(x) - cc*sin(x))+exp(2*x).*(cc + 2*cos(x)...
%     - 2* sin(x) - cc*sin(2*x)));
x = 0:0.05:3.5;
y1 = test1(x);
y2 = test2(x);
y3 = test3(x);
% y4 = test4(x);

timeratio = zeros(nrep,n);
npointsratio = zeros(nrep,n);
for i=1:nrep;
    for j=1:n;
        timeratio(i,j) = time(j,1,i)/time(j,2, i);
    end
end

for i=1:nrep;
    for j=1:n;
        npointsratio(i,j) = npoints(j,1,i)/npoints(j,2, i); 
    end
end

timeratio = sort(timeratio(:));
npointsratio = sort(npointsratio(:));


%% Output the table
% To just re-display the output, load the .mat file and run this section
% only
display(' ')
display('   Test      Number of Points       Time Used')
display(' Function   Local      Global     Local    Global')
npointslgratio = zeros(1,n);
timelgratio = zeros(1,n);

for i=1:n
    display(sprintf('%9.0f %9.0f  %9.0f %11.7f  %11.7f',...
        [i mean(npoints(i,1,:)) mean(npoints(i,2,:)) mean(time(i,1,:)) mean(time(i,2,:))])) 
    npointslgratio(i) = mean(npoints(i,1,:))/mean(npoints(i,2,:));
    timelgratio(i) = mean(time(i,1,:))/mean(time(i,2,:));
end
idx=find(timeratio<1);
max_idx_t = max(idx);
timeratio(1:max_idx_t) = 1./timeratio(1:max_idx_t);
idx=find(npointsratio<1);
max_idx_n = max(idx);
npointsratio(1:max_idx_n) = 1.0 ./npointsratio(1:max_idx_n);

%% Save Output

[~,~,MATLABVERSION] = GAILstart(false);
if usejava('jvm') || MATLABVERSION <= 7.12
    figure
    plot(x,y1,'g--+',x,y2,'b--x',x,y3,'m--o')
    legend('Quadratic','Oscillatory','Peaky')
    gail.save_eps('WorkoutfunappxNoPenaltyOutput', 'testfun');
    
    figure
    %     subplot(2,1,1);
    %     plot(1:nrep*n,timeratio,'blue',1:nrep*n,ones(nrep*n,1),'red');
    %     title('Comparison between funappxNoPenalty\_g and funappxNoPenaltyglobal\_g')
    %     ylabel('Time ratio of local/global')
    %     xlabel('Number of tests')
    %     subplot(2,1,2);
    %     plot(1:nrep*n,npointsratio,'blue',1:nrep*n,ones(nrep*n,1),'red');
    %     ylabel('Points ratio of local/global')
    %     xlabel('Number of tests')
    %
    %     gail.save_eps('WorkoutfunappxNoPenaltyOutput', 'WorkoutfunappxNoPenaltyTest');
    t =1:nrep*n;
    plot(t,timeratio,'r',t,npointsratio,'b:');
    legend('time ratio','points ratio');
    gail.save_eps('WorkoutfunappxNoPenaltyOutput', 'WorkoutfunappxNoPenaltyTest');
    %show two y-axis in one graph
%     ax = plotyy(t,timeratio,t,npointsratio,'plot','plot');
%     ylabel(ax(1),'Time ratio of local/global') % label left y-axis
%     ylabel(ax(2),'Points ratio of local/global') % label right y-axis
%     xlabel(ax(2),'Number of tests') % label x-axis
%     %     p1.LineStyle = '--';
%     %     p1.LineWidth = 2;
%     %     p2.LineWidth = 2;
%     grid(ax(1),'on')
%     gail.save_eps('WorkoutfunappxNoPenaltyOutput', 'WorkoutfunappxNoPenaltyTest');
    %show two x-axis and y-axis in one graph
%     line(t,timeratio,'Color','r','LineStyle','--o')
%     ax1 = gca;
%     set(ax1,'XColor','r','YColor','r')
%     ax2 = axes('Position',get(ax1,'Position'),...
%         'XAxisLocation','top',...
%         'YAxisLocation','right',...
%         'Color','none',...
%         'XColor','b','YColor','b');
%     line(t,npointsratio,'Color','b','LineStyle','--x','Parent',ax2);
%     gail.save_eps('WorkoutfunappxNoPenaltyOutput', 'WorkoutfunappxNoPenaltyTest');   
end;
gail.save_mat('WorkoutfunappxNoPenaltyOutput', 'WorkoutfunappxNoPenaltyTest', true, npoints,time,...
    c,timeratio,npointsratio,npointslgratio,timelgratio);

end

% Sample output for nrep = 100; abstol = 1e-7; nlo = 100; nhi = 1000;
%    Test      Number of Points       Time Used
%  Function   Local      Global     Local    Global
%         1      7794     193640   0.0034749    0.0324006
%         2     52077     426068   0.0185194    0.0459050
%         3     22908    2090105   0.0136522    0.2416690

% 
% timelgratio =
% 
%        0.1072    0.4034    0.0565
% 
% 
% npointslgratio =
% 
%        0.0402    0.1222    0.0110

