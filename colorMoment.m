function [moment] = colorMoment(img)
%Returns a vector of moments for a given image PLANE
img = im2uint8(img);
[r c] = size(img);
n = r*c;
moment = [0 0 0];
t = double(img(:));

%Moment 1 (Mean):
moment(1) = sum(t)/n;

%Moment 2 (S.D):
t = t - moment(1);
for i=2:3
    f = t.^i;
    moment(i) = (sum(f)/n);
    if moment(i) < 0
        moment(i) = - moment(i);
        moment(i) = - (moment(i)^(1/i));
    else
        moment(i) = moment(i)^(1/i);
    end
end

end