c=[2,6,10,14,17];

for i=1:5
    test=max(abs(conv_net.Layers(c(i),1).Weights),[],4);
    test=max(test);
    test=max(test);
    a(i)=test;
end

maximum=max(a);

n1=floor(log2(4*maximum/3));
n2=n1+1-2^(5-1)/2; 

