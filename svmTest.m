function [acc,acc1]=svmTest(features,labels,numOfGroup,train_ratio,C)
%for Blogcatalog  numofGroup=6. wiki:19
     numOfNode = length(labels); 
     in=1:length(labels);
     group=[in',labels+1];
     group = sparse(group(:,1),group(:,2),ones(size(group(:,1))),numOfNode,numOfGroup);
    %group = sparse([1:length(group)]',group(:),ones(length(group)),numOfNode,numOfGroup);

    grouptmp=group;
    acc=0;
    acc1 = 0;
    for i=1:size(features,2)
        if (norm(features(:,i))>0)
            features(:,i) = features(:,i)/norm(features(:,i));
        end
    end
    rng('default');
    for i=1:10  % do the procedure for 10 times and take the average
        rp = randperm(numOfNode);
        testId = rp(1:floor(numOfNode*(1-train_ratio)));

        groupTest = group(testId,:);
        group(testId,:)=[];

        trainId = [1:numOfNode]';
        trainId(testId,:)=[];

%         result=SocioDim(features, group, trainId, testId, C);
% 
% [predscore] = SocioDim(V, labels, index_tr, index_te, C)
       numU = length(testId);  % number of test instance
%X = V(index_tr, :);
X = features(trainId,:);
model = linearsvm(X, group, C);
result = features(testId, :) * model.W + repmat(model.bias, numU, 1);
        [res b] = evaluate(result,groupTest);
        acc=acc+res.micro_F1;
        acc1=acc1+res.macro_F1;
        group=grouptmp;
    end
    acc=acc/10;
    acc1=acc1/10;