% Plot energy resolution of a detector as a function of energy
% and corresponding fits.

% Read measured data
t = dlmread('data_energyResolution.txt', ';', 1, 1);

% Remove the line for 511 keV
tr = t; tr(2,:) = [];

% Calculate values predicted by the linear regression.
[predE_CZT, predR_CZT] = getPredicted(log(tr(:,1)), log(tr(:,2)));
[predE_NaI, predR_NaI] = getPredicted(log(tr(:,1)), log(tr(:,3)));
[predE_HPGe, predR_HPGe] = getPredicted(log(tr(:,1)), log(tr(:,4)));

fig = figure(1);
p1 = loglog(t(:,1), t(:,2), 'r.');    % measured CZT
hold on;
p2 = loglog(t(:,1), t(:,3), 'g.');    % measured NaI
p3 = loglog(t(:,1), t(:,4), 'b.');    % measured HPGe
loglog(predE_CZT, predR_CZT, 'r-');   % predicted CZT
loglog(predE_NaI, predR_NaI, 'g-');   % predicted NaI
loglog(predE_HPGe, predR_HPGe, 'b-'); % predicted HPGe
hold off;
xlabel('E (keV)');
ylabel('R (%)');

legend([p1, p2, p3], {'CZT','NaI', 'HPGe'},'Location','northeast');
xlim([50, 1500]);
ylim([0.05, 50]);

fig.PaperSize = [6, 4];
print('fig_res_matlab.pdf','-dpdf','-fillpage');


function [xp,yp] = getPredicted(x,y)
% GETPREDICTED Return values predicted by liner regression in log-log coordinates.

  X = [ones(length(x),1) x];
  b = X\y;
  disp(b);

  xq = log(50):0.5:log(2000); % From 50 keV to 2000 keV
  yq = b(1) + b(2)*xq;
  xp = exp(xq);
  yp = exp(yq);
end
