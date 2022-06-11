def find_all_char(s, ch):
    ind = 1;
    last_ind = 0;
    ind_list = []

    while(s.find(ch) != -1):
        ind = s.find(ch)
        all_ind = ind + last_ind
        ind_list.append(all_ind)
        s = s[ind+1:]
        last_ind = all_ind + 1
    
    return ind_list

if __name__ == '__main__':
    '''
    # inertia handler
    m_handler = open('..\model\dynamics_inertia_matrix_v2.txt', 'r', encoding='utf-8')
    m_lines = m_handler.readlines()
    
    cnt = 0;
    new_m_lines = []
    for i, m_line in enumerate(m_lines):
        print('<INFO> Parsing No.', i, 'row ...')
        while(m_line.find('^') != -1):
            acme = m_line.find('^')
            s = m_line[acme-8:acme]
            star = s.find('*')
            item = m_line[acme-8+star+1:acme]
            cnt = cnt + 1
            
            prefix_sub = m_line[0:acme-8+star+1]
            suffix_sub = m_line[acme+2:]

            line = prefix_sub + 'pow(' + item + ',2)' + suffix_sub
            
        new_m_lines.append(m_line)
        print('<INFO> No.', i, 'row parsed!')
    print(cnt)
    '''
    
    # coriolis handler
    c_handler = open('..\model\dynamics_inertia_matrix_v2.txt', 'r', encoding='utf-8')
    c_lines = c_handler.readlines()
    
    subs_candidate = ['mc11^2', 'mc12^2', 'mc13^2',
                      'mc21^2', 'mc22^2', 'mc23^2',
                      'mc31^2', 'mc32^2', 'mc33^2',
                      'mc41^2', 'mc42^2', 'mc43^2',
                      'mc51^2', 'mc52^2', 'mc53^2',
                      'mc61^2', 'mc62^2', 'mc63^2',
                      'mc71^2', 'mc72^2', 'mc73^2',
                      's1^2', 'c1^2', 's2^2', 'c2^2',
                      's3^2', 'c3^2', 's4^2', 'c4^2',
                      's5^2', 'c5^2', 's6^2', 'c6^2',
                      's7^2', 'c7^2'];
    subs_dest = ['mc11*mc11', 'mc12*mc12', 'mc13*mc13',
                 'mc21*mc21', 'mc22*mc22', 'mc23*mc23',
                 'mc31*mc31', 'mc32*mc32', 'mc33*mc33',
                 'mc41*mc41', 'mc42*mc42', 'mc43*mc43',
                 'mc51*mc51', 'mc52*mc52', 'mc53*mc53',
                 'mc61*mc61', 'mc62*mc62', 'mc63*mc63',
                 'mc71*mc71', 'mc72*mc72', 'mc73*mc73',
                 's1*s1', 'c1*c1', 's2*s2', 'c2*c2',
                 's3*s3', 'c3*c3', 's4*s4', 'c4*c4',
                 's5*s5', 'c5*c5', 's6*s6', 'c6*c6',
                 's7*s7', 'c7*c7'];
    
    new_c_lines = []
    for c_line in c_lines:
        new_c = c_line
        for i in range(len(subs_candidate)):
            new_c = new_c.replace(subs_candidate[i], subs_dest[i])
        new_c_lines.append(new_c)
    c_handler.close()
    
    w_handler = open('..\model\dynamics_inertia_matrix_v3.txt', 'w')
    for new_c_line in new_c_lines:
        w_handler.write(new_c_line)
    w_handler.close()