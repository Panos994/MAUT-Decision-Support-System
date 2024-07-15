% Load original utilities
load maut_results;

s_values = 0.2:0.1:0.6; % Perturbations levels από 0.2 μέχρι 0.6 με βήματα του 0.1
ntimes = 10000; % 10^4 Number of Monte Carlo iterations

% Update 4/6
PRR_values = zeros(length(s_values), 1);

% Compute original ranks
[~, originalRanks] = sort(Utility);

% Loop over each perturbation level
for idx = 1:length(s_values)
    s = s_values(idx);
    fprintf('Perturbation level: %f\n', s);

    NPRR = zeros(ntimes, 1); % Initialization of the matrix of RR for each iteration

    % Initialization of the new weights. We initialize the weights with old ones
    wn = w; % Initialization of weights criteria
    wf1n = wf1; % Initialization of factor weights under C1
    wf2n = wf2; % Initialization of factor weights under C2
    wf3n = wf3; % Initialization of factor weights under C3
    RAfn = RAf; % Initialization of alternatives relative importance for each factor
    ScenarioValue_ntimes = zeros(ntimes, Nalter); % Initialization of alternatives priorities for each iteration

    % MC simulation for ntimes iterations
    for iter = 1:ntimes
        fprintf('%d/%d\n', iter, ntimes);

        % PWC matrix perturbation
        for m = 1:M
            [wn(:, m), ~] = pertub_matrix(Pc(:, :, m), s); % Perturbed matrix of criteria
            [wf1n(:, m), ~] = pertub_matrix(Pfc1(:, :, m), s); % Perturbed matrix of criteria
            [wf2n(:, m), ~] = pertub_matrix(Pfc2(:, :, m), s); % Perturbed matrix of criteria
            [wf3n(:, m), ~] = pertub_matrix(Pfc3(:, :, m), s); % Perturbed matrix of criteria
            for i = 1:Nfactors
                [RAfn(:, i, m), ~] = pertub_matrix(PAf(:, :, i, m), s); % Perturbed matrix of criteria
            end
        end

        % Estimate average weights and relative scores for the M experts
        Wn = mean(wn, 2);
        F1n = mean(wf1n, 2);
        F2n = mean(wf2n, 2);
        F3n = mean(wf3n, 2);
        Rn = mean(RAf, 3);
        Fn = [F1n; F2n; F3n];

        % Estimation of Alternatives Priorities using utility values
        Utility = zeros(Nalter, 1);
        for i = 1:Nalter % Alternatives
            factorIndex = 1;
            for k = 1:N % Criteria
                for j = 1:Nf(k) % Factors
                    Utility(i) = Utility(i) + Wn(k) * Fn(factorIndex) * utility_values(k, i);
                    factorIndex = factorIndex + 1;
                end
            end
        end

        % Debug: Display computed utility values
        disp(['Utility values for iteration ', num2str(iter), ' at perturbation level ', num2str(s), ':']);
        disp(Utility');

        ScenarioValue_ntimes(iter, :) = Utility';

        % Calculate new ranks
        [~, newRanks] = sort(Utility);

        % Compute rank inversion
        NPRR(iter) = rankinversion(originalRanks, newRanks); % RR of alternatives priorities for each iteration
    end

    PRR = sum(NPRR) / ntimes;
    fprintf('Final PRR for perturbation level %f: %f\n', s, PRR);

    % Update PRR_values array
    PRR_values(idx) = PRR;
end

% Update 4/6: Plotting the results
figure;
plot(s_values, PRR_values, '-o');
xlabel('Perturbation Strength (s)');
ylabel('Probability of Rank Reversal (PRR)');
title('PRR vs Perturbation Strength');
grid on;

% Set y-axis limits and ticks
ylim([0, 0.16]);
yticks(0:0.02:0.16);

% Set x-axis limits and ticks
xlim([0.2, 0.7]);
xticks(0.2:0.1:0.7);

% Debug: Display PRR values
disp('PRR values:');
disp(PRR_values');