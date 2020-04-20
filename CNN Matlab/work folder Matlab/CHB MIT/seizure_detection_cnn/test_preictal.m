% clearvars -except conv_net
patient=24
preictal_time=1800;
preictal=read_preictal(patient,preictal_time);
%%
% eegseizure(patient)=preictal(patient);
% 
% loeschen=[5 10 13 18 23]
% % loeschen=[5 10 14 19 24]
% starting_file_eeg=1;
% starting_file_seizure=1;
% % patient=11;
% % eegseizure(patient).patient.data()=[];
% for i=starting_file_seizure:length(eegseizure(patient).patient.data) 
% %     length(eeg_data(patient).patient.data)
%     for k=length(loeschen):-1:1
% eegseizure(patient).patient.data(i).seizure_data(loeschen(k),:)=[];
%     end 
% %     eeg_data(patient).patient.data(i).eeg_data(24:end,:)=[];
% end
% preictal(patient)=eegseizure(patient);
% clearvars eegseizure
%% 
%% Fensterung Daten für CNN
preictal_time=[1 600 1200 1500]
for v=1:length(preictal_time)
    
sprintf('Classifying for a preictal time period of %i seconds',1800-preictal_time(v))
for z=1:length(preictal(patient).patient.data)
b=preictal(patient).patient.data(z).seizure_data;
c=preictal(patient).patient.data(z).seizure_data;
counter=1;
for i=preictal_time(v):length(c)/256 - 1
     validation(counter).data=c(1:23,i*256-255:i*256);
     counter=counter+1;
end 

% Classification Daten 
for i=1:length(validation)
    [comp(i) scores(i,:)]=classify(conv_net,validation(i).data);
end 

% Erstellen Soll/Ist Vektor 
fph(z)= (sum(double(comp))-length(comp))/(length(comp)/3600);
fp(z)= sum(double(comp))-length(comp);
l(z)=length(comp);
end 
validation=[];
comp=[];
%  clearvars -except fph fp l conv_net preictal patient v preictal_time 
fph_all(v)=sum(fph)/length(fph)
end
% fph_all_alternative= sum(fp)/(sum(l)/3600)