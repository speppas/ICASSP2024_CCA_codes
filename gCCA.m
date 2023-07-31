function [C,G_opt,Q_opt] = gCCA(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This functions implements the generalized canonical correlation       %
%   analysis using the MAX-VAR formulation.                               %
%   Inputs: varargin is a list of dictionaries that hold all the input    %
%   datasets. Note that if the number of datasets is K, it should hold    %
%   that K >= 2.                                                           %
%   Outputs:                                                              %
%            C -> Evaluation of the MAX-VAR cost function                 %                              
%            G_opt -> Common direction i.e. our information vector        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    K = length(varargin(1:end));
    if K < 2
        disp("Use 2 datasets or more");
        return;
    end
    Y = varargin(1:end);
    M = [];
    for i = 1:K
        [U,~,~] = svd(Y{i},"econ");
        M = [M,U(:,1:rank(Y{i}))];
    end
    [U2,~,~] = svd(M,"econ");
    G_opt = U2(:,1); % Keep the 1st principal component
    Q_opt = {};
    for i = 1:K
        Q_opt{i} = pinv(Y{i})*G_opt;
    end 
    % Evaluate the MAX-VAR cost function
    C = 0;
    for i = 1:K
        C = C + norm(Y{i}*Q_opt{i}-G_opt,2)^2;
    end
end