function [seg] = fuzzysegment(img, nclus)
%nclus = 8 %3
seg=img(:);
n=size(seg,1);
cluster=zeros([1 nclus]);
num=zeros([1 nclus]);
[center,U,obj_fcn] = fcm(seg,nclus,[NaN NaN NaN 0]);
for i=1:n
    [m,row]=max(U(:,i));
    cluster(row)=cluster(row)+seg(i);
    num(row)=num(row)+1;
end

cluster=cluster./num;
[m, col] = max(cluster);
for i = 1:n
   [m, row] = max(U(:,i));
   if row==col
       seg(i)=1;
   else seg(i)=0;
   end
end
%seg=reshape(seg,512,512);
end