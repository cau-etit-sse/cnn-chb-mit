%% Fensterung der Seizure Abschnitte in 1sek 
function [eeg seizure]=cut_window(patient,eegseizure,eeg_data)
counter=1;
%% Ictal sequences with a new window every sample
for i=patient:patient
     for k=1:length(eegseizure(i).patient.data)-1
% length(eegseizure(i).patient.data)
        for w=1:1:length(eegseizure(i).patient.data(k).seizure_data)-256     
seizure(counter).window=eegseizure(i).patient.data(k).seizure_data(:,(w):(w+255));
counter=counter+1;
        end 

     end 
end 
%% Interictal with a new window every 256samples (1sek)
counter=1;
for i=patient:patient
    for k=1:length(eeg_data(i).patient.data)-6
        for w=1:floor(length(eeg_data(i).patient.data(k).eeg_data)/256 -1)
            eeg(counter).window=eeg_data(i).patient.data(k).eeg_data(:,(w*256-255):(w*256)); 
            counter=counter+1;
        end 
    end 
end 

end 
   
