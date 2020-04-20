function seizure_label= label_seizure(filename)
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
%% Error message
assert(length(index_on)==length(index_off), ['Missmatch in seizure On- and Offset']);
%% Detect on and offset
for i=1:length(index_on)
    num_on=str2num(regexprep(chb_data{1,1}{index_on(i)}, '\D+', ' '));
    num_off=str2num(regexprep(chb_data{1,1}{index_off(i)}, '\D+', ' '));
    if length(num_on)>1
        seizure_label(i,2)=num_on(2);
        seizure_label(i,3)=num_off(2);
    else 
         seizure_label(i,2)=num_on;
        seizure_label(i,3)=num_off;
    end 
    clear num_on; clear num_off

end 

%% Dateinummer für Seizure
for i=1:length(index_on)
    for k=1:length(index_file_all)   
    if (index_on(i)>index_file_all(k))&&(k==length(index_file_all))
       index_file(i:length(index_on))=index_file_all(k);
      break;
    end  
   
   if (index_on(i)>index_file_all(k))&&(index_on(i)<index_file_all(k+1))
       index_file(i)=index_file_all(k);
   end 
    end 
end 
    

for i=1:length(index_file)
    temp=str2num(regexprep(chb_data{1,1}{index_file(i)}, '\D+', ' '));
    seizure_label(i,1)=temp(2);
    
end 


 end 
    

    
