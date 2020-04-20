clearvars -except rat_data class
rat_data=squeeze(rat_data);
%% Define trainingset size
training_set=0.8;
validation_set=0.2;
testing_set=0.2;
testing_size=testing_set*length(rat_data);
training_size=training_set*length(rat_data);
validation_size=validation_set*length(rat_data);


%% Select Training Data
for i=1:training_size-validation_size
    XTrain(:,:,1,i)=rat_data(i,:);
end 
YTrain= class(1:training_size-validation_size);
YTrain=categorical(YTrain);

%% Select Validation Data
counter=1;
for i=training_size-validation_size+1:training_size
    XValidation(1,:,1,counter)=rat_data(i,:);
    counter=counter+1;
end 
YValidation = class(training_size-validation_size+1:training_size);
YValidation=categorical(YValidation);
%%  Test set
counter=1;
for i=training_size+1:length(rat_data) 
    XTesting(1,:,1,counter)=rat_data(i,:);
    counter=counter+1;
end 
YTesting = class(training_size+1:end);
YTesting=categorical(YTesting);

%% CNN Architecture
layers = [

  imageInputLayer([1 1600 1])
  convolution2dLayer([1 50],20,'stride',[1 1])
  reluLayer  
  maxPooling2dLayer([1 5],'Stride',[1 5])
  dropoutLayer(0.2)
  
  convolution2dLayer([1 20],10,'stride',[1 1])
  reluLayer
  maxPooling2dLayer([1 5],'Stride',[1 5])
  dropoutLayer(0.2)
  
%   convolution2dLayer([1 20],10,'stride',1)
%   reluLayer
%   maxPooling2dLayer([1 10],'Stride',[1 4])

  convolution2dLayer([1 20],10,'stride',1)
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
 [result scores] = classify(conv_net,XTesting);
 %% Plot confusion matrix 
 plotconfusion(YTesting,transpose(result))
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
 