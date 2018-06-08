%% Divide Network
net = network;
ratioTrain = 0.9; 
[train, test] = DivideNet(net,ratioTrain);              
train = sparse(train); 
test = sparse(test);
train = spones(train + train'); 
test = spones(test+test');           
%% 
A = train;
A = A+eye(nodenum);
D = diag(sum(A,1));
DN = diag(sum(A,1).^(-1));
L = D - A;
P = ((eye(nodenum)-0.7*DN*L)^4)*X;
[U,S1] = svds(P, 200);
P = U*S1;
B=dcc(P',100,0.001);

%%
S = B*B';
n = 10000;
CalcAUC( train, test, S, n )