clear; close all; clc;
% Parameters
Ms = 2;                 % Number of antennas at SRx
N = 1024;               % Number of total samples
N_p = 1;                % Number of preamble symbols
D = 1;                  % Set the rank for the truncation
% Secondary user sends 4-QAM, Primary user sends 4-QAM
M_secondary = 4;                  
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
p1 = x_p(1:N/2);
p2 = x_p(N/2+1:end);
% Noiseless Received Underlay Signal
Y_s = x_s *  h_s +  x_p * h_ps ;
% Create the signal views
Y_1 = Y_s(1:N/2,:);
Y_2 = Y_s(N/2+1:end,:);
% Solve the CCA problem for the special case g^H*A*g
% In the noiseless case matrix A has rank 3 but matrix H
% has rank 6
[U1,~,~] = svd(Y_1,"econ");
[U2,~,~] = svd(Y_2,"econ");
r1 = rank(Y_1);
r2 = rank(Y_2);
A = U1(:,1:r1)*(U1(:,1:r1)') + U2(:,1:r2)*(U2(:,1:r2)');
H = [real(A), -imag(A); imag(A), real(A)];
disp("Rank of A:"+rank(A))
disp("Rank of H:"+rank(H))
% Verify that the closed form with the outer products including s, p1 and p2
% is correct (noiseless casse)
a1 = norm(s,2)^2*norm(p1,2)^2 - (s')*(p1)*(p1')*(s); 
a2 = norm(s,2)^2*norm(p2,2)^2 - (s')*(p2)*(p2')*(s); 
z1 = (norm(p1,2)^2/a1 + norm(p2,2)^2/a2)*s - (1/a1)*((p1')*s)*p1 - (1/a2)*((p2')*s)*p2;
z2 = (norm(s,2)^2/a1)*p1 - (1/a1)*(s'*p1)*s;
z3 = (norm(s,2)^2/a2)*p2 - (1/a2)*(s'*p2)*s;
A_closed_form = z1*(s')+ z2*(p1')+z3*(p2'); 
gap = norm(A - A_closed_form,'fro')