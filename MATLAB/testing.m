nz_unencoded = nnz(vidComp2);

P = 0;
B = 0;
blksize = 16;
Rx = 8;
Ry = 8;
K = 64;
Q = 1;
class = class(vidComp2);

for i=1:33
    Q = 2.^((i-17)/4);
    tstart = tic;
    [ vid_encoded vid_mv vid_Cb vid_Cr] = encoder( vidComp2, P, B, blksize, Rx, Ry, K, Q );
    tencode(i) = toc(tstart);
    nz_encoded = nnz(vid_encoded)+nnz(vid_mv);
    comp_ratio(i) = nz_encoded/nz_unencoded;
    tstart = tic;
    vid_out = decoder( vid_encoded, vid_mv, vid_Cb, vid_Cr, P, B, Q, class );
    tdecode(i) = toc(tstart);
    vid_out_vec(:,:,:,:,i) = vid_out(:,:,:,:);
    comp_ratio2(i) = nz_encoded/nnz(vid_out);
    mse = mean(mean(mean(mean((double(vid_out) - double(vidComp2)).^2))));
    psnr(i)=10*log10(255^2/mse);
end

