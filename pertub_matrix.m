%new pertubuation function

function [wnew,CR]=pertub_matrix(P,s)
    [nx,ny]=size(P);
    DP=zeros(nx,ny); %perturbation ?P exei diastasi oso o pairwise comparison pinakas
    Pnew=ones(nx,ny); %arxikopoiisi me 1 afou stin diagonio exoyme 1
    for i=1:nx
      for j=i+1:ny %upper triangular array
       DP(i,j)=s*(rand-0.5); %genname diataraxes me auti tin entoli (me rand tixaia tha genniontai me misi timi 0) * s opoy einai to to pertubation_strength pou orizoume
       P(i,j)=P(i,j)*DP(i,j)+P(i,j); %Perturb the Pij elements - o P(i,j) o palios pairwise pinakas that allaxthei me tin eisagogi diataraxis sto stoixeio tou pinaka - isodinamo that itan kai to P(i,j)(i+DP(i,j);
       Pnew(i,j)=closeToValues(P(i,j)); %stin ousia pairnei san eisodo ton diataragmenpo pinaka kai kanei fit sta noumera tis 9-level scale - Pij perturbed fit to the closer integer or reciprocal of the nine level scale

    end

    %for i = 1:nx - gemizoume kai to kato trigoniko meros tou pinaka
      %for j=1:ny-1% lower triangular array
      for j = i + 1:ny %updated
        Pnew(j,i)=1/Pnew(i,j); %updated
        %Pnew(i,j)=1/Pnew(j,i);
      end
    end %of i

   %end
    [wnew,CR]=eigenMethodF2(Pnew);
endfunction