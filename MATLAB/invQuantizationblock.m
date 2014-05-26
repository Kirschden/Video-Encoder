function image_out = invQuantizationblock( image_in, k )
%Quantization block for hybrid encoder

Q = [16 11 10 16 24 40 51 61;
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99];

% Q = ones(8,8);

[x,y] = size(image_in);

image_out = image_in*0;

for i=1:8:x
    for j=1:8:y
        image_out(i:i+7,j:j+7) = round(image_in(i:i+7,j:j+7).*Q*k);
    end
end

end

