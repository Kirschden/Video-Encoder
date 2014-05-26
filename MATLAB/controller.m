function [ vid_out vid_mv vid_Cb vid_Cr] = controller( vid_in, P, B, blksize, Rx, Ry, K, Q )
%Function which controls the operation of the hybrid encoder

[x y z t] = size(vid_in);

vid_YCbCr = YCbCrtoRGBblock(vid_in);
[vid_Y vid_Cb vid_Cr] = ChrominanceSubsamplingBlock(vid_YCbCr);
% dct_Y = DCTblock(vid_Y);
% dct_quant_Y = quantizationblock(dct_Y);

vid_error = vid_Y*0;
vid_mv = zeros(x, y, 2, 2, t, 'uint8');
vid_out = zeroes(x, y, t, 'double');

for i=1:P+B*P+B+1:t-P-P*B-B-1
    vid_error(:,:,i) = vid_Y(:,:,i);
    vid_out(:,:,i) = quantizationblock(DCTblock(vid_error(:,:,i),K),Q);
    
    % Encoding the B frames preceeding I frames
    if i>1
        for k=1:B
            storage_frame = cast(invDCTblock(invQuantizationblock(vid_out(:,:,i-B-1),Q)),class(vid_in));
            storage_frame2 = cast(invDCTblock(invQuantizationblock(vid_out(:,:,i),Q)),class(vid_in));
            [vid_mv(:,:,:,1,i-B-1+k) vid_error(:,:,i-B-1+k)] = MotEstimblock(vid_Y(:,:,i-B-1+k),storage_frame,blksize,Rx,Ry);
            [vid_mv(:,:,:,2,i-B-1+k) vid_error2] = MotEstimblock(vid_Y(:,:,i-B-1+k),storage_frame2,blksize,Rx,Ry);
            vid_error(:,:,i-B-1+k) = (vid_error(:,:,i-B-1+k)+vid_error2)/2;
            vid_out(:,:,i-B-1+k) = quantizationblock(DCTblock(vid_error(:,:,i-B-1+k),K),Q);
        end
    end
    
    % Encoding P frames
    for j=B+1:B+1:P+P*B+B
        storage_frame = cast(invDCTblock(invQuantizationblock(vid_out(:,:,i+j-B-1),Q)),class(vid_in));
        [vid_mv(:,:,:,1,i+j) vid_error(:,:,i+j)] = MotEstimblock(vid_Y(:,:,i+j),storage_frame,blksize,Rx,Ry);
        vid_out(:,:,i+j) = quantizationblock(DCTblock(vid_error(:,:,i+j),K),Q);
        storage_frame2 = cast(invDCTblock(invQuantizationblock(vid_out(:,:,i+j),Q)),class(vid_in));
        
        % Encoding B frames preceeding P frames
        for k=1:B
            [vid_mv(:,:,:,1,i+j-B-1+k) vid_error(:,:,i+j-B-1+k)] = MotEstimblock(vid_Y(:,:,i+j-B-1+k),storage_frame,blksize,Rx,Ry);
            [vid_mv(:,:,:,2,i+j-B-1+k) vid_error2] = MotEstimblock(vid_Y(:,:,i+j-B-1+k),storage_frame2,blksize,Rx,Ry);
            vid_error(:,:,i+j-B-1+k) = (vid_error(:,:,i+j-B-1+k)+vid_error2)/2;
            vid_out(:,:,i+j-B-1+k) = quantizationblock(DCTblock(vid_error(:,:,i+j-B-1+k),K),Q);
        end
    end
end

end

