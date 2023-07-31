clear; close all ; clc;


% Multi user (underlay) Plots (real part rank deficient) short packets
% Ms = 2 test different values of SINR for CCA
linewidth = 2;

load("BPSK_SER/CCA/SER.mat")
SER_CCA_BPSK = SER_per_SSNR;

load("BPSK_SER/CCA/SER2.mat")
SER_CCA_BPSK2 = SER_per_SSNR;

load("BPSK_SER/rank_deficient/rank1/SER.mat")
SER_rank_def_rank1_BPSK = SER_per_SSNR;

load("BPSK_SER/rank_deficient/rank5/SER.mat")
SER_rank_def_rank5_BPSK = SER_per_SSNR;

load("BPSK_SER/exhaustive_search/SER.mat")
SER_exhaustive_search_BPSK = SER_per_SSNR;



SNR_list = 0:2:16;
figure()
semilogy(SNR_list,SER_CCA_BPSK,'-d',"LineWidth",linewidth)
hold on;
semilogy(SNR_list,SER_rank_def_rank1_BPSK,'--s',"LineWidth",linewidth)
hold on;
semilogy(SNR_list,SER_rank_def_rank5_BPSK,'--o',"LineWidth",linewidth)
hold on;
semilogy(SNR_list,SER_exhaustive_search_BPSK,'-.hex',"LineWidth",linewidth)
ylabel("SER")
xlabel("SSNR (dB)")
grid on;
grid minor;
title("Multiuser (underlay) - real channel BPSK ($N/2$ $=$ 5) ",...
    "$M_s = 2$, SINR $=$ -45 dB, $\alpha_{s_2}/ \alpha_{s_1} = 1$","Interpreter","latex")
xticks(-4:2:20)

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

figure()
semilogy(SNR_list,SER_CCA_4QAM,'-d',"LineWidth",linewidth)
hold on;
semilogy(SNR_list,SER_rank_def_rank2_4QAM,'--o',"LineWidth",linewidth)
hold on;
semilogy(SNR_list,SER_rank_def_rank4_4QAM,'--s',"LineWidth",linewidth)
hold on;
semilogy(SNR_list,SER_rank_def_rank6_4QAM,'--+',"LineWidth",linewidth)
hold on;
semilogy(SNR_list,SER_exhaustive_search_4QAM,'-.hex',"LineWidth",linewidth)
ylabel("SER")
xlabel("SSNR (dB)")
grid on;
grid minor;
ylim([10^-1.5 10^-0.2])
yticks([10^-1.5 10^-1 10^-0.6 10^-0.2])

yticklabels({'10^{-1.5}','10^{-1}','10^{-0.6}','10^{-0.2}'})