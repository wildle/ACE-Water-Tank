%% 1. Setup Data
% Input Vectors (Sensor 2 Data only)
meas_voltage = [2.19 2.29 2.69 2.74];      
meas_height  = [0.8 3.6 8.6 8.8] / 100;    

% Linear Regression (Height = k * Voltage + d)
p = polyfit(meas_voltage, meas_height, 1);
k = p(1); 
d = p(2);
u0 = -d / k; % Zero crossing calculation

% Generate Fit Line Data for plotting
x_fit_range = linspace(min(meas_voltage)-0.2, max(meas_voltage)+0.2, 100);
y_fit_data  = polyval(p, x_fit_range);

% Labels and Filename (English, using "/" separator)
x_label_text = 'Sensor Voltage / V';
y_label_text = 'Height of Tank 2 / m';
pdf_filename = 'sensor2_calibration.pdf';

%% 2. Visualize
f = figure; 
hold on; grid on;

fit_legend = sprintf('Linear Fit');
plot(x_fit_range, y_fit_data, '-', 'Color', [0.8500 0.3250 0.0980], ...
    'LineWidth', 1.5, 'DisplayName', fit_legend);

% Plot 2: Measurement Points (Blue 'x')
plot(meas_voltage, meas_height, 'x', 'Color', [0 0.4470 0.7410], ...
    'LineWidth', 1.5, 'DisplayName', 'Measurement');

% Labels, Title and Legend
xlabel(x_label_text);
ylabel(y_label_text);
legend('show', 'Location', 'northwest');
ylim([-0.02 0.12]); 

%% 3. Export to PDF
if exist('exportgraphics', 'file')
    exportgraphics(f, pdf_filename, 'ContentType', 'vector');
else
    print(f, pdf_filename, '-dpdf', '-bestfit');
end
fprintf('Figure saved as: %s\n', pdf_filename);