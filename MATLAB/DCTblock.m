function F2 = DCTblock(F1,K)
%DCT block of hybrid coding system

[x y] = size(F1);

F2 = double(F1)*0;
Kkey = [1 2 6 7 15 16 28 29;
3 5 8 14 17 27 30 43;
4 9 13 18 26 31 42 44;
10 12 19 25 32 41 45 54;
11 20 24 33 40 46 53 55;
21 23 34 39 47 52 56 61;
22 35 38 48 51 57 60 62;
36 37 49 50 58 59 63 64];
Kmap = ones(8,8);
for i=1:8
    for j=1:8
        if Kkey(i,j) > K
            Kmap(i,j) = 0;
        end
    end
end
for i=1:8:x-7
    for j=1:8:y-7
        F2(i:i+7,j:j+7) = dct2(F1(i:i+7,j:j+7)).*Kmap;
    end
end

end

