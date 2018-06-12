function BW4 = bloodvessel(a, mk)
%BLOODVESSEL extracts the blood vessels in the fundus image. Here, 'a' is
%the input image and 'mk' is the mask for the fundus pixels.

    greenPlane = a(:, :, 2);
    filt=medfilt2(greenPlane,[30 30]);
    sub=(filt-greenPlane);
    conte = adapthisteq(sub);
    cont = adapthisteq(conte);
    
    SE1 = strel('diamond',1000);
    open.img = imtophat(cont,SE1);
    BWB = im2bw(open.img,0.05);
    
    % Removes from a binary image all connected components (objects) that
    % have fewer than P pixels
    bvareaopen =bwareaopen(BWB,750);
    
    B= imcomplement (bvareaopen);
    AB=im2bw(B,0.12);
    
    
    c=(~AB).*mk;
    
    BW3 = bwmorph(c,'majority');
    
    BW4 = bwmorph(BW3,'clean');
    BW4 = bwmorph(BW3,'thin');
 
    %figure, imshow(BW4) %image
end