clc
clear 
close all

%Read the Input data
[datam,txt]=xlsread('Datam.xls');
isnan(datam)
[m n]=size(datam);
for i=1:m
    for j=1:n
        if isnan(datam(i,j))==1
            data(i,j)=0;
        else
            data(i,j)=datam(i,j);
        end
        
    end
end
 data
 
 % Feature Selection
disp('  Features Selection');
dap=data(:,1:end-1);
label=data(:,end);
data11.x=dap';
data11.t=label';
data11.nx=size(data11.x,1);
data11.nt=size(data11.t,1);
data11.nSample=size(data11.x,2);
nf=6;   
feature_cost_function=@(q) feature_select_cost(q,nf,data11);    % Cost Function

%Initialize Parametrs for Optimisation method

M_sub_iter=4;  %Sub-iterations
it=1;       % Iterations        
I_T0=3;        % Initial Temp.
T=I_T0;
max_It=6;      % MainIterations
alpha=0.99;    % Temp. Reduction Rate
sol.postn=crandom_solution(data11);
% Cost Function
[sol.Cost, sol.Out]=feature_cost_function(sol.postn);
BestCost=zeros(max_It,1); % To store Best Cost Values
BestSol=sol;

while(it<=max_It)
    
    for subit=1:M_sub_iter
        
        % Create and Evaluate New Solution
        newsol.postn=CreateNeighbor(sol.postn);
        [newsol.Cost, newsol.Out]=feature_cost_function(newsol.postn);
        SolCost(it)=newsol.Cost;
        % ACO
        BestAnt=aco_search(data11,newsol);
                
    end
       
    BestSol.Cost=BestAnt.Cost;    
    BestAntCost(it)=BestAnt.Cost;    
    % Store Best Cost
    BestCost(it)=BestSol.Cost;        

%     Update Temp.
    T=alpha*T;
    it=it+1;  
end
da=data11.x;
seld=BestSol.Out.S;
FET_SE=da(seld,:);
Sel_fea=txt(seld)
data_feat=FET_SE;
data_feat=data_feat';
data_feat(:,end+1)=data(:,end);
%Split attribute and target
data1=data(:,1:end-1);
target=data(:,end);
CVO = cvpartition(target,'KFold',10);
for i = 1:CVO.NumTestSets
          trIdx = CVO.training(i);
          teIdx = CVO.test(i);
          A=data1(trIdx,:);
          x=target(trIdx,:);
      
end
   for i = 1:CVO.NumTestSets
          trIdx = CVO.training(i);
          teIdx = CVO.test(i);
          test_x=data1(teIdx,:);
          test_y=target(teIdx,:);
      
   end
   
% KNN classifiction
k = 2;
metric = 'euclidean';
Model_knn = kNNeighbors(k,metric);
Model_knn2 = Model_knn.fit(A,x);
load Model_knn2
Ypred = Model_knn2.predict(test_x);
[c_matrixp,Result]= confusion.getMatrix(double(Ypred),test_y);
 
%%ANN CLASSIFIER
%Classifier Parameters
net1=newff(minmax(A'),[60,6,1],{'tansig','tansig','purelin','trainrp'});
net1.trainParam.show=1000;
net1.trainParam.lr=0.04;
net1.trainParam.epoches=50;
net1.trainParam.goals=1e-5;

%Train ANN
 [netann]=train(net1,A',x');
  
%Test ANN
load netann
y = abs(sim(netann,test_x'));
[c_matrixp1,Result1]= confusion.getMatrix(round(y),test_y');


Accuracy=Result.Accuracy*100
Error=Result.Error*100
Sensitivity=Result.Sensitivity*100
Specificity=Result.Specificity*100
Precision=Result.Precision*100
F1_score=Result.F1_score*100
MatthewsCorrelationCoefficient=Result.MatthewsCorrelationCoefficient*100
Kappa=Result.Kappa*100

disp('Getting Values')
TP=c_matrixp(1,1)
TN=c_matrixp(2,1)
FN=c_matrixp(1,2)
FP=c_matrixp(2,2)
Accuracy1=Result1.Accuracy*100
Error1=Result1.Error*100
Sensitivity1=Result1.Sensitivity*100
Specificity1=Result1.Specificity*100
Precision1=Result1.Precision*100
F1_score1=Result1.F1_score*100
MatthewsCorrelationCoefficient1=Result1.MatthewsCorrelationCoefficient*100
Kappa1=Result1.Kappa*100

%Plotting Graphs
%Accuracy Graph
x=[1 2];
y1=[Accuracy 0];
y2=[0 Accuracy1];
figure,bar(x,y1,0.2,'g');
hold on 
bar(x,y2,0.2,'r');
xlabel('Methods');
ylabel('Accuracy');
legend('KNN','ANN');

%Error Graph
x=[1 2];
y1=[Error 0];
y2=[0 Error1];
figure,bar(x,y1,0.2,'g');
hold on 
bar(x,y2,0.2,'r');
xlabel('Methods');
ylabel('Error');
legend('KNN','ANN');

%Sensitivity Graph
x=[1 2];
y1=[Sensitivity 0];
y2=[0 Sensitivity1];
figure,bar(x,y1,0.2,'m');
hold on 
bar(x,y2,0.2,'b');
xlabel('Methods');
ylabel('Sensitivity');
legend('KNN','ANN');

%Specificity Graph
x=[1 2];
y1=[Specificity 0];
y2=[0 Specificity1];
figure,bar(x,y1,0.2,'m');
hold on 
bar(x,y2,0.2,'r');
xlabel('Methods');
ylabel('Specificity');
legend('KNN','ANN');

%Precision Graph
x=[1 2];
y1=[Precision 0];
y2=[0 Precision1];
figure,bar(x,y1,0.2,'g');
hold on 
bar(x,y2,0.2,'m');
xlabel('Methods');
ylabel('Precision');
legend('KNN','ANN');


%F1_score Graph
x=[1 2];
y1=[F1_score 0];
y2=[0 F1_score1];
figure,bar(x,y1,0.2,'b');
hold on 
bar(x,y2,0.2,'r');
xlabel('Methods');
ylabel('F1_score');
legend('KNN','ANN');

%MatthewsCorrelationCoefficient Graph
x=[1 2];
y1=[MatthewsCorrelationCoefficient 0];
y2=[0 MatthewsCorrelationCoefficient1];
figure,bar(x,y1,0.2,'b');
hold on 
bar(x,y2,0.2,'r');
xlabel('Methods');
ylabel('MatthewsCorrelationCoefficient');
legend('KNN','ANN');

%Kappa Graph
x=[1 2];
y1=[Kappa 0];
y2=[0 Kappa1];
figure,bar(x,y1,0.2,'g');
hold on 
bar(x,y2,0.2,'b');
xlabel('Methods');
ylabel('Kappa');
legend('KNN','ANN');


