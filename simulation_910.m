clear

%% Parameters
N_a = 3;                %number of agents
U_values = linspace(0, 2, 101);
n_timesteps = 1000;
Gamma = -0.1;

%% simulations
initial_opinions = 1 - 2 * randn(1, N_a);
final_opinions = zeros(N_a, 2, length(U_values));
for ii = 1:length(U_values)
    U = U_values(ii);
    final_opinions(:, 1, ii) = SimulateOpinions(N_a, U, Gamma, n_timesteps, initial_opinions);
    final_opinions(:, 2, ii) = SimulateOpinions(N_a, U, Gamma, n_timesteps, -initial_opinions);
end



%% plot results
figure;
hold on;

%colors for negative and positive branches: 
colors = {'b', 'r'};

for branch = 1:2
    plot(U_values, squeeze(mean(final_opinions(:, branch, :), 1)), colors{branch}, 'LineWidth', 1.5);
end

xlabel('u'); ylabel('final_opinion'); grid on; hold off;

function final_opinions = SimulateOpinions(N_a, U, Gamma, n_timesteps, initial_opinions)
    %parameters
    dt = 0.1;              %timestep
    d = 1;
    Alpha = 1;
    

    b = zeros(N_a, 1);                  %no bias
    A = ones(N_a)-eye(N_a);               %maximally connected

    opinions = zeros(N_a, 1, n_timesteps);

    % Initial random opinions:
    opinions(:, 1, 1) = initial_opinions;

    %Simulation:
    for timestep = 1:n_timesteps-1
        X = opinions(:, 1, timestep);
        X_dot = -d*X + b + U*(tanh((Alpha*eye(N_a) + Gamma*A)*X));
    
        opinions(:, :, timestep+1) = X + dt*X_dot;
    end
    final_opinions = opinions(:,:, end);
end

