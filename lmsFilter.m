function [y_refined, weights] = lmsFilter(input_signal, desired_signal, mu, order, iterations)
    % LMS Adaptive Filter
    % input_signal: Señal de entrada (estimación inicial)
    % desired_signal: Señal deseada
    % mu: Tasa de aprendizaje
    % order: Orden del filtro
    % iterations: Número de iteraciones de ajuste
    
    % Inicializar variables
    num_samples = length(input_signal);
    weights = zeros(order, 1);
    y_refined = zeros(size(input_signal));
    error_signal = zeros(size(input_signal));
    
    % Iterar refinamiento
    for iter = 1:iterations
        for n = order:num_samples
            % Vector de entrada
            x_vec = input_signal(n:-1:n-order+1)';
            
            % Señal estimada
            y_refined(n) = weights' * x_vec;
            
            % Error de estimación
            error_signal(n) = desired_signal(n) - y_refined(n);
            
            % Actualizar pesos
            weights = weights + 2 * mu * error_signal(n) * x_vec;
        end
    end
end