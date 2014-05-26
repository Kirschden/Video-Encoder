function F2 = RGBtoYCbCrblock( F1 )
%RGB to Luminance/Chrominance converter

[x y z t] = size(F1);
F2 = F1*0;

if z ~= 3
    fpritnf('Image is not standard RGB\n')
    return
end

for frame=1:t
    F2(:,:,:,frame) = rgb2ycbcr(F1(:,:,:,frame));
end

end

