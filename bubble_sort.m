addpath(genpath('../'));


N = 5;
cols_sorted = [3 2 5 1 4];
for i = 1:N
    for j = i:N
        if cols_sorted(i) > cols_sorted(j)
            temp = cols_sorted(j);
            cols_sorted(j) = cols_sorted(i);
            cols_sorted(i) = temp;
        end
    end
end
disp(cols_sorted);