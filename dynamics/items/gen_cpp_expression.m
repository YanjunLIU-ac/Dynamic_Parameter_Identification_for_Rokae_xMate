%% gravity handler: G * g = gravTorque
% g_handle = fopen('..\model\dynamics_gravity_matrix_v2.txt', 'w');
% for ii = 1:7
%     fprintf(g_handle, '\tgravityMat(%d) = %s;\n', ii-1, char(G(ii)));
% end
% fclose(g_handle);

% %% friction handler: direct reading
% f_handle = fopen('..\model\dynamics_friction_matrix_v2.txt', 'w');
% for ii = 1:7
%     fprintf(f_handle, '\tfrictionMat(%d) = %s;\n', ii-1, char(F(ii)));
% end
% fclose(f_handle);
% 
% %% inertia handler: M * ddq = massTorque
m_handle = fopen('..\model\dynamics_inertia_matrix_v2.txt', 'w');
for ii = 1:7
    for jj = 1:7
        fprintf(m_handle, '\tinertiaMat(%d,%d) = %s;\n', ii-1, jj-1, char(M(ii, jj)));
    end
end
fclose(m_handle);
% 
% %% coriolis handler: C * dq = coriolisTorque
% c_handle = fopen('..\model\dynamics_coriolis_matrix_v2.txt', 'w');
% for ii = 1:7
%     for jj = 1:7
%         for kk = 1:7
%             fprintf(c_handle, '\tcoriolisMat%d(%d,%d) = %s;\n', ii, jj-1, kk-1, char(C(ii, jj, kk)));
%         end
%     end
% end
% fclose(c_handle);