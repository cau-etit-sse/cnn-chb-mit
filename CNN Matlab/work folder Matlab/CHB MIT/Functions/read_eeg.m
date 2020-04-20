function eeg_data=read_eeg(patient)
for k=patient:patient
    
b=sprintf('chb%02d-summary.txt',k)
eeg.info=label_eeg(b);

for i=1:length(eeg.info(:,1))
a=sprintf('chb%02d_%02d.edf',k,eeg.info(i,1))
[z q]=edfread(a);
eeg.data(i).eeg_data=q(:,:);
end
eeg_data(k).patient=eeg;
clear eeg;
end 
end 


