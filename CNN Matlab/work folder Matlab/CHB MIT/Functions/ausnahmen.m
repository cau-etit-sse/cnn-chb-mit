clear B temp2 temp k i 
 
function []=delete_channels(eegseizure, eeg_data, patient)
if (patient==11 || patient==14 || patient==15 || patient==16 || patient==18 || patient==19 || patient==20)
    % 14 & 15 & 18 & 19 jeweils erste file rausschmeißen ; 16 letzten beiden files
    % löschen 
loeschen=[5 10 13 18 23]
% loeschen=[5 10 14 19 24]
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
