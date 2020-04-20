function eegseizure=read_seizure(patient,preictal_time)
for k=patient:patient
% preictal_time=1800;   
preictal_samples=preictal_time*256;
b=sprintf('chb%02d-summary.txt',k)
seizure.info=label_seizure(b);
ueberspringen=0;
temp=1;
counter=1;

if patient==16
seizure.info(end-1:end,:)=[];
end 
if patient==19
    seizure.info(1,:)=[];
end 

if patient==20
    seizure.info(end,:)=[];
end 

if patient==22
    seizure.info(end,:)=[];
end 

if patient==10
    seizure.info(end,:)=[];
end 

if patient==15
    seizure.info((6:7),:)=[];
    seizure.info((7:9),:)=[];
     seizure.info((8),:)=[];
    seizure.info((9:13),:)=[];
    
end 

if patient==16
    seizure.info((end-4:end),:)=[];
end 

if patient==24
    seizure.info((5:7),:)=[];
end 


for i=1:length(seizure.info(:,1))
 if temp==seizure.info(i,1)
  i=i+1;
 else  
seizure.data(counter).seizure_data(1:23,1:preictal_samples)=NaN;
a=sprintf('chb%02d_%02d.edf',k,seizure.info(i,1))
if seizure.info(i,2)< preictal_time
    preictal=(preictal_time-seizure.info(i,2))*256;
    a=sprintf('chb%02d_%02d.edf',k,seizure.info(i,1)-1)   
    [z q]=edfread(a);
    q=clear_empty(q,patient);
    seizure.data(counter).seizure_data(:,1:preictal)=q(1:23,end-preictal+1:end);
    a=sprintf('chb%02d_%02d.edf',k,seizure.info(i,1))
    [z q]=edfread(a);
    q=clear_empty(q,patient);
    seizure.data(counter).seizure_data(:,preictal+1:end)=q(1:23,1:seizure.info(i,2)*256);
 else 
    [z q]=edfread(a);
    q=clear_empty(q,patient);
    seizure.data(counter).seizure_data(:,:)=q(1:23,seizure.info(i,2)*256-preictal_samples+1:seizure.info(i,2)*256);
 end 
     
counter=counter+1;
 end 
end
eegseizure(k).patient=seizure;
clear seizure;
end 
end 


