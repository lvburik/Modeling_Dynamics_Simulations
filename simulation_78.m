%% Parameters
N_o = 2;                %number of opinions
N_a = 3;                %number of agents

dt = 0.01;              %timestep
n_timesteps = 1000;      %number of timesteps

% homogenious parameters

d = 1;
U = 0.5;
Alpha = 1;
Beta = 1;
Gamma = 1;
Delta = 1;

%homogenious so derive some matrixes based on general parameters

d = d*diag(ones(1, N_a));
b = zeros(N_a, N_o);                  %no bias
U = U*diag(ones(1, N_a));
Alpha = Alpha*ones(N_a);
Beta = Beta*ones(N_a);
Gamma = Gamma*ones(N_a)-eye(N_a);     %0 on diagonal
Delta = Delta*ones(N_a)-eye(N_a);     %0 on diagonal


Projection_Matrix = eye(N_o)-1/N_o*ones(N_o, N_o);
opinion_matrixes = zeros(N_a, N_o, n_timesteps);


%% Initial opinions:

% Generate random opinions for each agent at t = 0
for agent = 1:N_a
    % Random values between -1 and 1
    random_vals = 2*rand(1, N_o) - 1;  
    
    % Shift to make the sum = 0 (centered around neutrality)
    random_vals = random_vals - mean(random_vals);
    
    % Assign to opinion matrix
    opinion_matrixes(agent, :, 1) = random_vals;
end

%% Simulations:
for timestep = 1:n_timesteps-1
    Z = opinion_matrixes(:, :, timestep);
    f = -d*Z + b + U*(tanh((Alpha + Gamma)*Z)+(tanh((Beta + Delta)*Z)*ones(N_o, 1))*ones(1, N_o));
    Z_dot = f*Projection_Matrix;
    
    opinion_matrixes(:, :, timestep+1) = Z + dt*Z_dot;
end


