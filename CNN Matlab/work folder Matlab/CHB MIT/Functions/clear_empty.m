function q=clear_empty(q,patient)
if (patient==11 || patient==14 || patient==15 || patient==16 || patient==18 || patient==19 || patient==20 || patient==21 || patient==22)
if patient==11 || patient==15
    loeschen=[5 10 14 19 24]
else 
    loeschen=[5 10 13 18 23]
end 

for k=length(loeschen):-1:1
q(loeschen(k),:)=[];
end 
end 
end 

