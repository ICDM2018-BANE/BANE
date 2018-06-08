function [ train,test ] = DivideNet( net, ratioTrain)
    num_testlinks = ceil((1-ratioTrain) * nnz(net)/2);      
    
    [xindex, yindex] = find(tril(net));  linklist = [xindex yindex];    
   
    clear xindex yindex;  
  
    test = sparse(size(net,1),size(net,2));                 
    while (nnz(test) < num_testlinks)
        
       
        index_link = ceil(rand(1) * length(linklist));        
        uid1 = linklist(index_link,1); 
        uid2 = linklist(index_link,2);    
        
       
        net(uid1,uid2) = 0;     net(uid2,uid1) = 0;
       
        tempvector = net(uid1,:);
     
        sign = 0;  
  
        uid1TOuid2 = tempvector * net + tempvector;        
     
        if uid1TOuid2(uid2) > 0
            sign = 1;               
 
        else
            while (nnz(spones(uid1TOuid2) - tempvector) ~=0)   
         
                tempvector = spones(uid1TOuid2);
                uid1TOuid2 = tempvector * net + tempvector;    
             
                if uid1TOuid2(uid2) > 0
                    sign = 1;      
   
                    break;
                end
            end
        end 
   
        
     
        if sign == 1 
            linklist(index_link,:) = []; 
            test(uid1,uid2) = 1;
        else
            linklist(index_link,:) = [];
            net(uid1,uid2) = 1;   
            net(uid2,uid1) = 1;
        end   
      
    end   

    train = net;  test = test + test';

end
