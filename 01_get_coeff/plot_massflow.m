%% 1. Setup Data
input_v = [1 5];                    % Input values (e.g., Voltage)
mass_flow_raw = [750 4750];         % Raw flow values
conversion_factor = (0.001 / 60);   % Conversion (L/min to m^3/s)
mass_flow = mass_flow_raw * conversion_factor;
% Perform Linear Fit (y = mx + c)
p = polyfit(input_v, mass_flow, 1); 
% Generate Prediction Data for the Line
x_range = -1:0.1:6; 
y_values = polyval(p, x_range);
% Labels and Filename
x_label_text = 'Input Voltage / V';
y_label_text = 'Mass Flow / (m^3/s)';
legend_text  = 'Linear Fit';
pdf_filename = 'pump_curve.pdf';
%% 2. Visualize
f = figure; 
hold on; grid on;
% Plot the Fit Line with orange color
plot(x_range, y_values, 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5, 'DisplayName', legend_text);
% Optional: Plot original data points with blue 'x' markers
plot(input_v, mass_flow, 'x', 'Color', [0 0.4470 0.7410], 'LineWidth', 1.5, 'DisplayName', 'Measurement');
% Labels and Legend
xlabel(x_label_text);
ylabel(y_label_text);
legend('show', 'Location', 'northwest');
%% 3. Export to PDF
if exist('exportgraphics', 'file')
    exportgraphics(f, pdf_filename, 'ContentType', 'vector');
else
    print(f, pdf_filename, '-dpdf', '-bestfit');
end
fprintf('Figure saved as: %s\n', pdf_filename);