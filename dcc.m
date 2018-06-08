function B = dcc(S,m,alfa)
%solve ||S-G'B||_F^2+alfa*||G||^2, 
nodeNum = size(S,2);
rng('default');
B = sign(randn(m, nodeNum))';
t1 = 5; 
t2 = 10;
% tol = 1e-5;
%% solve optimization function by fixing one variable each time
i = 0; 
while i < t1    
    i=i+1;  
    % G step
    G = (B'*B+alfa*eye(m))\(B'*S');  
    % B-step
    Q = (G*S)';         
    for time = 1:t2           
%         Z0 = B;
        for k = 1 : m
            B(:,k) = sign(Q(:,k) - B(:,[1:k-1,k+1:end])*G([1:k-1,k+1:end],:)*G(k,:)');
            
        end
%         if norm(B-Z0,'fro') < 1e-6 * norm(Z0,'fro')
%             break
%         end
    end
%     bias = norm(B'-W*T,'fro');
%     if bias < tol*norm(B,'fro')
%         break;
%     end 
end


