clearvars -except eeg seizure, close all

% Select patient 
patient=1
%% Load Data
eegseizure=read_seizure(patient);
eeg_data=read_eeg(patient);
% Deleting unused and empty channels
[eegseizure eeg_data]=delete_channels(eegseizure, eeg_data, patient);
%% Define trainingset size
training_set=0.8;
testing_set=0.2;
eeg_size=floor(training_set*length(eeg_data(patient).patient.data));
seizure_size= floor(training_set*length(eegseizure(patient).patient.data));

%% Create 1sec window and conducting overlapping for seizure training data
[eeg seizure]=cut_window_training(patient,eegseizure,eeg_data,eeg_size, seizure_size);
[eeg_test seizure_test]= cut_window_testset(patient,eegseizure,eeg_data,eeg_size, seizure_size);
clearvars eeg_data eegseizure;

%% Arrange learning set 
training_size=length(seizure)+length(eeg)-1; 
validation_size= floor(0.2*training_size);
counter_e=1;
counter_s=1;
for i=1:training_size
    if counter_e <= length(eeg) & rem(i,2)==0;
    EEG_data(i).data= eeg(counter_e).window;
    EEG_data(i).label=0;
    counter_e = counter_e+1;
    end 
    if counter_s <= length(seizure) & rem(i,2)==1
    EEG_data(i).data=seizure(counter_s).window;       
    EEG_data(i).label=1;
    counter_s = counter_s+1; 
    end
    if counter_s > length(seizure) & rem(i,2)==1;
    EEG_data(i).data= eeg(counter_e).window;
    EEG_data(i).label=0;
    counter_e = counter_e+1; 
    end 
end
r=0;
 for i=1:training_size
       r=randi(training_size,1);
       EEG_data_arr(:,:,1,i)=EEG_data(r).data;
       Labels(i)=EEG_data(r).label;
 end 

%Arrange test set 
counter=1;
for i=1:length(eeg_test)
    EEG_data_test(counter).data= eeg_test(i).window;
    EEG_data_test(counter).label=0;
    if i <=length(seizure_test)
    counter=counter+1;
    EEG_data_test(counter).data=seizure_test(i).window;       
    EEG_data_test(counter).label=1;
    end 
    counter=counter+1;
end 
for i=1:length(EEG_data_test)
   EEG_data_arr_test(:,:,1,i)=EEG_data_test(i).data;
end 
%% Arrange Labels for Training and Testing 
Labels=vertcat(Labels);     
Labels_test=vertcat(EEG_data_test.label);  
Labels_test=categorical(Labels_test);
%% Select Training Data
XTrain = EEG_data_arr(:,:,1,1:training_size-validation_size);
YTrain= Labels(1:training_size-validation_size);
YTrain=categorical(YTrain);

%% Select Validation Data
XValidation = EEG_data_arr(:,:,1,training_size-validation_size+1:training_size);
YValidation = Labels(training_size-validation_size+1:training_size);
YValidation=categorical(YValidation);

%% CNN Architecture
layers = [

  imageInputLayer([23 256 1])
  convolution2dLayer([23 17],20,'stride',[1 1])
  reluLayer  
  maxPooling2dLayer([1 4],'Stride',[1 4])
  dropoutLayer(0.2)

  convolution2dLayer([1 5],10,'stride',[1 1])
  reluLayer
  maxPooling2dLayer([1 4],'Stride',[1 4])
  dropoutLayer(0.2)
  
  convolution2dLayer([1 5],10,'stride',1)
  reluLayer
  maxPooling2dLayer([1 2],'Stride',[1 2])

  convolution2dLayer([1 5],10,'stride',1)
  reluLayer
  dropoutLayer(0.2)

  fullyConnectedLayer(2)     
  softmaxLayer
  classificationLayer
  ];
% 
%% GAPuino optimized CNN
% layers = [
% 
%   imageInputLayer([23 256 1])
% %   batchNormalizationLayer
%   convolution2dLayer([5 5],10,'stride',[1 1])
%   reluLayer  
%   maxPooling2dLayer([2 2],'Stride',[2 2])
%   dropoutLayer(0.2)
%  
%  
% %  batchNormalizationLayer
%   convolution2dLayer([5 5],20,'stride',[1 1])
%   reluLayer
%   maxPooling2dLayer([2 2],'Stride',[2 2])
%   dropoutLayer(0.2)
%   fullyConnectedLayer(2)
%     softmaxLayer
%     classificationLayer];

%% Training Parameters of the CNN
miniBatchSize  = 32;
validationFrequency = floor(numel(YTrain)/miniBatchSize);
options = trainingOptions('adam', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',25, ...
    'InitialLearnRate',1e-3, ...
    'L2Regularization', 0.0001, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.1, ...
    'LearnRateDropPeriod',20, ...
    'Shuffle','once', ...
    'ValidationData',{XValidation,YValidation}, ...
    'ValidationFrequency',validationFrequency, ...
    'Plots','training-progress', ...
    'Verbose',false, 'ValidationPatience', 60);

%% Train network and store result in conv_net
 conv_net = trainNetwork(XTrain,YTrain,layers,options);
 
 %% Run classification with test set
 [result scores] = classify(conv_net,EEG_data_arr_test);
 %% Plot confusion matrix 
 plotconfusion(Labels_test,result)
 %% Plot ROC curve and AUC score
%  [xa ya T AUC Opt]=perfcurve(Labels_test,scores(:,2),1);
 %  Opt
%  figure
%  plot(xa,ya)
%  xlabel('False positive rate') 
% ylabel('True positive rate')
% title('ROC for Classification')
% hold on
% plot(Opt(1),Opt(2),'ro')
% xlabel('False positive rate') 
% ylabel('True positive rate')
% hold off
% threshold=T((xa==Opt(1))&(ya==Opt(2)))
 