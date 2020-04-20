%% Fensterung der Seizure Abschnitte in 1sek + FFT


counter=1;
for i=1:length(eegseizure)
    for k=1:length(eegseizure(i).patient.data)
        for w=1:floor(length(eegseizure(i).patient.data(k).seizure_data)/256)
            for p=1:16 %% anzahl benutzter Channel für Window
seizure(counter).window(p,:)=abs(fft(eegseizure(i).patient.data(k).seizure_data(p,(w*256-255):(w*256))));
            end 
counter=counter+1;
        end 
    end 
end 

%% EEG Daten 100 Sekunden vor und 100 Sekunden nach Seizure + FFT + Fenstern der Daten mit der Länge 1 sek
counter=1;
for i=1:length(eegseizure)
    for k=1:length(eegseizure(i).patient.data)
        sprintf('chb%02d_%02d.edf',i,eegseizure(i).patient.info(k,1))
        [a b]=edfread(sprintf('chb%02d_%02d.edf',i,eegseizure(i).patient.info(k,1)));
        alpha = eegseizure(i).patient.info(k,2);
        omega = eegseizure(i).patient.info(k,3);
        if alpha>100
            alpha_a=alpha-100;
        else
            alpha_a=1;
        end 
            
        if omega+100>length(b)/256
            omega_e=length(b)/256;
        else
            omega_e=omega+100;
        end 
            
       
        for w=alpha_a:alpha
             for p=1:16 %% anzahl benutzter Channel für Window
            eeg(counter).window(p,:)=abs(fft(b(p,(w*256-255):(w*256)))); 
             end 
            counter=counter+1;
        end 
        for w=omega:omega_e
             for p=1:16 %% anzahl benutzter Channel für Window
            eeg(counter).window(p,:)= abs(fft(b(p,(w*256-255):(w*256))));
             end 
            counter=counter+1;
        end
        
    end 
end 

   
