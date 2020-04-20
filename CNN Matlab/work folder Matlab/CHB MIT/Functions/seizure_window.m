%% Fensterung der Seizure Abschnitte in 1sek + FFT
counter=1;
for i=3:3
     for k=1:6 
% length(eegseizure(i).patient.data)
        for w=1:length(eegseizure(i).patient.data(k).seizure_data)-256      
seizure(counter).window=eegseizure(i).patient.data(k).seizure_data(:,(w):(w+255));
counter=counter+1;
        end 

     end 
end 
counter=1;
for i=3:3 
    for k=1:length(eeg_data(i).patient.data)
        for w=1:floor(length(eeg_data(1).patient.data(1).eeg_data)/256 -1)
            eeg(counter).window=eeg_data(i).patient.data(k).eeg_data(:,(w*256-255):(w*256)); 
            counter=counter+1;
        end 
    end 
end 

%% EEG Daten 100 Sekunden vor und 100 Sekunden nach Seizure + FFT + Fenstern der Daten mit der Länge 1 sek
% counter=1;
% for i=1:length(eegseizure)
%     for k=1:length(eegseizure(i).patient.data)
%         sprintf('chb%02d_%02d.edf',i,eegseizure(i).patient.info(k,1))
%         [a b]=edfread(sprintf('chb%02d_%02d.edf',i,eegseizure(i).patient.info(k,1)));
%         alpha = eegseizure(i).patient.info(k,2);
%         omega = eegseizure(i).patient.info(k,3);
%         if alpha>1000
%             alpha_a=alpha-1000;
%         else
%             alpha_a=1;
%         end 
%             
%         if omega+1000>length(b)/256
%             omega_e=length(b)/256;
%         else
%             omega_e=omega+1000;
%         end 
%             
%        
%         for w=alpha_a:(alpha-alpha_a)/2
%             eeg(counter).window=b(1:16,(w*256-255):(w*256)); 
%             counter=counter+1;
%         end 
%         for w=omega+(omega_e-omega)/2:omega_e
%             eeg(counter).window=b((1:16),(w*256-255):(w*256)); 
%             counter=counter+1;
%         end
%         
%     end 
% end 

   
