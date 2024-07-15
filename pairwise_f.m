function P = pairwise_f(S,n)
  S=[1/9,1/8,1/7,1/6,1/5,1/4,1/3,1/2,1,2,3,4,5,6,7,8,9]; %nine level scale
  n = 3;
  P = zeros(n,n);



  for i = 1:n
    for j=1:n
      if(i==j)
        P(i,i) = 1 % fill in the diag
      elseif j>i % fill in the upper triangular arrayfun
        if rand(1) < 0.5 % Πιθανότητα 50% για τη χρήση τυχαίας τιμής ή μέσου όρου
          P(i,j)=S(ceil(length(S).*rand(1,1)));
        else
          P(i, j) = compute_mean(P);
        end %endof if
      end
    endfor %endof for j
  endfor %endof for i

  %fill in the lower triangular array
  for k=2:n %ξεκιναει απο τη δευτερη γραμμη
    for m=1:(k-1) %ενω εδω η λογικη ειναι αν ειμαι πχ 2η γραμμη θα ειμαι 1η στηλη και γιαυτο ειναι k - 1
      P(k,m)=1/P(m,k); %otherwise P(k,m)=inv(P(m,k));

    endfor %endof k
  endfor %endof m

  % Υπολογισμός του μέσου όρου των υπάρχουσων τιμών - αν κάποιος ειδικός δεν δώσει τιμή θα λαμβάνεται υπόψη ο μέσος όρος των υπάρχουσων τιμών
    function mean_val = compute_mean(matrix)
        non_zero_values = matrix(matrix ~= 0);
        mean_val = mean(non_zero_values);
    end


   % Υπολογισμός του CR
  [W, CR] = eigenMethodF2(P);

  if CR > 0.1

    disp('Inconsistent pairwise comparison matrix. Results rejected. Run it again');
    P = pairwise_f(S, n);
    %P = []; % Clear matrix
  end
end


