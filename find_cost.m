function results=find_cost(x,t)

    if ~isempty(x)
        
        trainFcn = 'trainlm';  % Levenberg-Marquardt

        % Create a Fitting Network
        hiddenLayerSize = 10;
        net = fitnet(hiddenLayerSize,trainFcn);

        net.input.processFcns = {'removeconstantrows','mapminmax'};
        net.output.processFcns = {'removeconstantrows','mapminmax'};

        net.divideFcn = 'dividerand';  % Divide data randomly
        net.divideMode = 'sample';  % Divide up every sample
        net.divideParam.trainRatio = 70/100;
        net.divideParam.valRatio = 15/100;
        net.divideParam.testRatio = 15/100;
        net.performFcn = 'mse';  % Mean squared error

        net.plotFcns = {};
        net.trainParam.showWindow=false;
%         size(x)
%         size(t)
        [net,tr] = train(net,x,t);
        save Trt net
%         load Trt
        
        % Test the Network
        y = net(x);
        e = gsubtract(t,y);
        E = perform(net,t,y);
        
    else        
        
        y=inf(size(t));
        e=inf(size(t));
        E=inf;
        
        tr.trainInd=[];
        tr.valInd=[];
        tr.testInd=[];
        
    end

    % All Data
    Data.x=x;
    Data.t=t;
    Data.y=y;
    Data.e=e;
    Data.E=E;
    
    % Train Data
    TData.x=x(:,tr.trainInd);
    TData.t=t(:,tr.trainInd);
    TData.y=y(:,tr.trainInd);
    TData.e=e(:,tr.trainInd);
    if ~isempty(x)
        TData.E=perform(net,TData.t,TData.y);
    else
        TData.E=inf;
    end
    
    % Validation and Test Data
    TData.x=x(:,[tr.testInd tr.valInd]);
    TData.t=t(:,[tr.testInd tr.valInd]);
    TData.y=y(:,[tr.testInd tr.valInd]);
    TData.e=e(:,[tr.testInd tr.valInd]);
    if ~isempty(x)
        TData.E=perform(net,TData.t,TData.y);
    else
        TData.E=inf;
    end
    
    % Export Results
    if ~isempty(x)
        results.net=net;
    else
        results.net=[];
    end
    results.Data=Data;
    results.TrainData=TData;
    % results.ValidationData=ValidationData;
    results.TestData=TData;
    
end