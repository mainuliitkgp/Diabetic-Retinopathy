function [AVR, e, v] = avr(img, radii, cent)
%AVR computes the Arteriovenous ratio of the input image. The radius and
%center of the optic disc must be passed as arguments to the function.

% 'r' is red component of the original image
% 'radii' is the radius of the Optic Disk
% 'cent' stores the center of the Optic Disk

    r = img(:,:,1);
    mask = im2bw(r, 0.03);
    A = uint8(r);
    e = bloodvessel(img, mask);
    rad = radii;
    a = A;
    % Initialize Region of Interest matrix
    roipix = zeros(447,672);
    % cent stores the center of the optic disk
    y = cent(1,1);
    x = cent(1,2);
    count = 0;
    for i = 1:447,
        for j = 1:672,
            if((((3*rad).^2)>=((i-x).^2 + (j-y).^2)) & (((i-x).^2 + (j-y).^2) > (2*rad.^2)))
                roipix(i,j) = e(i,j);
                count = count+1;
            else
                roipix(i,j) = 0;
                a(i,j) = 0;
            end
        end
    end
    %figure, imshow(a);

    %figure, imshow(roipix);

    ai = sum(a(:));
    % mean
    avgr = ai/count;

    cc = bwconncomp(roipix);
    [L,num] = bwlabel(roipix);
    v=zeros(3,num);
    total_val=zeros(447,672);
    
    for k=1:num,
        temp=0;
        total_val=0;
        mean1=0;
        for i=1:447
            for j=1:672
                if(L(i,j)==k)
                    temp = temp + 1;
                    total_val(i,j) = a(i,j);
                end
            end
        end
        sum1 = sum(total_val(:));
        mean1 = sum1/temp;
        if(mean1 > avgr)
            v(1,k) = 1; % this must be an artery
        else
            v(1,k) = 0; % this must be a vein
        end
        v(2,k) = mean1;
        v(3,k) = temp;
    end
    
    maxa=0;
    maxb=0;
    mina=500;
    minb=500;
    for i=1:num
        if(v(1,i)==1)
            if(maxa < v(3,i) )
                maxa = v(3,i);
            end
            if(mina > v(3,i) )
                mina= v(3,i);
            end
        else
            if(maxb < v(3,i) )
                maxb = v(3,i);
            end
            if(minb > v(3,i) )
                minb = v(3,i);
            end
        end
    end
    
    %% Calculating the AVR
    CRAE = (0.87*(maxa^2) + 1.01*(mina^2) - 0.22*(maxa*maxb) - 10.73)^0.5 ;
    CRVE = (0.72*(maxb^2) + 0.91*(minb^2) + 450.02)^0.5 ;
    AVR = CRAE/CRVE ;
end