function disp = sad(src1,src2,window_size,disp_threshold,row)

if ~all(size(src1) == size(src2))
    error('size are not same');
end

[h,w] = size(src1);
w_half = (window_size-1)/2;

src1 = padarray(src1,[w_half w_half],'replicate','both');
src2 = padarray(src2,[w_half w_half],'replicate','both');

disp_mat = [];

for i=1:w % Center pixel of window1, which is from src1 (reference)
    
    temp = [];
    for j=1:w % Center pixel of window2, which is from src2 (object being probed)
        % In other words, disparity in pixel d =abs(j-i) when j = argmin(window difference)
        window1 = uint16(src1(row:row+2*w_half,i:i+2*w_half));
        window2 = uint16(src2(row:row+2*w_half,j:j+2*w_half));
    
        windows_diff = abs(window1-window2);
        sum_val = sum(windows_diff(:));
        temp = [temp sum_val];
    end
    
    disp_mat = [disp_mat; temp];
end

padded_disp_mat = padarray(disp_mat,[0 disp_threshold],max(disp_mat(:)),'both');

search_mat = [];
for i=1:w
    search_mat = [search_mat; padded_disp_mat(i,i:i+2*disp_threshold)];
end

[M, I] = min(abs(search_mat),[],2); % Width = 2*disp_threshold + 1

disp = abs(I-disp_threshold-1);

end