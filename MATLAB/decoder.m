function vid_out = decoder( vid_in, vid_mv, vid_Cb, vid_Cr, P, B, Q, class )
%Controlling function of the hybrid decoder

[x y t] = size(vid_in);

vid_Y = zeros(x,y,t,class);


for i=1:P+B*P+B+1:t
    vid_Y(:,:,i) = cast(invDCTblock(invQuantizationblock(vid_in(:,:,i),Q)),class);
    
    % Decoding the B frames preceeding I frames
    if i>1
        for k=1:B
            storage_frame = cast(invDCTblock(invQuantizationblock(vid_in(:,:,i-B-1),Q)),class);
            storage_frame2 = cast(invDCTblock(invQuantizationblock(vid_in(:,:,i),Q)),class);
            error = invDCTblock(invQuantizationblock(vid_in(:,:,i-B-1+k),Q));
            frame_approx =reconstructionblock(storage_frame,vid_mv(:,:,:,1,i-B-1+k));
            frame_approx2=reconstructionblock(storage_frame2,vid_mv(:,:,:,2,i-B-1+k));
            vid_Y(:,:,i-B-1+k)=cast(error+double(frame_approx)/2+double(frame_approx2)/2,class);
        end
    end
    
    lastframe=i;
    
    % Decoding P frames
    for j=B+1:B+1:P+P*B+B
        if i+j<=t
            storage_frame = cast(invDCTblock(invQuantizationblock(vid_in(:,:,i+j-B-1),Q)),class);
            error = invDCTblock(invQuantizationblock(vid_in(:,:,i+j),Q));
            frame_approx = reconstructionblock(storage_frame,vid_mv(:,:,:,1,i+j));
            vid_Y(:,:,i+j) = cast(error+cast(frame_approx,'double'),class);
            storage_frame2 = cast(invDCTblock(invQuantizationblock(vid_in(:,:,i+j),Q)),class);

            % Decoding B frames preceeding P frames
            for k=1:B
                error = invDCTblock(invQuantizationblock(vid_in(:,:,i+j-B-1+k),Q));
                frame_approx=reconstructionblock(storage_frame,vid_mv(:,:,:,1,i+j-B-1+k));
                frame_approx2=reconstructionblock(storage_frame2,vid_mv(:,:,:,2,i+j-B-1+k));
                vid_Y(:,:,i+j-B-1+k)=cast(error+double(frame_approx)/2+double(frame_approx2)/2,class);
            end
            lastframe = i+j;
        end
    end
end
if lastframe < t
    for k=lastframe+1:t
        vid_Y(:,:,k)=cast(invDCTblock(invQuantizationblock(vid_in(:,:,k),Q)),class);
    end
end
vid_out = ChrominanceUpsamplingBlock(vid_Y,vid_Cb,vid_Cr);
vid_out = YCbCrtoRGBblock(vid_out);

end

