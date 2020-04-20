function eegseizure=read_seizure(patient)
for k=patient:patient
    
b=sprintf('chb%02d-summary.txt',k)
seizure.info=label_seizure(b);

for i=1:length(seizure.info(:,1))
a=sprintf('chb%02d_%02d.edf',k,seizure.info(i,1))
[z q]=edfread(a);
seizure.data(i).seizure_data=q(:,seizure.info(i,2)*256:seizure.info(i,3)*256);
end
eegseizure(k).patient=seizure;
clear seizure;
end 
end 


