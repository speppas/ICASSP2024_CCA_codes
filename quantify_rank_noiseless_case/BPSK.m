clear; close all; clc;
% Parameters
Ms = 2;                 % Number of antennas at SRx
N = 1024;                 % Number of total samples
N_p = 1;                % Number of preamble symbols
D = 1;                  % Set the rank for the truncation
% Secondary user sends BPSK, Primary user sends 4-QAM
M_secondary = 2;                  
M_primary = 4;

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

% Noiseless Received Underlay Signal
Y_s = x_s *  h_s +  x_p * h_ps ;
% Create the signal views
Y_1 = Y_s(1:N/2,:);
Y_2 = Y_s(N/2+1:end,:);
% In the noiseless case matrix A has rank 3 but matrix real(A)
% has rank 5
[U1,~,~] = svd(Y_1,"econ");
[U2,~,~] = svd(Y_2,"econ");
r1 = rank(Y_1);
r2 = rank(Y_2);
A = U1(:,1:r1)*(U1(:,1:r1)') + U2(:,1:r2)*(U2(:,1:r2)');
A_real = real(A);

disp("Rank of A:"+rank(A))
disp("Rank of Re{A}:"+rank(A_real))