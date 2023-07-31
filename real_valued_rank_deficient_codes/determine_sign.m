function sign_c = determine_sign(c)
% sign_c = determine_sign(c) returns the correct sign of the hyperpolar
% vector c
D = length(c);
phi = zeros(D-1,1);
for phi_ind = 1:D-1
    phi(phi_ind)= asin(c(phi_ind)/prod(cos(phi(1:phi_ind-1))));
end
if (phi(D-1)*c(D-1)) ==0
    sign_c = 1;
else
    sign_c = sign(tan(phi(D-1))*c(D-1)*c(D));
end