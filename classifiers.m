function [B,acc] = classifiers(feat3, targ2)
newfeat = feat3';
B = TreeBagger(85, newfeat(1:1000, :), targ2(1:1000)', 'oobpred', 'on');
pred = str2num(cell2mat(B.predict(newfeat(1001:1080, :))));
actual = targ2(1001:1080)';
acc = 0;
spc_num = 0;
sen_num = 0;
% true number of diseased patients
sen_den = numel(find(actual ~= 1));
% true number of non-diseased patients
spc_den = numel(find(actual == 1));
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
acc = acc/numel(actual)
sen = sen_num/sen_den
spc = spc_num/spc_den
end