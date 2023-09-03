function tour2=CreateNeighbor(t1)

    swap_p=0.2;
    reversion_p=0.5;
    insertion_p=1-swap_p-reversion_p;    
    p=[swap_p reversion_p insertion_p];    
    method=RouletteWheelSelection(p);    
    switch method
        case 1
            % Swap
            as='swap';
            tour2=ApplySwap(t1);
            
        case 2
            % Reversion
            as='reverse';
            tour2=ApplyReversion(t1);
            
        case 3
            % Insertion
            as='insertion';
            tour2=ApplyInsertion(t1);
            
    end

end