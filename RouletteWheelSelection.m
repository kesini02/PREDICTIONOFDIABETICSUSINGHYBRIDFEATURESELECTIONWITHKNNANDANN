function i=RouletteWheelSelection(p)

    r=rand;
%     r=0.9943;
    c=cumsum(p);
    i=find(r<=c,1,'first');

end