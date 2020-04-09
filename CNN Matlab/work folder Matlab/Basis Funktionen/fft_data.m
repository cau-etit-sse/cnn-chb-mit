function y=fft_data(data)

Fs=256;
fax_bins = [0:length(data)/2];
fax_Hz=fax_bins*Fs/(length(data));
X=abs(fft(data));
P2 = X/length(data);
% P1 = P2(1:length(data)/2+1),:);
P1 = P2(1:length(data)/2+1);
P1(2:end-1,:) = 2*P1(2:end-1,:); 

 plot(fax_Hz,10*log10(P1));
 xlabel('Frequency(Hz)');
 grid on 
 ylabel('Magnitude dB');
 y=P1;
 set(gca,'Xlim',[0 128]);
end 

% test=b(22,:);
% test=transpose(test);
% fft_data(test);