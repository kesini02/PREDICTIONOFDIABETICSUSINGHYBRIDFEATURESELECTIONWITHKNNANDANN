
function [z, out]=feature_select_cost(q,nf,data)
   
    x=data.x;
    t=data.t;
    S=q(1:nf);  
    rf=nf/numel(q);
    xs=x(S,:);
    
    % Weights 
    wTrain=0.8;
    wTest=1-wTrain;

    % Number of Runs
    nRun=3;
    EE=zeros(1,nRun);
    for r=1:nRun
          results=find_cost(xs,t);
%         save res results
%             load res
          EE(r) = wTrain*results.TrainData.E + wTest*results.TestData.E;
    end
    
    E=mean(EE);
    z=E;
    % Set Outputs
    out.S=S;
    out.nf=nf;
    out.rf=rf;
    out.E=E;
    out.z=z;
       
end