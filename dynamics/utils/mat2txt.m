function back = mat2txt(fileName, mat)
%% mat2txt.m
% @brief: convert mat to txt by lines
% @param[in] fileName: .txt file to be write
% @param[in] mat: matrix to dump

fop = fopen(fileName, 'wt');
[M, N] = size(mat);
for i = 1:M
    for j = 1:N
        fprintf(fop, '%s', num2str(mat(i, j)));
    end
    if (i < M)
        fprintf(fop, '\n');
    end
end
back = fclose(fop);