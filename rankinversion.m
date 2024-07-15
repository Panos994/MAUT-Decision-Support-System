function N = rankinversion(originalRanks, newRanks)
    % Υπολογισμός του πλήθους των στοιχείων
    n = length(originalRanks);

    % Διπλός βρόχος για τον έλεγχο κάθε ζεύγους (i, j)
    for i = 1:n-1
        for j = i+1:n
            % Έλεγχος για αναστραμμένο ζεύγος
            if (originalRanks(i) < originalRanks(j) && newRanks(i) > newRanks(j)) || ...
               (originalRanks(i) > originalRanks(j) && newRanks(i) < newRanks(j))
                N = 1;
                return;  % Επιστροφή 1 αν υπάρχει τουλάχιστον μία αναστροφή
            end
        end
    end

    % Αν φτάσουμε εδώ σημαίνει ότι δεν υπάρχει αναστροφή
    N = 0;
end