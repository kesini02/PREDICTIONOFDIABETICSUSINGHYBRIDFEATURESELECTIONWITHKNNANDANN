function BestAnt=aco_search(data,newsol)

% Best Ant
BestAnt.Cost=inf;

MaxIt=6;
%% Ant Colony Matrix
nVar=data.nx;
tau0=1;	% Initial Phromone
nAnt=13;
alpha=1;        % Phromone Exponential Weight
beta=1;         % Heuristic Exponential Weight

rho=0.05;       % Evaporation Rate
% Initialization

eta=ones(nVar,nVar);        % Heuristic Information Matrix

tau=tau0*ones(nVar,nVar);   % Phromone Matrix

BestCost=zeros(MaxIt,1);    % Array to Hold Best Cost Values
% Empty Ant
empty_ant.Tour=[];
empty_ant.Cost=[];
empty_ant.Out=[];
ant=repmat(empty_ant,nAnt,1);

Q=1;

for it=1:MaxIt
   for k=1:nAnt

       ant(k).Tour=randi([1 nVar]);
%         
        for l=2:nVar

            i=ant(k).Tour(end);

            P=tau(i,:).^alpha.*eta(i,:).^beta;

            P(ant(k).Tour)=0;

            P=P/sum(P);

            j=RouletteWheelSelection(P);

            ant(k).Tour=[ant(k).Tour j];

        end
        
     ant(k).Cost=newsol.Cost;
     ant(k).Out=newsol.Out;

     if ant(k).Cost<BestAnt.Cost
        BestAnt=ant(k);
    end
   end
    % Update Phromones
for k=1:nAnt

    tour=ant(k).Tour;

    tour=[tour tour(1)];

    for l=1:nVar

        i=tour(l);
        j=tour(l+1);

        tau(i,j)=tau(i,j)+Q/ant(k).Cost;

    end

end

    % Evaporation
    tau=(1-rho)*tau;

    % Store Best Cost
    BestCost(it)=BestAnt.Cost;

end  

end