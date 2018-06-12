function[f_vector]=featExtract(img_rgb)
%FEATEXTRACT extracts the statistical features of the input image and
%returns it as a vector.

    % resizing image and converting to grayscale and performing initializations
    img_rgb=imresize(img_rgb,[447 672]);
    img=im2uint8(rgb2gray(img_rgb));
    [r c]=size(img);
    n = r*c;
    nFeat = 14; % number of features
    f_vector=double(zeros(nFeat,1));
    
    % calculating area of only the main object of the image and extracting its
    % pixels
    binaryImage = im2bw(img,0.03); % optic disc mask
    binaryImage = imfill(binaryImage,'holes');
    label = bwlabel(binaryImage, 8);
    measure = regionprops(label,img,'all');
    a=zeros(size(measure,1),1);
    for i=1:size(measure,1)
        a(i)=measure(i).Area;
    end
    [area pos] = max(a);
    discPixels = measure(pos).PixelIdxList;
    
    hist=imhist(img(discPixels));
    %%
    % Statistical features
    
    % Entropy
    f_vector(1) = 0;
    for i=1:256
        p = hist(i)/n;
        if p~=0
            f_vector(1) = f_vector(1) -p*log2(p);
        end
    end
    
    % Median
    asc=sort(img(discPixels));
    f_vector(2)=median(asc);
    
    % Mode
    f_vector(3)=mode(double(img(discPixels)));
    
    % Variance & S.D
    hist_norm=hist/area;
    mean = sum([0:255]'.*hist_norm);
    t=img(discPixels);
    v = double(t) - mean;
    f_vector(4) = sum(v.*v/area);
    f_vector(5) = sqrt(f_vector(4));
    
    % Number of 1's in binary image
    img_hsv = rgb2hsv(img_rgb);
    intensity = img_hsv(:,:,3);
    
    seg1 = fuzzysegment(intensity(discPixels), 3);
    seg = zeros(r,c);
    seg(discPixels) = seg1;
    seg = bwmorph(seg,'skel',Inf);
    t = seg(:);
    num1 = sum(t);
    
    % Number of peaks in histogram:
    f_vector(6) = length(findpeaks(hist));
    
    % Red density:
    redPlane = img_rgb(:,:,1);
    f_vector(7) = sum(redPlane(:)>150)/area;
    
    % Fraction of white pixels
    f_vector(8) = num1/area;
    
    % Color moments:
    intensity=img_hsv(:,:,2);
    moment = colorMoment(intensity(discPixels));
    f_vector(9) = moment(2);
    intensity=img_hsv(:,:,3);
    moment = colorMoment(intensity(discPixels));
    f_vector(10:11) = moment(1:2);
    
    % Texture
    texture = textureExtract(img_rgb,discPixels);
    f_vector(12)=texture(1);
    f_vector(13:14)=texture(3:4);
end