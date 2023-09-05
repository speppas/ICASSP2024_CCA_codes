clear; close all; clc;
rng(5)   % Fix the random generator for reproducibility
% Parameters
Ms = 2;                 % Number of antennas at SRx
N = 16;                 % Number of total samples
N_p = 1;                % Number of preamble symbols
M = 4;                  % Both users are sending 4-QAM (this is not imperative primary may send other signal)
% Desired SINR in dB
desired_SSINR_db = -45;
% Convert from dB to linear scale
desired_SSINR_linear = 10^(desired_SSINR_db / 10);
N0 = -90;                           % Noise power in dBm
N0_linear = 10^((N0 - 30) / 10);    % convert noise to linear scale
SSNR_list = 0:2:16;                 % SSNR values in dB
monte_carlo_runs = 10^4;            % Number of monte carlo experiments 
% Create the labels of the constellation for the detection
labels = qammod((0:M-1).',M,'UnitAveragePower',true);                   
SER_per_SSNR = [];
% Desired SSNR in dB
for desired_SSNR_db = SSNR_list
    desired_SSNR_db
    desired_SSNR_linear = 10^(desired_SSNR_db / 10);
    % Calculate secondary transmit power to achieve the desired SSNR
    alpha_s_linear = (N0_linear) * desired_SSNR_linear;
    % Calculate acceptable level of interference to achieve the desired SSINR
    alpha_p_linear = (alpha_s_linear) / desired_SSINR_linear - N0_linear;
    error_list = zeros(monte_carlo_runs,1);
    for kk = 1:monte_carlo_runs
        % Channel response
        h_s =  sqrt(1/2)*(randn(1,Ms) + 1j*randn(1,Ms)); % channel vector of underlay user
        h_ps = sqrt(1/2)*(randn(1,Ms) + 1j*randn(1,Ms)); % channel vector of primary user
        % Modulate data : Secondary signal
        data_secondary = randi([0 M-1],N/2,1);
        s = qammod(data_secondary,M,'UnitAveragePower',true);
        s(1) = (1+1j)/sqrt(2); % For scaling purposes
        preamble = s(1:N_p);   % Set the preamble symbols
        x_s = [s;s];           % Repeat the information for the underlay user twice
        % Signal of primary user
        data_primary = randi([0 M-1],N,1);
        x_p = qammod(data_primary,M,'UnitAveragePower',true);
        % Set the white Gaussian noise
        W =  sqrt(N0_linear/2) * (randn(N,Ms) + 1j*randn(N,Ms) );
        % Received Underlay Signal
        Y_s = sqrt(alpha_s_linear)* x_s *  h_s +  sqrt(alpha_p_linear) *x_p * h_ps + W ;
        % Create the signal views
        Y_1 = Y_s(1:N/2,:);
        Y_2 = Y_s(N/2+1:end,:);
        % Create the transformed matrix H that in the noiseless case has rank 6
        [U1,~,~] = svd(Y_1,"econ");
        [U2,~,~] = svd(Y_2,"econ");
        % Construct matrix A
        A = U1(:,1:rank(Y_1))*(U1(:,1:rank(Y_1))') + U2(:,1:rank(Y_2))*(U2(:,1:rank(Y_2))');
        % Do the transformation to obtain matrix H
        H = [real(A), -imag(A); imag(A), real(A)];
        % Generate all possible combinations for b
        b_values = dec2bin(0:(2^(N) - 1)) - '0';    % Convert to binary
        b_values = 2 * b_values - 1;                % Convert to -1 and +1 values
        % Initialize maximum value
        max_val = -Inf;
        b_opt = zeros(N, 1);
        % Perform exhaustive search
        for i = 1:size(b_values, 1)
            b = b_values(i, :).';
            % Correct the sign ambiguities
            b_temp1 = b(1:N/2);
            b_temp2 = b(N/2+1:end);
            b_temp1 = b_temp1/b_temp1(1);
            b_temp2 = b_temp2/b_temp2(1);
            b = [b_temp1; b_temp2];
            val = b.' * H * b;  % Calculate b^T * H * b
            if val > max_val
                max_val = val;
                b_opt = b;
            end
        end
        g_real = b_opt(1:N/2);
        g_imag = b_opt(N/2+1:end);
        g_complex_opt = (g_real+ 1j*g_imag)/sqrt(2);
        % Detect symbols (using the nearest neighbor)
        detected_symbols = nearest_neighbor(labels,g_complex_opt);
        % Dont account error for the preamble symbol
        error_list(kk) = mean(s(N_p+1:end)~=detected_symbols(N_p+1:end));
    end
    SER_per_SSNR(end+1) = mean(error_list);
end
%% Plots
close all;
figure()
semilogy(SSNR_list,SER_per_SSNR,'-*')
grid on;
grid minor;