function [mv predict] = MotEstimblock(anchor,target,blksz,Rx,Ry)
%Motion estimation block of hybrid encoding system 

% [x y] = size(anchor);
% 
% if (mod(x,blksz) ~= 0) || (mod(y,blksz) ~= 0)
%     fprintf('Dimensions are not a multiple of block size\n')
%     return
% end
% 
% % Matrix for motion vectors mv(:,:,1) for x comp., mv(:,:,2) for y comp.
% mv = zeros(x/blksz,y/blksz,2);
% % Predicted image
% predict = anchor*0;
% 
% % Traverse through the image blocks
% for i = 1:blksz:x
%     for j = 1:blksz:y
%         % Create a matrix for comparing the MAD values within search window
%         MAD = int16(ones(2*Rx+1,2*Ry+1))*32767;
%         % Compare the current block to the blocks in its search window
%         for m = i-Rx:i+Rx
%             for n = j-Ry:j+Ry
%                 if (m>0) && (m < (x-blksz+2)) && (n>0) && (n < (y-blksz+2))
%                     MAD(m-i+Rx+1,n-j+Ry+1) = sum(sum(abs(int16(target...
%                         (m:m+blksz-1,n:n+blksz-1)) - int16(...
%                         anchor(i:i+blksz-1,j:j+blksz-1))))); 
%                 end
%             end
%         end
%         % Identify the index of the minimum MAD
%         [col_mins col_min_loc] = min(MAD);
%         [temp min_y] = min(col_mins);
%         min_x = col_min_loc(min_y);
%         % Use minimum MAD index to calculate motion vector
%         mv(ceil(i/blksz),ceil(j/blksz),:) = [min_x - Rx-1, min_y - Ry-1];
%         % Update predicted image
%         predict(i:i+blksz-1,j:j+blksz-1) = target(i+min_x-Rx-1:i+min_x-Rx+blksz-2, ...
%             j+min_y-Ry-1:j+min_y-Ry+blksz-2);
%     end
% end

[m,n] = size(anchor);
anchor = double(anchor);
target = double(target);

% For each block, calculate the minimal error and its associated 
% displacement vector
for i = 1:1:m/blksz
    for j = 1:1:n/blksz
        i1 = (i-1)*blksz + 1;
        j1 = (j-1)*blksz + 1;
        e = 1000000;
        for k = max(1,i1-Rx):1:min(m-blksz+1,i1+Rx)
            for l = max(1,j1-Ry):1:min(n-blksz+1,j1+Ry)
                et = sum(sum(abs(target(k:k+blksz-1,l:l+blksz-1)-...
                    anchor(i1:i1+blksz-1,j1:j1+blksz-1))));
                if et < e
                    e = et;
                    mv(i,j,1) = k - i1;
                    mv(i,j,2) = l - j1;
                end
            end
        end
        predict(i1:i1+blksz-1,j1:j1+blksz-1) = target(mv(i,j,1)+...
            i1:mv(i,j,1)+i1+blksz-1, mv(i,j,2)+j1:mv(i,j,2)+j1+blksz-1);
    end
end

end