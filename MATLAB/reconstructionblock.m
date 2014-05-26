function im_out = reconstructionblock( im_in, mv )
%Recreate the prediction image using the motion vectors

im_out = im_in*0;

[x y] = size(im_in);
[x2 y2] = size(mv);
blksz = x/x2;

for i=1:blksz:x
    for j=1:blksz:y
        mv_x = mv(ceil(i/blksz),ceil(j/blksz),1);
        mv_y = mv(ceil(i/blksz),ceil(j/blksz),2);
        im_out(i:i+blksz-1,j:j+blksz-1)=im_in(i+mv_x:i+blksz-1+mv_x,j+mv_y:j+blksz-1+mv_y);
    end
end

end

