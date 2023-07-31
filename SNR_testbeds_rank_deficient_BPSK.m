clear; close all; clc;
rng(5)   % Fix the random generator for reproducibility
% Parameters
Ms = 2;                 % Number of antennas at SRx
N = 32;                 % Number of total samples
N_p = 1;                % Number of preamble symbols
D = 5;                  % Set the rank for the truncation
% Secondary user sends BPSK, Primary user sends 4-QAM
M_secondary = 2;                  
M_primary = 4;
% Desired SINR in dB
desired_SSINR_db = -45;
% Convert from dB to linear scale
desired_SSINR_linear = 10^(desired_SSINR_db / 10);
N0 = -90;                           % Noise power in dBm
N0_linear = 10^((N0 - 30) / 10);    % convert noise to linear scale
SSNR_list = 0:2:16;                 % SSNR values in dB
monte_carlo_runs = 10^4;            % Number of monte carlo experiments                   
SER_per_SSNR = [];
% Desired SSNR in dB
for desired_SSNR_db = SSNR_list
    desired_SSNR_db
    desired_SSNR_linear = 10^(desired_SSNR_db / 10);
    % Calculate secondary transmit power to achieve the desired SNR
    alpha_s_linear = (N0_linear) * desired_SSNR_linear;
    % Calculate acceptable level of interference to achieve the desired SINR
    alpha_p_linear = (alpha_s_linear) / desired_SSINR_linear - N0_linear;
    error_list = zeros(monte_carlo_runs,1);
    for kk = 1:monte_carlo_runs
        % Channel response
        h_s =  sqrt(1/2)*(randn(1,Ms) + 1j*randn(1,Ms)); % channel vector of underlay user
        h_ps = sqrt(1/2)*(randn(1,Ms) + 1j*randn(1,Ms)); % channel vector of primary user
        % Modulate data : Secondary signal
        data_secondary = randi([0 M_secondary-1],N/2,1);
        s = qammod(data_secondary,M_secondary,'UnitAveragePower',true);
        s(1) = 1; % For scaling purposes
        preamble = s(1:N_p);   % Set the preamble symbols
        x_s = [s;s];           % Repeat the information for the underlay user twice
        % Signal of primary user
        data_primary = randi([0 M_primary-1],N,1);
        x_p = qammod(data_primary,M_primary,'UnitAveragePower',true);
        % Set the white Gaussian noise
        W =  sqrt(N0_linear/2) * (randn(N,Ms) + 1j*randn(N,Ms) );
        % Received Underlay Signal
        Y_s = sqrt(alpha_s_linear)* x_s *  h_s +  sqrt(alpha_p_linear) *x_p * h_ps + W ;
        % Create the signal views
        Y_1 = Y_s(1:N/2,:);
        Y_2 = Y_s(N/2+1:end,:);
        % Solve the CCA problem for the special case g^T*real(A)*g
        % In the noiseless case matrix A has rank 3 but matrix real(A)
        % has rank 5
        [U1,~,~] = svd(Y_1,"econ");
        [U2,~,~] = svd(Y_2,"econ");
        r1 = rank(Y_1);
        r2 = rank(Y_2);
        A = U1(:,1:r1)*(U1(:,1:r1)') + U2(:,1:r2)*(U2(:,1:r2)');
        A_real = real(A);
        [Q, Lambda] = eigs(A_real,D);
        % Calculate V
        V = Q * sqrt(Lambda);
        % Compute the candidate binary sequencies
        S = compute_candidates(V);
        temp_curr = -Inf;     
        for k = 1:size(S,2)
            g = S(:,k);
            temp_next = g.'*(V*V.')*g;
            if temp_next > temp_curr
                temp_curr = temp_next;
                g_opt = g;
            end
        end
        % Correct the sign ambiguity
        g_opt = g_opt/g_opt(1);
        % Detect symbols using the sign since underlay sends bpsk
        detected_symbols = sign(g_opt);
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