% Paso 2: Cargar la base de datos census
load census;

% Paso 3: Centrar y escalar los datos
cdate_centered = cdate - mean(cdate);
cdate_scaled = cdate_centered / std(cdate_centered);

% Paso 4: Ajuste polinomial de curvas
p1 = polyfit(cdate_scaled, pop, 1); % Ajuste polinomial de grado 1
p2 = polyfit(cdate_scaled, pop, 2); % Ajuste polinomial de grado 2
p3 = polyfit(cdate_scaled, pop, 3); % Ajuste polinomial de grado 3

% Paso 5: Graficar datos y ajustes polinomiales
scatter(cdate, pop); % Gráfica de dispersión de datos
hold on;
x = 1790:1990;
y1 = polyval(p1, (x - mean(cdate)) / std(cdate)); % Ajuste polinomial de grado 1
plot(x, y1, 'r', 'LineWidth', 2);
y2 = polyval(p2, (x - mean(cdate)) / std(cdate)); % Ajuste polinomial de grado 2
plot(x, y2, 'g', 'LineWidth', 2);
y3 = polyval(p3, (x - mean(cdate)) / std(cdate)); % Ajuste polinomial de grado 3
plot(x, y3, 'b', 'LineWidth', 2);
xlabel('Año');
ylabel('Población');
legend('Datos', 'Grado 1', 'Grado 2', 'Grado 3');
title('Ajuste Polinomial de Curvas a la Población de EE. UU.');

% Paso 6: Calcular el error cuadrático medio
mse1 = mean((polyval(p1, cdate_scaled) - pop).^2); % Error cuadrático medio para grado 1
mse2 = mean((polyval(p2, cdate_scaled) - pop).^2); % Error cuadrático medio para grado 2
mse3 = mean((polyval(p3, cdate_scaled) - pop).^2); % Error cuadrático medio para grado 3

disp(['Error cuadrático medio para grado 1: ', num2str(mse1)]);
disp(['Error cuadrático medio para grado 2: ', num2str(mse2)]);
disp(['Error cuadrático medio para grado 3: ', num2str(mse3)]);
