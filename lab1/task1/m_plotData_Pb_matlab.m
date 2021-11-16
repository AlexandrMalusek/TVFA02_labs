% Plot tabulated and measured data

% Read tabulated data
tt = dlmread('data_lacTabulated_Pb.txt', ';', 1, 0);

% Read measured data
tm = dlmread('data_lacMeasured_Pb.txt', ';', 1, 0);

fig = figure(1);
% Plot tabulated data as a cubic spline and markers
xq = 150:5:800;
s = spline(tt(:,1), tt(:,2), xq);
p1 = plot(xq, s, 'b'); % spline
hold on;
p2 = plot(tt(:,1), tt(:,2), 'b.'); % markers

% Plot measured data as markers with error bars
p3 = errorbar(tm(:,1), tm(:,2), tm(:,3), 'r.');

hold off;
xlabel('E (keV)');
ylabel('\mu (cm^{-1})');

legend([p2, p3], {'tabulated','measured'},'Location','northeast');
xlim([100, 700]);
ylim([0, 17]);

fig.PaperSize = [5, 3];
print('fig_lac_Pb_matlab.pdf','-dpdf','-fillpage');
