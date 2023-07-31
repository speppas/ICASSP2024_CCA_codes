clear; close all; clc;

% Parameters
Ms = 2;                 % Number of antennas at SRx
N = 1024;               % Number of total samples
N_p = 1;                % Number of preamble symbols
% Secondary user sends BPSK, Primary user sends 4-QAM
M_secondary = 2;                  
M_primary = 4;
% Desired SINR in dB
desired_SSINR_db = -45;
% Convert from dB to linear scale
desired_SSINR_linear = 10^(desired_SSINR_db / 10);
N0 = -90;                           % Noise power in dBm
N0_linear = 10^((N0 - 30) / 10);    % convert noise to linear scale
                  

% Desired SSNR in dB
desired_SSNR_db = 4;

desired_SSNR_linear = 10^(desired_SSNR_db / 10);
% Calculate secondary transmit power to achieve the desired SNR
alpha_s_linear = (N0_linear) * desired_SSNR_linear;
% Calculate acceptable level of interference to achieve the desired SINR
alpha_p_linear = (alpha_s_linear) / desired_SSINR_linear - N0_linear;

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
underlay_signal = sqrt(alpha_s_linear)* x_s ;
primary_signal =  sqrt(alpha_p_linear) *x_p ;
underlay_power = mean(abs(underlay_signal).^2);
primary_power = mean(abs(primary_signal).^2);
noise_power = mean(abs(W(:,1)).^2);

SSNR_est = 10*log10(underlay_power/noise_power)
SSINR_est = 10*log10(underlay_power/(primary_power + noise_power))


