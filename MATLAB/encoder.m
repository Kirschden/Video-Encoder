function [ vid_out vid_mv vid_Cb vid_Cr] = encoder( vid_in, P, B, blksize, Rx, Ry, K, Q )
%Controlling function of the hybrid encoder

[x y z t] = size(vid_in);

vid_YCbCr = RGBtoYCbCrblock(vid_in);
[vid_Y vid_Cb vid_Cr] = ChrominanceSubsamplingBlock(vid_YCbCr);

vid_error = zeros(x, y, t, 'double');
vid_mv = zeros(x/blksize, y/blksize, 2, 2, t, 'uint8');
vid_out = zeros(x, y, t, 'double');

for i=1:P+B*P+B+1:t
    vid_error(:,:,i) = cast(vid_Y(:,:,i),'double');
    vid_out(:,:,i) = quantizationblock(DCTblock(vid_error(:,:,i),K),Q);
    
    % Encoding the B frames preceeding I frames
    if i>1
        for k=1:B
            storage_frame = cast(invDCTblock(invQuantizationblock(vid_out(:,:,i-B-1),Q)),class(vid_in));
            storage_frame2 = cast(invDCTblock(invQuantizationblock(vid_out(:,:,i),Q)),class(vid_in));
            [vid_mv(:,:,:,1,i-B-1+k) frame_approx] = MotEstimblock(vid_Y(:,:,i-B-1+k),storage_frame,blksize,Rx,Ry);
            [vid_mv(:,:,:,2,i-B-1+k) frame_approx2] = MotEstimblock(vid_Y(:,:,i-B-1+k),storage_frame2,blksize,Rx,Ry);
            vid_error(:,:,i-B-1+k) = double(vid_Y(:,:,i-B-1+k))-double(frame_approx)/2-double(frame_approx2)/2;
            vid_out(:,:,i-B-1+k) = quantizationblock(DCTblock(vid_error(:,:,i-B-1+k),K),Q);
        end
    end
    
    lastframe = i;
    
    % Encoding P frames
    for j=B+1:B+1:P+P*B+B
        if i+j<=t
            storage_frame = cast(invDCTblock(invQuantizationblock(vid_out(:,:,i+j-B-1),Q)),class(vid_in));
            [vid_mv(:,:,:,1,i+j) frame_approx] = MotEstimblock(vid_Y(:,:,i+j),storage_frame,blksize,Rx,Ry);
            vid_error(:,:,i+j) = cast(vid_Y(:,:,i+j),'double')-cast(frame_approx,'double');
            vid_out(:,:,i+j) = quantizationblock(DCTblock(vid_error(:,:,i+j),K),Q);
            storage_frame2 = cast(invDCTblock(invQuantizationblock(vid_out(:,:,i+j),Q)),class(vid_in));

            % Encoding B frames preceeding P frames
            for k=1:B
                [vid_mv(:,:,:,1,i+j-B-1+k) frame_approx] = MotEstimblock(vid_Y(:,:,i+j-B-1+k),storage_frame,blksize,Rx,Ry);
                [vid_mv(:,:,:,2,i+j-B-1+k) frame_approx2] = MotEstimblock(vid_Y(:,:,i+j-B-1+k),storage_frame2,blksize,Rx,Ry);
                vid_error(:,:,i+j-B-1+k) = double(vid_Y(:,:,i+j-B-1+k))-double(frame_approx)/2-double(frame_approx2)/2;
                vid_out(:,:,i+j-B-1+k) = quantizationblock(DCTblock(vid_error(:,:,i+j-B-1+k),K),Q);
            end
            lastframe = i+j;
        end
    end
end
if lastframe < t
    for k=lastframe+1:t
        vid_error(:,:,k)=cast(vid_Y(:,:,k),'double');
        vid_out(:,:,k)=quantizationblock(DCTblock(vid_error(:,:,k),K),Q);
    end
end
end

