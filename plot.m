%% Supertitle for the whole subplot
suptitle('I am a super title');

%% Plotting large amout of graphs using for loop
Xlabel ={'t (s)','force (N)'};
Ylabel = {'x (m)','Velocity (m/s)'};
ylabel('$\dot{\gamma}$', 'Interpreter','latex') % use latex and interpreter in labels
for i=1:2
    figure(i)
    xlabel(Xlabel{i}); % Note here,we usually use {] not () for cell arrays
    ylabel(Ylabel{i});
end

%% stairs plots
% produce a plot like a zero-order hold 
X = linspace(0,4*pi,40);
Y = sin(X);

figure
stairs(Y)


%% Plot log-log scale
x = 1:10;
y = 2:11;
plot(x,y,'r:o'); % plot the dotted line with highlighted circle points
bar(x,y); % plot the histogram 
% loglog, logplot in x,y,
loglog(x,y); % plot the log-log scale
semilogy(x,y); % plot the log scale only in y 
semilogx(x,y); % likewise, plot the log scale in x


%% Plotting phase portrait
% Solution a)
[x1,x2]= meshgrid(-0.5:0.05:0.5,-0.5:0.05:0.5); % create a 2D plane ponts, note, x1 is 21x21, x2 is also 21x21
xd1 = -x1-2*x2.*x1.^2+x2;
xd2 = -x1-x2;
quiver(x1,x2,xd1,xd2,'r'); % Velocity plot, which displays velocity vectors as arrows with components (xd1,xd2) at the points (x1,x2).
axis tight;

% Solution b)
f = @(t,x) [x(2);-x(1)+x(2)*(1-3*x(1)^2-3*x(2)^2)];
vectfield(f,-0.5:0.05:0.5,-0.5:0.05:0.5);
%
function vectfield(func,y1val,y2val,t)
if nargin==3 % numer of function input argument
  t=0;
end
n1=length(y1val);
n2=length(y2val);
yp1=zeros(n2,n1);
yp2=zeros(n2,n1);
for i=1:n1
  for j=1:n2
    ypv = feval(func,t,[y1val(i);y2val(j)]); % function evaluate
    yp1(j,i) = ypv(1);
    yp2(j,i) = ypv(2);
  end
end
quiver(y1val,y2val,yp1,yp2,'r');
axis tight;
end
%

%% Merge two plots as two subplots in a single figure
% make sure, the figures are at the same directory of your workspace
% when load the figures, dont close them, just leave them open
% Load saved figures
c=hgload('MyFirstFigure.fig');
k=hgload('MySecondFigure.fig');
% Prepare subplots
figure
h(1)=subplot(1,2,1);
h(2)=subplot(1,2,2);
% Paste figures on the subplots
copyobj(allchild(get(c,'CurrentAxes')),h(1));
copyobj(allchild(get(k,'CurrentAxes')),h(2));



%% Extract data from various plots 
% open files and extract all the data
files = {'a_21.fig','a_23.fig','a_24.fig','a_32.fig','a_34.fig','a_42.fig','a_43.fig'};
[~,n]=size(files);
for i = 1:n
    f = open(files{i}); %   h = gca; % get current figure handle
    dataObjs = get(h, 'Children'); %handles to low-level graphics objects in axes
    xdata{i} = get(dataObjs, 'XData');  %data from low-level grahics objects
    ydata{i} = get(dataObjs, 'YData');
    zdata{i} = get(dataObjs,'ZData');
    close(f);
end

% another way is to use the load command
d = load('a_21.fig','-mat');
f = gcf; 
close(f); % close current figure
x_data = d.hgS_070000.children(1).children(1).properties.Xdata;

%% Open MATLAB figure as data file
function [xData,yData] = extractDataFromPlot(figure)
% figure: 'freq_1.fig' -> name of the figure
% load figure as .mat file
data = load(figure,'-mat');
f = gcf; 
% close current figure
close(f); 
% extract the output data, note 1st data the last simulated data, last data
% is actually the measured data
xData = data.hgS_070000.children.children(1).properties.XData; % 1xn
yData = data.hgS_070000.children.children(1).properties.YData; % 1xn

xData = [xData; data.hgS_070000.children.children(2).properties.XData]; 
yData = [yData; data.hgS_070000.children.children(2).properties.YData];
end

%% Change Legend Size, Invoke Legend Latex command, Legend lines? suptitles
lgd = legend({'$\hat{\theta}$','$\theta$'},'Interpreter','latex');
lgd.FontSize = 16;

% Use latex in AxesTicks (note that the complicated latex is not working soem how)
set(groot,'DefaultAxesTickLabelInterpreter','Tex');

% alternatively, we can use 
f = figure;
a = axes;
set(a,'TickLabelInterpreter', 'Tex');
set(a,'XTickLabel', {'\pi'});

% Multiple lgened lines
plot(sin(1:10),'b')
hold on
plot(cos(1:10),'r')
legend({['blue' char(10) 'line'],'red line'})

% Only show partial of the legends
h(1) = plot([1:10],'Color','r','DisplayName','This one');hold on;
h(2) = plot([1:2:10],'Color','b','DisplayName','This two');
h(3) = plot([1:3:10],'Color','k','DisplayName','This three'); hold off;
legend(h(2:3)); % Only display last two legend titles, note we can apply this trick in subplots to
                % produce multiple legends

% plot titles and suptitles
figure_title = suptitle('States error original-S1 model');
figure_title.FontSize = 10;

%% Text arrows
% add two text arrows, specify position, fontsize, strings
figure
plot(t,Y_roll(1,:),'r-')
hold on
ta = annotation('textarrow');
ta.FontSize = 12;
ta.String = 'Identification';
ta.X = [0.3,0.4];
tb = annotation('textarrow');
tb.FontSize = 12;
tb.String = 'Validation';
tb.X = [0.8,0.7];
%
hold off


%% Error bar plot
% Plot lines with error bars
web('https://www.mathworks.com/help/matlab/ref/errorbar.html');
%
x = 1:10:100;
y = [20 30 45 40 60 65 80 75 95 90];
err = 8*ones(size(y));
errorbar(x,y,err); % default is vertical error bar, more options refer to the reference website
% errorbar(x,y,err,'horizontal'); % we can change to horizontal error bar.

%% Matlab plots with ticks (Used in event instants plot)
x = [1 1.5 2];
y = [1 1 1];
plot(x,y,'r*')
yticks([0 1 2])
yticklabels({'','Agent1','Agent2'})


%% Plot a divider in a figure
figure
plot(t_val,y_predicted(:,2),'r-');
hold on
plot(t_val,y_sim(:,2),'LineWidth',3,'Color',[0 0 0]+.6);
y = ylim; % current y-axis limits
plot([5 5],[y(1) y(2)],'k--')
hold off


%% Specify the position and size of a figure
% [left, bottom, width,height], left/bottom specify the position of the left bottom coner
% width/height specify the size of the figure (All in pixels)
set(gcf,'Position',[100 550 1000 400])


%% Save the figure to specific path with a predefined name
% define the pathname
pathname  = 'C:\Users\Zipeng\Desktop\Topology1\case 2\K_calculated_at_tau_0.608\tau_0.6'; 
% build the full file path for the figure, including the name
figfile = fullfile(pathname,figure_name{i}); 
% save the current figure to the path and name contained in figfile
saveas(gcf,figfile);

 
%% Change the current figure size
set(gcf, 'Position', [1346, 624, 560, 371])

 
%% Matlab plot help site
web('https://www.mathworks.com/help/matlab/ref/plot.html');
web('https://www.mathworks.com/help/matlab/creating_plots/types-of-matlab-plots.html') % all kinds of Matlab plot
web('https://www.mathworks.com/products/matlab/plot-gallery.html') % Matlab plot gallary


