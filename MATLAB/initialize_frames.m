readerobj = VideoReader('star_collapse.avi','tag','myreader1');
vidFrames = read(readerobj);
numFrames = get(readerobj,'NumberOfFrames');
for k=1:numFrames
    mov(k).cdata=vidFrames(:,:,:,k);
    mov(k).colormap=[];
end
hf = figure;
set(hf, 'position', [150 150 readerobj.Width readerobj.Height])
movie(hf,mov,1,readerobj.FrameRate);

[x y z t] = size(vidFrames);
vidComp = zeros(x/3,y/3,3,t,class(vidFrames));
for i=1:x/3
    for j=1:y/3
        vidComp(i,j,:,:)=mean(mean(vidFrames(3*i-2:3*i,3*j-2:3*j,:,:)));
    end
end

vidComp2 = vidComp(:,:,:,1:50);

