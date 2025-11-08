clear

%% Parameters
N_a = 3;                %number of agents

dt = 0.01;              %timestep
n_timesteps = 1000;      %number of timesteps

% homogenious parameters

d = 1;
U = 10;
Alpha = 1;
Gamma = 0.1;


%homogenious so derive some matrixes based on general parameters

d = d*diag(ones(1, N_a));
b = zeros(N_a, 1);                  %no bias
U = U*diag(ones(1, N_a));

A = ones(N_a)-eye(N_a);               %maximally connected

opinions = zeros(N_a, 1, n_timesteps);

%% Initial opinions:

%random
opinions(:, 1, 1) = 2*rand(1, N_a)-1;

%% Simulation:
for timestep = 1:n_timesteps-1
    X = opinions(:, 1, timestep);
    X_dot = -d*X + b + U*(tanh((Alpha + Gamma*A)*X));
    
    opinions(:, :, timestep+1) = X + dt*X_dot;
end

%%Plotting

%plot opinions of agents over time
time = (0:n_timesteps-1) * dt;

% Colors for agents
colors = {'b', 'r', 'g'}; 

figure;
hold on;

% Loop over agents
for agent = 1:N_a
    plot(time, squeeze(opinions(agent, 1, :)), colors{agent}, 'LineWidth', 1.5);
end

xlabel('Time');
ylabel('opinion');
legend('Agent 1','Agent 2', 'Agent 3');
grid on;
title('Opinions over time for each Agent');
hold off;



