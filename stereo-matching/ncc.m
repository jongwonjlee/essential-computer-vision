function disp = ncc(src1,src2,window_size,disp_threshold,row)

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
        window1 = double(src1(row:row+2*w_half,i:i+2*w_half));
        window2 = double(src2(row:row+2*w_half,j:j+2*w_half));
        
%         avg1 = sum(window1(:))/numel(window1);
%         avg2 = sum(window2(:))/numel(window2);
%         
%         stdv1 = std2(window1);
%         stdv2 = std2(window2);
%         
%         windows_ncc = ((window1-avg1) .* (window2-avg2))/(numel(window1)*stdv1*stdv2);

        window1 = window1(:);
        window2 = window2(:);
        
        Normalised_CrossCorr = (1/numel(window1))*sum((window1-mean(window1)).*(window2-mean(window2)))/(sqrt(var(window1)*var(window2)));

        temp = [temp Normalised_CrossCorr];
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