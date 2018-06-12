function density = exudate(BW)
%EXUDATE extracts the exudates in an fundus image and calculates their
%pixel density.

    % Calculate the mask for the fundus pixels
    mask = im2bw(BW, 0.03);

    BW = imresize(BW, [447 672]);
    gra =BW;
    gra(:,:,1) = medfilt2(gra(:,:,1));
    hisimg = adapthisteq(gra(:,:,1));
    
    se = strel('disk',15);
    climg = imclose(hisimg,se);
    b = graythresh(climg);
    binimg = im2bw(climg,b+0.4); %.73
    [M N]= size(climg);
    tmpimg = hisimg;
    r =uint16(5*M*N/1000000);
    r = double(r*1000);
    %figure; imshow(binimg);
    
    s = bwareaopen(binimg,r);
    t = im2bw(gra(:,:,2),0.4);
    u = t-s;
   
    density = numel(find(u == 1))/numel(find(mask == 1));
end