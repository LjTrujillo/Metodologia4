function crearInterfaz()
    % Importar los datos del archivo CSV a MATLAB
    heart_data = readtable('heart_data.csv');

    % Cambiar la representación de variables binarias a texto descriptivo
    heart_data.smoke = string(heart_data.smoke);
    heart_data.alco = string(heart_data.alco);
    heart_data.active = string(heart_data.active);
    heart_data.cardio = string(heart_data.cardio);
    heart_data.smoke = replace(heart_data.smoke, {'0', '1'}, {'No fuma', 'Fuma'});
    heart_data.alco = replace(heart_data.alco, {'0', '1'}, {'No consume alcohol', 'Consume alcohol'});
    heart_data.active = replace(heart_data.active, {'0', '1'}, {'Sin actividad física', 'Con actividad física'});
    heart_data.cardio = replace(heart_data.cardio, {'0', '1'}, {'Sin enfermedad cardiovascular', 'Con enfermedad cardiovascular'});

    % Convertir la variable categórica 'gender' a texto (string)
    heart_data.gender = string(heart_data.gender);

    % Cambiar la representación de la variable 'gender'
    heart_data.gender = replace(heart_data.gender, {'1', '2'}, {'Hombre', 'Mujer'});

    % Dividir la edad de los participantes de días a años
    heart_data.age = heart_data.age / 365;

    % Calcular el índice de masa corporal (IMC)
    peso_kg = heart_data.weight;
    altura_m = heart_data.height / 100; % Convertir altura de cm a metros
    IMC = peso_kg ./ (altura_m.^2);

    % Clasificar el IMC según los estándares de la OMS
    clasificacion_IMC = cell(size(IMC));
    for i = 1:numel(IMC)
        if IMC(i) < 18.5
            clasificacion_IMC{i} = 'Bajo peso';
        elseif IMC(i) >= 18.5 && IMC(i) < 25
            clasificacion_IMC{i} = 'Normal';
        elseif IMC(i) >= 25 && IMC(i) < 30
            clasificacion_IMC{i} = 'Sobrepeso';
        else
            clasificacion_IMC{i} = 'Obeso';
        end
    end

    % Agregar la clasificación del IMC a la tabla heart_data
    heart_data.IMC = IMC;
    heart_data.clasificacion_IMC = clasificacion_IMC;

    % Calcular la presión arterial media (PAM)
    PAS = heart_data.ap_hi;
    PAD = heart_data.ap_lo;
    PAM = (2/3) * PAD + (1/3) * PAS;

    % Agregar la PAM a la tabla heart_data
    heart_data.PAM = PAM;

    % Separar hombres y mujeres
    hombres = heart_data(heart_data.gender == 'Hombre', :);
    mujeres = heart_data(heart_data.gender == 'Mujer', :);

    % Definir rangos de edades
    rangos_edades = [20 30; 30 40; 40 50; 50 60; 60 70];

    % Calcular la cantidad de personas con enfermedades cardiovasculares por rango de edad
    hombres_con_cardio = zeros(size(rangos_edades, 1), 1);
    mujeres_con_cardio = zeros(size(rangos_edades, 1), 1);
    for i = 1:size(rangos_edades, 1)
        hombres_con_cardio(i) = sum(hombres.cardio == 'Con enfermedad cardiovascular' & hombres.age >= rangos_edades(i, 1) & hombres.age < rangos_edades(i, 2));
        mujeres_con_cardio(i) = sum(mujeres.cardio == 'Con enfermedad cardiovascular' & mujeres.age >= rangos_edades(i, 1) & mujeres.age < rangos_edades(i, 2));
    end
    disp(head(heart_data));
    % Crear la interfaz gráfica
    fig = uifigure('Name', 'Seleccionar opción');
    
    % Crear el cuarto botón para buscar participante por ID
    BuscarParticipante = uibutton(fig, 'push', 'Text', 'Buscar Participante', 'Position', [50 300 150 30], 'ButtonPushedFcn', @buscarParticipantePorID);

    % Crear el primer botón para el punto 5
    Punto5 = uibutton(fig, 'push', 'Text', 'Punto 5', 'Position', [250 300 100 30], 'ButtonPushedFcn', @graficarPunto5);
    
    % Crear el segundo botón para el punto 6
    Punto6 = uibutton(fig, 'push', 'Text', 'Punto 6', 'Position', [400 300 100 30], 'ButtonPushedFcn', @graficarPunto6);
    
    % Crear el tercer botón para el punto 7
    Punto7 = uibutton(fig, 'push', 'Text', 'Punto 7', 'Position', [550 300 80 30], 'ButtonPushedFcn', @graficarPunto7);

    % Crear un eje para la gráfica de barras
    ax = uiaxes(fig, 'Position', [50 50 500 200]);

    function graficarPunto5(~, ~)
        % Limpiar el eje antes de dibujar
        cla(ax);
        % Graficar
        bar(ax, rangos_edades(:, 1), [hombres_con_cardio, mujeres_con_cardio]);
        xlabel(ax, 'Rango de Edades');
        ylabel(ax, 'Cantidad de personas');
        title(ax, 'Personas con enfermedades cardiovasculares');
        legend(ax, 'Hombres', 'Mujeres');
    end

   function graficarPunto6(~, ~)
    % Aquí va el código para generar la gráfica del punto 6
    % Gráfica IMC vs Colesterol
    figure;
    gscatter(heart_data.IMC, heart_data.cholesterol, heart_data.cardio, 'rgb', 'o');
    xlabel('Índice de Masa Corporal (IMC)');
    ylabel('Colesterol');
    title('Índice de Masa Corporal vs Colesterol por enfermedad cardiovascular');
    legend('Sin enfermedad cardiovascular', 'Con enfermedad cardiovascular');
    
    % Gráfica Nivel de glucosa vs Presión arterial media
    figure;
    gscatter(heart_data.gluc, heart_data.PAM, heart_data.cardio, 'rgb', 'o');
    xlabel('Nivel de Glucosa');
    ylabel('Presión Arterial Media (PAM)');
    title('Nivel de Glucosa vs Presión Arterial Media por enfermedad cardiovascular');
    legend('Sin enfermedad cardiovascular', 'Con enfermedad cardiovascular');
end

function graficarPunto7(~, ~)
    % Crear lista desplegable para la variable
    variables = {'Índice de masa corporal', 'Presión arterial media', 'Colesterol'};
    variable_seleccionada = uidropdown(fig, 'Position', [200 250 250 30], 'Items', variables, 'ValueChangedFcn', @calcularYMostrarEstadisticas);
    
    function calcularYMostrarEstadisticas(~, ~)
        % Separar datos por enfermedad cardiovascular
        cardio_positivo = heart_data(heart_data.cardio == 'Con enfermedad cardiovascular', :);
        cardio_negativo = heart_data(heart_data.cardio == 'Sin enfermedad cardiovascular', :);

        % Calcular medias y desviaciones estándar
        switch variable_seleccionada.Value
            case 'Índice de masa corporal'
                variable = 'IMC';
            case 'Presión arterial media'
                variable = 'PAM';
            case 'Colesterol'
                variable = 'cholesterol';
        end

        media_positivo = mean(cardio_positivo.(variable));
        std_positivo = std(cardio_positivo.(variable));
        media_negativo = mean(cardio_negativo.(variable));
        std_negativo = std(cardio_negativo.(variable));

        % Mostrar resultados en un cuadro de texto
        resultado = sprintf(['**%s por enfermedad cardiovascular:**\n\n**Con enfermedad cardiovascular:**\nMedia: %.2f\nDesviación estándar: %.2f\n\n**Sin enfermedad cardiovascular:**\nMedia: %.2f\nDesviación estándar: %.2f'], variable, media_positivo, std_positivo, media_negativo, std_negativo);
        uicontrol(fig, 'Style', 'text', 'Position', [50 50 500 100], 'HorizontalAlignment', 'left', 'FontName', 'Arial', 'FontSize', 12, 'String', resultado);
    end
end

function buscarParticipantePorID(~, ~)
    % Pedir al usuario que ingrese el ID del participante
    prompt = {'Ingrese el ID del participante:'};
    dlgtitle = 'Buscar Participante por ID';
    dims = [1 50];
    definput = {''};
    answer = inputdlg(prompt, dlgtitle, dims, definput);

    % Obtener el ID ingresado por el usuario
    participant_id = str2double(answer{1});

    % Buscar al participante por su ID
    participant_data = heart_data(heart_data.id == participant_id, :);

    if isempty(participant_data)
        msgbox('No se encontró ningún participante con el ID ingresado.', 'Error', 'error');
    else
        % Obtener la información del participante encontrado
        enfermedad_cardiovascular = participant_data.cardio;
        fumador = participant_data.smoke;
        toma_alcohol = participant_data.alco;
        actividad_fisica = participant_data.active;
        categoria_IMC = participant_data.clasificacion_IMC;

        % Construir el mensaje de información
        info_msg = sprintf('Información del participante con ID %d:\n\n', participant_id);
        info_msg = strcat(info_msg, sprintf('Presencia de enfermedades cardiovasculares: %s\n', enfermedad_cardiovascular));
        info_msg = strcat(info_msg, sprintf('Fumador: %s\n', fumador));
        info_msg = strcat(info_msg, sprintf('Toma alcohol: %s\n', toma_alcohol));
        info_msg = strcat(info_msg, sprintf('Realiza actividad física: %s\n', actividad_fisica));
        % Convertir categoria_IMC a cadena de caracteres
        categoria_IMC_str = char(categoria_IMC);
        info_msg = strcat(info_msg, sprintf('Categoría de IMC: %s\n', categoria_IMC_str));

        % Mostrar el mensaje de información en un cuadro de texto
        msgbox(info_msg, 'Información del Participante');
    end
end
end