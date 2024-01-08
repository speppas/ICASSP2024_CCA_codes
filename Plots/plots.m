%% Experiments with SSINR = -45 dB - BPSK
clear; close all ; clc;
linewidth = 2;    % Set the linewidth of the plot lines
% Load SER for the BPSK case
load("BPSK_SER/CCA/SER.mat")
SER_CCA_BPSK = SER_per_SSNR;
load("BPSK_SER/rank_deficient/rank1/SER.mat")
SER_rank_def_rank1_BPSK = SER_per_SSNR;
load("BPSK_SER/rank_deficient/rank5/SER.mat")
SER_rank_def_rank5_BPSK = SER_per_SSNR;
load("BPSK_SER/exhaustive_search/SER.mat")
SER_exhaustive_search_BPSK = SER_per_SSNR;

SNR_list = 0:2:16; % SSNR values

figure(1)
semilogy(SNR_list,SER_CCA_BPSK,'-d',"LineWidth",linewidth, 'MarkerSize',10)
hold on;
semilogy(SNR_list,SER_rank_def_rank5_BPSK,'--o',"LineWidth",linewidth, 'MarkerSize',12)
hold on;
semilogy(SNR_list,SER_exhaustive_search_BPSK,'-.x',"LineWidth",linewidth, 'MarkerSize',10)
ylabel("SER")
xlabel("SSNR (dB)")
grid on;
grid minor;
title("Rayleigh Fading - BPSK (SSINR = -45 dB)")
xlim([0 16]);
xticks(0:2:16)
legend("CCA & rank def. (D = 1)",...
    "rank def. (D = 5)",...
    "Exhaustive Search");
set(gca,'FontSize',15)
%% Experiments with SSINR = 0 dB - BPSK
load("BPSK_SER/CCA/SER2.mat")
SER_CCA_BPSK2 = SER_per_SSNR;
load("BPSK_SER/rank_deficient/rank1/SER2.mat")
SER_rank_def_rank1_BPSK2 = SER_per_SSNR;
load("BPSK_SER/rank_deficient/rank5/SER2.mat")
SER_rank_def_rank5_BPSK2 = SER_per_SSNR;
load("BPSK_SER/exhaustive_search/SER2.mat")
SER_exhaustive_search_BPSK2 = SER_per_SSNR;

figure(2)
semilogy(SNR_list,SER_CCA_BPSK2,'-d',"LineWidth",linewidth, 'MarkerSize',10)
hold on;
semilogy(SNR_list,SER_rank_def_rank5_BPSK2,'--o',"LineWidth",linewidth, 'MarkerSize',12)
hold on;
semilogy(SNR_list,SER_exhaustive_search_BPSK2,'-.x',"LineWidth",linewidth, 'MarkerSize',10)
ylabel("SER")
xlabel("SSNR (dB)")
grid on;
grid minor;
title("Rayleigh Fading - BPSK (SSINR = 0 dB)")
xlim([0 16]);
xticks(0:2:16)
legend("CCA & rank def. (D = 1)",...
    "rank def. (D = 5)",...
    "Exhaustive Search");
set(gca,'FontSize',15)
%% Experiments with SSINR = -45 dB - 4QAM
% Load SER for the 4QAM case
load("4QAM_SER/CCA/SER.mat")
SER_CCA_4QAM = SER_per_SSNR;
load("4QAM_SER/rank_deficient/rank2/SER.mat")
SER_rank_def_rank2_4QAM = SER_per_SSNR;
load("4QAM_SER/rank_deficient/rank4/SER.mat")
SER_rank_def_rank4_4QAM = SER_per_SSNR;
load("4QAM_SER/rank_deficient/rank6/SER.mat")
SER_rank_def_rank6_4QAM = SER_per_SSNR;
load("4QAM_SER/exhaustive_search/SER.mat")
SER_exhaustive_search_4QAM = SER_per_SSNR;
figure(3)
semilogy(SNR_list,SER_CCA_4QAM,'-d',"LineWidth",linewidth, 'MarkerSize',6)
hold on;
semilogy(SNR_list,SER_rank_def_rank2_4QAM,'--o',"LineWidth",linewidth, 'MarkerSize',8)
hold on;
semilogy(SNR_list,SER_rank_def_rank4_4QAM,'--s',"LineWidth",linewidth, 'MarkerSize',11)
hold on;
semilogy(SNR_list,SER_rank_def_rank6_4QAM,'--+',"LineWidth",linewidth, 'MarkerSize',13)
hold on;
semilogy(SNR_list,SER_exhaustive_search_4QAM,'-.x',"LineWidth",linewidth, 'MarkerSize',9)
ylabel("SER")
xlabel("SSNR (dB)")
grid on;
grid minor;
ylim([10^-1.5 10^-0.2])
yticks([10^-1.5 10^-1 10^-0.6 10^-0.2])
yticklabels({'10^{-1.5}','10^{-1}','10^{-0.6}','10^{-0.2}'})
title("Rayleigh Fading - 4QAM")
xlim([0 16]);
xticks(0:2:16)
legend("CCA",...
    "rank def. (D = 2)", ...
    "rank def. (D = 4)", ...
    "rank def. (D = 6)",...
    "Exhaustive Search");
set(gca,'FontSize',15)