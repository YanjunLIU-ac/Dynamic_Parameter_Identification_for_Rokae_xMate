%% print all dynamic parameters in MATLAB terminal

for ii = 1:7
    ind = 13 * (ii - 1);
    
    disp(['m for Joint', num2str(ii)]);
    disp(P_link(ind + 1));

    disp(['mc for Joint', num2str(ii)]);
    disp(P_link(ind + 2: ind + 4));

    disp(['Ic for Joint', num2str(ii)]);
    disp(P_link(ind + 5: ind + 10));

    disp(['Ia for Joint', num2str(ii)]);
    disp(P_link(ind + 11));
    
    disp(['fv for Joint', num2str(ii)]);
    disp(P_link(ind + 12));

    disp(['fc for Joint', num2str(ii)]);
    disp(P_link(ind + 13));
end