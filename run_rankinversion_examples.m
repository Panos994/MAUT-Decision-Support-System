disp('Παραδείγματα Ελέγχου:');

% Παράδειγμα 1
originalRanks1 = [1, 3, 2, 4];
newRanks1 = [1, 2, 3, 4];
inversions1 = rankinversion(originalRanks1, newRanks1);
disp('Παράδειγμα 1:');
disp(inversions1);  % Αναμένεται τιμή 1

% Παράδειγμα 2
originalRanks2 = [1, 2, 3, 4];
newRanks2 = [1, 2, 3, 4];
inversions2 = rankinversion(originalRanks2, newRanks2);
disp('Παράδειγμα 2:');
disp(inversions2);  % Αναμένεται τιμή 0

% Παράδειγμα 3
originalRanks3 = [1, 2, 3, 4];
newRanks3 = [4, 3, 2, 1];
inversions3 = rankinversion(originalRanks3, newRanks3);
disp('Παράδειγμα 3:');
disp(inversions3);  % Αναμένεται τιμή 1

% Παράδειγμα 4
originalRanks4 = [4, 1, 3, 2];
newRanks4 = [1, 2, 3, 4];
inversions4 = rankinversion(originalRanks4, newRanks4);
disp('Παράδειγμα 4:');
disp(inversions4);  % Αναμένεται τιμή 1

% Παράδειγμα 5
originalRanks5 = [2, 4, 3, 1];
newRanks5 = [1, 2, 3, 4];
inversions5 = rankinversion(originalRanks5, newRanks5);
disp('Παράδειγμα 5:');
disp(inversions5);  % Αναμένεται τιμή 1
