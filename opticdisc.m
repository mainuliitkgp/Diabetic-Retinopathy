function [radii, centers, od2eye] = opticdisc(img)
%OPTICDSIC computes the radius and center of the opticdisc of the image.
%Along with this, the optic disc to eye ratio is also computed and
%returned.
 
    %img = imresize(img, [447, 672]);
    r = img(:,:,1);
    % calculating area of only the main object of the image and extracting its pixels:
    binaryImage = im2bw(r,0.03);
    binaryImage = imfill(binaryImage,'holes');
    label = bwlabel(binaryImage, 8);
    measure = regionprops(label,r,'all');
    a=zeros(size(measure,1),1);
    for i=1:size(measure,1)
        a(i)=measure(i).Area;
    end
    [area pos] = max(a);
    discPixels=measure(pos).PixelIdxList;
    %%
    r = imfilter(r, ones(5,5)/25);
    r = medfilt2(r, [5 5]);
    %imshow(r)
    
    seg = fuzzysegment(double(r(discPixels)), 8);
    j = zeros(447,672);
    j = logical(j);
    j(discPixels) = seg;
    %figure, imshow(j)
    
    %figure, imshow(img)
    [centers, radii, metric] = imfindcircles(j, [15,40]);
    %viscircles(centers, radii, 'Edgecolor', 'b');
    
    od2eye = mean(radii)*mean(radii)*pi/numel(discPixels);
end