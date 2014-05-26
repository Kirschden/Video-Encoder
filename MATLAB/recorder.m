
for i=1:33
    writerObj = VideoWriter(['vid_out_Qis2tothepowerof' num2str((i-17)/4) '.avi']);
    writerObj.FrameRate=25;
    open(writerObj);
    for k=1:50
        writeVideo(writerObj,vid_out_vec(:,:,:,k,i));
    end
    close(writerObj);
end