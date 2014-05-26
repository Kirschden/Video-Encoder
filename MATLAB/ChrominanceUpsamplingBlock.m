function [F2] = ChrominanceUpsamplingBlock(F1Y, F1Cb, F1Cr)

    F2(:,:,1,:) = F1Y;

    [M N O P] = size(F1Cb);

    for i = 1:M
        for j = 1:N
%             F2(2*i-1:2*i,2*j-1:2*j,2,:) = F1Cb(i,j,:);
%             F2(2*i-1:2*i,2*j-1:2*j,3,:) = F1Cr(i,j,:); 
            F2(2*i-1,2*j-1,2,:)=F1Cb(i,j,:);
            F2(2*i-1,2*j,2,:)=F1Cb(i,j,:);
            F2(2*i,2*j-1,2,:)=F1Cb(i,j,:);
            F2(2*i,2*j,2,:)=F1Cb(i,j,:);
            F2(2*i-1,2*j-1,3,:)=F1Cr(i,j,:);
            F2(2*i-1,2*j,3,:)=F1Cr(i,j,:);
            F2(2*i,2*j-1,3,:)=F1Cr(i,j,:);
            F2(2*i,2*j,3,:)=F1Cr(i,j,:);
        end
    end
end
