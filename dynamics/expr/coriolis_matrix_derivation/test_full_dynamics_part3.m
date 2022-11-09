%% test_full_dynamics_part3.m

C1 = zeros(7, 7);
C2 = zeros(7, 7);
C3 = zeros(7, 7);
C4 = zeros(7, 7);
C5 = zeros(7, 7);
C6 = zeros(7, 7);
C7 = zeros(7, 7);

for i = 1:7
    for j = 1:7
        C1(i, j) = CC(1, i, j);
        C2(i, j) = CC(2, i, j);
        C3(i, j) = CC(3, i, j);
        C4(i, j) = CC(4, i, j);
        C5(i, j) = CC(5, i, j);
        C6(i, j) = CC(6, i, j);
        C7(i, j) = CC(7, i, j);
    end
end

dQ = [dQ1, dQ2, dQ3, dQ4, dQ5, dQ6, dQ7];
ddQ = [ddQ1, ddQ2, ddQ3, ddQ4, ddQ5, ddQ6, ddQ7];

TT_ = MM * ddQ' + ...
      GG + FF + ...
      [dQ * C1 * dQ';
       dQ * C2 * dQ';
       dQ * C3 * dQ';
       dQ * C4 * dQ';
       dQ * C5 * dQ';
       dQ * C6 * dQ';
       dQ * C7 * dQ';];

disp(['Error: ', num2str(sum(abs(TT- TT_)))]);
% if set CC(kk, ii, jj)'s coeffs as 1, error(abs) = 1.5972
% TT: 69.6440, -32.3882, -0.0531, 3.1509, -0.8421, 4.9219, 0.3184
% TT_: 69.7051, -33.6041, -0.0067, 3.2524, -0.8513, 5.0851, 0.3184

% if set CC(kk, ii, jj)'s coeffs as 0.5, error(abs) = 1.7492
% TT: 69.6440, -32.3882, -0.0531, 3.1509, -0.8421, 4.9219, 0.3184
% TT_: 69.6501, -33.7092, 0.0111, 3.1977, -0.7595, 5.0926, 0.2605

% if use newton-euler method, error(abs) = 0.0553
% TT: 69.6440, -32.3882, -0.0531, 3.1509, -0.8421, 4.9219, 0.3184
% TT_: 69.6421, -32.3685, -0.0516, 3.1665, -0.8329, 4.9293, 0.3184


