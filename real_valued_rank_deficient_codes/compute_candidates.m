function X = compute_candidates(V)
% X=compute_candidates(V) returns a matrix whose columns are the
% corresponding binary vector candidates x for the maximization of
% x'*V*V'*X
[N D] = size(V);
if D > 2
    combinations = nchoosek(1:N,D-1);
    X = zeros(N,size(combinations,1));
    for i = 1:length(combinations)
        I = combinations(i,:);
        VI = V(I,:);
        c = find_intersection(VI);
        c = c*determine_sign(c);
        X(:,i) = sign(V*c);
        for d = 1:D-1
            c = find_intersection([VI([1:d-1 d+1:D-1],1:D-1)]);
            c = c*determine_sign(c);
            X(I(d),i) = sign(VI(d,1:end-1)*c);
        end
    end
    X = [X compute_candidates(V(:,1:D-2))];
elseif D == 1
    X = sign(V);
else
    phi_crosses = atan(-V(:,2)./V(:,1));
    [phi_sort,phi_ind] = sort(phi_crosses);
    X(phi_ind,1:N+1) = (repmat(-sign(V(phi_ind,1)),[1 N+1])).*(2*tril(ones(N,N+1))-1);
end