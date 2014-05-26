function F2 = invDCTblock(F1)
%Inverse DCT block of hybrid coding system

[x y] = size(F1);

F2 = F1*0;

for i=1:8:x-7
    for j=1:8:y-7
        F2(i:i+7,j:j+7) = idct2(F1(i:i+7,j:j+7));
    end
end

end

