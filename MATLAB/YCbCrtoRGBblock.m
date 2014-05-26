function F2 = YCbCrtoRGBblock( F1 )
%Luminance/Chrominance to RGB converter

[x y z t] = size(F1);
F2 = F1*0;

if z ~= 3
    fpritnf('Image is not standard YCbCr\n')
    return
end

for frame=1:t
    F2(:,:,:,frame) = ycbcr2rgb(F1(:,:,:,frame));
end

end

