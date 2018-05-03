function [ indices ] = mergesort_function( cols, N )
%MERGESORT_FUNCTION

addpath(genpath('../'));


indices = 1:N;
mergesort_helper_do_function(1, N);

    function [] = mergesort_helper_do_function(low, high)
        if low < high
            middle = floor((low + high) / 2);
            %middle = (int32((low + high) / 2));
            mergesort_helper_do_function(low, middle);
            mergesort_helper_do_function(middle + 1, high);
            mergesort_helper_merge_function(low, middle, high);
        end
    end

    function [] = mergesort_helper_merge_function(low, middle, high)
        temp = cols;
        temp_indices = indices;
        for i = low:high
            temp(i) = cols(i);
            temp_indices(i) = indices(i);
        end
        i = low;
        j = middle + 1;
        k = low;
        while (i <= middle) && (j <= high)
            if temp(i) <= temp(j)
                cols(k) = temp(i);
                indices(k) = temp_indices(i);
                i = i + 1;
            else
                cols(k) = temp(j);
                indices(k) = temp_indices(j);
                j = j + 1;
            end
            k = k + 1;
        end
        
        while i <= middle
            cols(k) = temp(i);
            indices(k) = temp_indices(i);
            k = k + 1;
            i = i + 1;
        end
    end

%for check_index = 1:35
%    if abs(cols(indices(check_index)) - cols(indices(check_index + 1))) <= 4
%        if rows(indices(check_index)) > rows(indices(check_index + 1))
%            temp_index = indices(check_index);
%            indices(check_index) = indices(check_index + 1);
%            indices(check_index + 1) = temp_index;
%        end
%    end
%end

%disp(indices);
%disp(temp);

%index = N - index_of_hole + 1;
%index_actual = indices(index);

indices = indices;

end

