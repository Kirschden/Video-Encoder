function [F2Y F2Cb F2Cr] = ChrominanceSubsamplingBlock(F1)

F2Y = F1(:,:,1,:);
F2Cb = F1(1:2:end,1:2:end,2,:);
F2Cr = F1(1:2:end,1:2:end,3,:);

end

