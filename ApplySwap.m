function t2=ApplySwap(t1)
    n=numel(t1);
    I=randsample(n,2);
    i1=I(1);
    i2=I(2);
    t2=t1;
    t2([i1 i2])=t1([i2 i1]);    
end