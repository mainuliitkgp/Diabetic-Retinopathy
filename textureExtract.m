function [texture] = textureExtract(img,leafPixels)

gray = im2uint8(rgb2gray(img));
img= uint8(zeros(size(gray)));
pix = gray(leafPixels);
img(leafPixels)=pix+1;

glcm1 = graycomatrix(img, 'NumLevels', 256, 'Offset', [0 1]);
glcm2 = graycomatrix(img, 'NumLevels', 256, 'Offset', [-1 1]);
glcm3 = graycomatrix(img, 'NumLevels', 256, 'Offset', [-1 0]);
glcm4 = graycomatrix(img, 'NumLevels', 256, 'Offset', [-1 -1]);
texture = [0 0 0 0];
c = (glcm1 + glcm2 + glcm3 + glcm4)/4;
c(:,1)=0;
c(1,:)=0;
n = size(c,1);
%Inertia
stats = graycoprops(uint8(c),'Contrast Correlation Energy Homogeneity');
texture(1) = stats.Contrast;
texture(2) = stats.Correlation;
texture(3) = stats.Energy;
texture(4) = stats.Homogeneity;
% for i=1:n
%    for j = 1:n
%       texture(1) = texture(1) + c(i,j)*(i-j)^2;
%    end
% end

%Correlation

% [muI sigI] = mu_i(c);
% [muJ sigJ] = mu_j(c);
% for i = 1:n
%    for j=1:n
%        texture(2)=texture(2) + ((i-muI)*(j-muJ)*c(i,j))/(sigI*sigJ);
%    end
% end

%Energy
% for i=1:n
%    for j=1:n
%       texture(3) = texture(3) + c(i,j)*c(i,j); 
%    end
% end

%Homogeniety
% for i =1:n
%    for j=1:n
%       texture(4) = texture(4) + c(i,j)/(1+abs(i-j)); 
%    end
% end

end