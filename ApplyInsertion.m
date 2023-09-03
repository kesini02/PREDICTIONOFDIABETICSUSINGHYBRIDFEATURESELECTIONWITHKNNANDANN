function t2=ApplyInsertion(t1)

    n=numel(t1);    
    I=randsample(n,2);
%   I=[6 10];    
    i1=I(1);
    i2=I(2);    
    if i1<i2
        t2=t1([1:i1-1 i1+1:i2 i1 i2+1:end]);
    else
        t2=t1([1:i2 i1 i2+1:i1-1 i1+1:end]);
    end
    
end