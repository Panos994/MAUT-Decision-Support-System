% Define Example Values for Alternatives
alternatives = [3500, 10000, 5000; % Cost - κόστος αγοράς χονδρικής σε ευρώ
               6, 20, 30; % Performance (years) - πόσο κρατάει η απόδοση
                100000, 500000, 15000]; % Reliability (αγοραστές της 1ης εναλλακτικής 500.000, της 2ης 100.000 και της 3ης 15.000



% Calculate Utility Values for each criterion
%{
worst_values = min(alternatives, [], 2);
best_values = max(alternatives, [], 2);
%}



worst_values = zeros(size(alternatives, 1), 1);
best_values = zeros(size(alternatives, 1), 1);


for i = 1:size(alternatives,1)
  if i == 1
    worst_values(i) = max(alternatives(i,:));
    best_values(i) = min(alternatives(i,:));
  else
    worst_values(i)= min(alternatives(i,:));
    best_values(i)= max(alternatives(i,:));
  end
end

disp('Worst Values:');
disp(worst_values);
disp('Best Values:');
disp(best_values);






% Ensure best_values and worst_values are not the same to avoid division by zero
for i = 1:size(best_values, 1)
    if best_values(i) == worst_values(i)
        best_values(i) = best_values(i) + 1; % Adjust to prevent division by zero
    end
end


utility_values = (alternatives - worst_values) ./ (best_values - worst_values); %utility function

% Display Utility Values for verification
disp('Utility Values:');
disp(utility_values);

% Parameters
M = 15; % Number of experts
N = 3; % Number of criteria
Nalter = 3; % Number of alternatives
Nf = [3, 3, 3]; % Number of factors per criterion
Nfactors = sum(Nf, 2); % Total number of factors
S = [1/9, 1/8, 1/7, 1/6, 1/5, 1/4, 1/3, 1/2, 1, 2, 3, 4, 5, 6, 7, 8, 9]; % Nine level scale

% Initialize pairwise comparison matrices
Pc = ones(N, N, M);
Pfc1 = ones(Nf(1), Nf(1), M);
Pfc2 = ones(Nf(2), Nf(2), M);
Pfc3 = ones(Nf(3), Nf(3), M);
PAf = ones(Nalter, Nalter, Nfactors, M);

% Generate pairwise comparison matrices for each expert
for m = 1:M
  Pc(:, :, m) = pairwise_f(S, N);
  Pfc1(:, :, m) = pairwise_f(S, Nf(1));
  Pfc2(:, :, m) = pairwise_f(S, Nf(2));
  Pfc3(:, :, m) = pairwise_f(S, Nf(3));
  for i = 1:Nfactors
    PAf(:, :, i, m) = pairwise_f(S, Nalter);
  end
end

% Initialize matrices for storing weights and relative scores
w = zeros(N, M);
wf1 = zeros(Nf(1), M);
wf2 = zeros(Nf(2), M);
wf3 = zeros(Nf(3), M);
RAf = zeros(Nalter, Nfactors, M);

% Evaluate weights and relative scores for each expert
for m = 1:M
  w(:, m) = eigenMethodF2(Pc(:, :, m));
  wf1(:, m) = eigenMethodF2(Pfc1(:, :, m));
  wf2(:, m) = eigenMethodF2(Pfc2(:, :, m));
  wf3(:, m) = eigenMethodF2(Pfc3(:, :, m));
  for i = 1:Nfactors
    RAf(:, i, m) = eigenMethodF2(PAf(:, :, i, m));
  end
end

% Estimate average values of weights and relative scores
W = mean(w, 2);
F1 = mean(wf1, 2);
F2 = mean(wf2, 2);
F3 = mean(wf3, 2);
R = mean(RAf, 3);
F = [F1; F2; F3];

% Compute the overall utility for each alternative using utility values
Utility = zeros(Nalter, 1);
for i = 1:Nalter
  for k = 1:N
    for j=1:Nf(k)
     Utility(i) = Utility(i) + W(k) * F(j) * utility_values(k, i);
     disp(utility_values(k,i));
  end
 end
end


disp('Utility scores for each alternative:');
disp(Utility);



%{
figure;
hold on;
for k = 1:N
    criterion_name = sprintf('Criterion %d', k);
    plot(utility_values(k, :), 'o-', 'DisplayName', criterion_name);
end
%}

%{
plot(Utility);
hold off;
xlabel('Alternatives');
ylabel('Utility (0 to 1)');
title('Utility Values for Each Criterion');
legend('show');
%}

figure;
bar(Utility);
xlabel('Alternatives');
ylabel('Utility (0 to 1)');
title('Utility Scores for Each Alternative');
set(gca, 'XTickLabel', {'Alternative 1', 'Alternative 2', 'Alternative 3'});
legend('Utility Scores');

save('maut_results');
