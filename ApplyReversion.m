function t2=ApplyReversion(t1)

    n=numel(t1);    
    I=randsample(n,2);    
    i1=min(I);
    i2=max(I); 
    t2=t1;
    t2(i1:i2)=t1(i2:-1:i1);
    
end