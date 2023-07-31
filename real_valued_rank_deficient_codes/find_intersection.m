function c = find_intersection(V)
% c=find_intersection(V) returns the zero right singular vector of V
[~,~,C] = svd(V);
c = C(:,end);
end