function label_eeg= label_eeg(filename)
text_data=fopen(filename);
chb_data=textscan(text_data, '%s','delimiter','\t');
fclose(text_data);


seizure_start_line=strfind(chb_data{1,1},'seconds');
channel_number=strfind(chb_data{1,1},'File Name:');

%% Find Index
 index_file_all=find(not(cellfun('isempty',channel_number)));
 index = find(not(cellfun('isempty',seizure_start_line)));
counter=1;
counter2=1;
for i=1:length(index)
    if rem(i,2)
    index_on(counter)=index(i);
    counter=counter+1;
    else
index_off(counter2) = index(i);
counter2=counter2+1;
    end 
end


%% Dateinummer für Seizure
for i=1:length(index_on)
    for k=1:length(index_file_all)   
    if (index_on(i)>index_file_all(k))&&(k==length(index_file_all))
       index_file(i:length(index_on))=index_file_all(k);
       del(i)=k;
      break;
    end  
   
   if (index_on(i)>index_file_all(k))&&(index_on(i)<index_file_all(k+1))
       index_file(i)=index_file_all(k);
       del(i)=k;
   end 
    end 
end 
del=unique(del);
for i=length(del):-1:1                                                       %% Löschen der Dateien mit Seizure
    index_file_all(del(i),:)=[];
end 
for k=1:length(index_file_all)
temp=str2num(regexprep(chb_data{1,1}{index_file_all(k)}, '\D+', ' '));
label_eeg(k,1)=temp(2);
end 

