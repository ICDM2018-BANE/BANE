%% Binarized Attributed Network Embedding
load cora.mat %wiki.mat %blogcatalog.mat %cora.mat citeseer.mat
Z = diag(sum(attributes.^2,2).^-.5); % temporary value
Z(isinf(Z)) = 0; % temporary value
X = Z'*attributes;
clear Z;
nodenum=size(network,2);
A=network;
A = A+eye(nodenum);
D = diag(sum(A,1));
DN = diag(sum(A,1).^(-1));
L = D - A;
%% Calulate P
k = 4;  %citeseer:4    wiki:1       blog:2
gamma = 0.7;    %citeseer:0.9    wiki:0.2    blog:0.4
P = ((eye(nodenum)-gamma*DN*L)^k)*X;  
[U,S1] = svds(P, 200);
P = U*S1;
%% Calculate binary B
B = dcc(P',100,0.001);
%% Classfication
train_ratio = 0.9;
C = 5;
numOfGroup = 7; %citeseer:6  wiki:19  blog:6
[F1macro2,F1micro2] = svmTest(B,labels,numOfGroup,train_ratio,C);
