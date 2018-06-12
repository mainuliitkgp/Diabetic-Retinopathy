function [net, acc, sen, spc] = neuralnetscript(feat3, nn_targ3, epoch)
%NEURALNETSCRIPT trains an artificial neural network using Bayesian
%Regularization for detecting the presence of diabetic retinopathy in
%fundus images. The network assigns an integer grade in the range 1-4
%depending on the severity of the disease.

inputs = feat3;
targets = nn_targ3;

% Create a Pattern Recognition Network
hiddenLayerSize = 35;
net = patternnet(hiddenLayerSize);
net.trainFcn = 'trainbr';

% Set up Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;


% Train the Network
net.trainParam.showWindow = false;
net.trainParam.epochs = epoch;
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
[~,pred] = max(outputs);
[~,actual] = max(targets);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);

spc_num = 0;
sen_num = 0;
acc = 0;
% true number of diseased patients
sen_den = numel(find(actual ~= 1));
% true number of non-diseased patients
spc_den = numel(find(actual == 1));
sen1 = 0;
sen2 = 0;
sen3 = 0;
sen4 = 0;
spc1 = 0;
spc2 = 0;
spc3 = 0;
spc4 = 0;
for i = 1:numel(actual)
    if actual(i) == pred(i)
        acc = acc + 1;
        if actual(i) ~= 1
            sen_num = sen_num + 1;
        end
        if actual(i) == 1
            spc_num = spc_num + 1;
        end
    end
end
acc = acc/numel(actual);
sen = sen_num/sen_den;
spc = spc_num/spc_den;


% Plots
%  figure, plotperform(tr)
%  figure, plottrainstate(tr)
%figure, plotconfusion(targets,outputs)
% figure, ploterrhist(errors)

end