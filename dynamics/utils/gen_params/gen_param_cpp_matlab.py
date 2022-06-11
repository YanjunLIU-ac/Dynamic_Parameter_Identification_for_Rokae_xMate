"""
Convert dynamic parameters saved in MATLAB to 
macro-definitions in C++ using Python script
"""
from scipy.io import loadmat
import math

P = loadmat('P_link.mat')
P_mat = P['P_link']  # ndarray

param_name_list_cap = ['M', 'MC1', 'MC2', 'MC3', 'IC11', 'IC22', 'IC33', 'IC12', 'IC13', 'IC23', 'IA', 'FV', 'FC']
param_name_list_inicap = ['m', 'mc1', 'mc2', 'mc3', 'Ic11', 'Ic22', 'Ic33', 'Ic12', 'Ic13', 'Ic23', 'Ia', 'fv', 'fc']

# for c++ macro-definitions (used for robot_dynamics_iteration)
prefix = "#define "
write_handle = open('cpp_params_macrodef.txt', 'w')
for i in range(0, 91):
    joint = i // 13;
    param = i % 13;
    """
    if param != 0:
        this_name = param_name_list_cap[param]
        if 1 <= param <= 3:
            full_name = prefix + this_name[0:2] + str(joint+1) + this_name[-1]
        elif 4 <= param <= 9:
            full_name = prefix + this_name[0:2] + str(joint+1) + this_name[-2:]
        else:
            full_name = prefix + this_name + str(joint+1)
            
        full_name = full_name + " " + str(P_mat[i].item()) + '\n'
    else:
        full_name = '\n'
    """
    
    this_name = param_name_list_cap[param]
    if 1 <= param <= 3:
        full_name = prefix + this_name[0:2] + str(joint+1) + this_name[-1]
    elif 4 <= param <= 9:
        full_name = prefix + this_name[0:2] + str(joint+1) + this_name[-2:]
    else:
        full_name = prefix + this_name + str(joint+1)
    
    if (i+1) % 13 == 0:
        full_name = full_name + " " + str(P_mat[i].item()) + '\n' + '// Joint ' + str((i // 13) + 2) + '\n'
    else:
        full_name = full_name + " " + str(P_mat[i].item()) + '\n'
    
    print(full_name)
    write_handle.write(full_name)
    
write_handle.close()
# 
# # for c++ variable (used for robot_dynamics_equation)
# prefix = "double ";
# write_handle = open('cpp_params_variable.txt', 'a')
# for i in range(0, 91):
#     joint = i // 13;
#     param = i % 13;
#     if param != 0:
#         this_name = param_name_list_inicap[param]
#         if 1 <= param <= 3:
#             full_name = prefix + this_name[0:2] + str(joint+1) + this_name[-1]
#         elif 4 <= param <= 9:
#             full_name = prefix + this_name[0:2] + str(joint+1) + this_name[-2:]
#         else:
#             full_name = prefix + this_name + str(joint+1)
#             
#         full_name = full_name + " = " + str(P_mat[i].item()) + ';\n'
#     else:
#         full_name = '\n'
#     
#     print(full_name)
#     write_handle.write(full_name)
#     
# write_handle.close()
# 
# # for MATLAB variable
# write_handle = open('MATLAB_params_variable.txt', 'a');
# for i in range(0, 91):
#     joint = i // 13;
#     param = i % 13;
#     this_name = param_name_list_inicap[param]
#     if 1 <= param <= 3:
#         full_name = this_name[0:2] + str(joint+1) + this_name[-1]
#     elif 4 <= param <= 9:
#         full_name = this_name[0:2] + str(joint+1) + this_name[-2:]
#     else:
#         full_name = this_name + str(joint+1)
# 
#     full_name = full_name + " = " + str(P_mat[i].item()) + ';\n'
#     print(full_name)
#     write_handle.write(full_name)
# 
# """
# q = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7]
# sine_ = ['s1', 's2', 's3', 's4', 's5', 's6', 's7']
# cos_ = ['c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7']
# for i in range(7):
#     full_line_sine = sine_[i] + ' = ' + str(math.sin(q[i])) + ';\n'
#     full_line_cos = cos_[i] + ' = ' + str(math.cos(q[i])) + ';\n'
#     write_handle.write(full_line_sine)
#     write_handle.write(full_line_cos)
#     print(full_line_sine)
#     print(full_line_cos)
# """
# 
# write_handle.close()
