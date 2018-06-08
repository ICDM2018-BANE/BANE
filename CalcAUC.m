function [ auc ] = CalcAUC( train, test, sim, n )

    sim = triu(sim - sim.*train);

    non = 1 - train - test - eye(max(size(train,1),size(train,2)));
    test = triu(test);
    non = triu(non);

    test_num = nnz(test);
    non_num = nnz(non);
    test_rd = ceil( test_num * rand( 1, n));  

    non_rd = ceil( non_num * rand( 1, n));
    test_pre = sim .* test;
    non_pre = sim .* non;
    test_data =  test_pre( test == 1 )';  

    non_data =  non_pre( non == 1 )';   

    test_rd = test_data( test_rd );
    non_rd = non_data( non_rd );
    clear test_data non_data;
    n1 = length( find(test_rd > non_rd) );  
    n2 = length( find(test_rd == non_rd));
    auc = ( n1 + 0.5*n2 ) / n;
end
