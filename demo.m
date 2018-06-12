%% A CDFTSVM demo  on artifical datases
clc
clear
%% load train data
load tr1
load ltr1
traindata=tr1(:,1:19);
%traindata=real(traindata);
trainlabel=ltr1(:,1)*(-2)+1;

%% load test data
load te1
load lte1
testdata=te1(:,1:19);
%testdata=real(testdata);
testlabel=lte1(:,1)*(-2)+1;

% Nolinear CDFTSVM
%% seting parameters
Parameter.ker='linear';
Parameter.CC=8;
Parameter.CR=8;
Parameter.p1=0.2;
Parameter.v=10;
Parameter.algorithm='CD'; 
%% training rbf cdftsvm
[ftsvm_struct] = ftsvmtrain(traindata,trainlabel,'linear',8,8,0.2,10,'CD');
L=kfoldLoss(ftsvm_struct);

%% testing rbf cdftsvm
%testdata=scalingnorm(testdata);
[acc,outclass]= ftsvmclass(ftsvm_struct,testdata,testlabel);

%% visualization
 %ftsvmplot(ftsvm_struct,traindata,trainlabel);
