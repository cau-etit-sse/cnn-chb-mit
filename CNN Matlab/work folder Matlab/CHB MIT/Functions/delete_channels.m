function [eegseizure eeg_data]=delete_channels(eegseizure, eeg_data, patient)
if (patient==11 || patient==14 || patient==15 || patient==16 || patient==18 || patient==19 || patient==20 || patient==21 || patient==22)
if patient==11 || patient==15 || patient==18 || patient==19
eeg_data(patient).patient.data(1)=[];
end 

if patient==16
eeg_data(patient).patient.data(end)=[];
eegseizure(patient).patient.data(end-1:end)=[];
end 

if patient==11 || patient==15
    loeschen=[5 10 14 19 24]
else 
    loeschen=[5 10 13 18 23]
end 
starting_file_eeg=1;
starting_file_seizure=1; 
% patient=11;
% eegseizure(patient).patient.data()=[];
for i=starting_file_seizure:length(eegseizure(patient).patient.data) 
%     length(eeg_data(patient).patient.data)
    for k=length(loeschen):-1:1
eegseizure(patient).patient.data(i).seizure_data(loeschen(k),:)=[];
    end 
%     eeg_data(patient).patient.data(i).eeg_data(24:end,:)=[];
end 

for i=starting_file_eeg:length(eeg_data(patient).patient.data)
    for k=length(loeschen):-1:1
eeg_data(patient).patient.data(i).eeg_data(loeschen(k),:)=[];
    end 
%     eeg_data(patient).patient.data(i).eeg_data(24:end,:)=[];
end 
end 
end 
