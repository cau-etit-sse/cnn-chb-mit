clearvars -except conv_net, close all

%% Einlesen EDF file und Seizure On/Offset 
p=1;                                                                        % Patienten Nummer
n=18;                                                                       % edf file           
file=sprintf('chb%02d_%02d.edf',p,n);
summary=sprintf('chb%02d-summary.txt',p);
[a b]=edfread(file);
seizure_label=label_seizure(summary);

%% Fensterung Daten für CNN
c=b;
for i=1:length(c)/256 - 1
     validation(i).data=c(1:23,i*256-255:i*256);
end 

%% Classification Daten 

for i=1:length(validation)
    [comp(i) scores(i,:)]=classify(conv_net,validation(i).data);
end 

%% Erstellen Soll/Ist Vektor 
soll(1:length(comp))=0;
for i=1:length(seizure_label)
    if n==seizure_label(i,1)
        soll(seizure_label(i,2):seizure_label(i,3))=1;
    end 
end
comp2=double(comp);
soll2(1:length(soll))=0;
for i=1:length(comp2);
    if soll(i)==1
        soll2(i)=max(b(1,:))+2;
    end 
    if comp2(i)==1;
        comp2(i)=0;
    else 
        comp2(i)=max(b(1,:))+2;
    end 
end 
comp2=kron(comp2, ones(1,256));
soll2=kron(soll2, ones(1,256));
scores2=kron(transpose(scores(:,2)), ones(1,256));
temp=soll;
soll=categorical(soll);
%% Plotten Soll/Ist über einen Channel des EEG Signals

figure
    plot(b(1,1:length(comp2)),'color',[.5 .5 .5])                                             % Hier Channel ändern der geplottet werden soll
    hold on 
%      plot(comp2,'g','linewidth',2)
     plot(scores2*1000,'b','linewidth',2)
     plot(soll2,'--r','linewidth',2)
     legend('EEG-Data','Result','Target')
     xlabel('Record Number')
     ylabel('Amplitude in uV')
    figure
    plotconfusion(soll,comp)
    
    
%     figure
%     subplot(4,1,1)
%     plot(validation(100).data(1,:))
%     ylabel('Channel 1')
%     subplot(4,1,2)
%     plot(validation(101).data(2,:))
%     ylabel('Channel 2')
%     subplot(4,1,3)
%     plot(validation(102).data(3,:))
%     ylabel('Channel 3')
%     subplot(4,1,4)
%     plot(validation(102).data(5,:))
%     ylabel('Channel 4')
%     xlabel('Measurement points')
%   
% [xa ya T AUC Opt]=perfcurve(soll,scores(:,2),1);
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
% 
% 
% for i=1:length(scores(:,2))
%     comp_double(i)=double(comp(i))-1;
%     soll_double(i) =double(soll(i))-1;
%     if scores(i,2)>=0.7841
%         label(i)=1;
%     else 
%         label(i)=0;
%     end 
% end 
% comp_double(i)=transpose(comp_double(i));
% soll_double(i)=transpose(soll_double(i));
% plot(label,'linewidth',2)
% hold on
% plot(comp_double,'r')
% hold on
% plot(soll_double,'--g')


%% Plotten ergbniss mit eeg signal
% anfang = 476150
% ende = 502640
%  anfang = 460000
%  ende = 550000
 anfang = 400000
 ende = 465920
fax_bins = [1:length(comp2)];
fax_Hz=fax_bins*length(comp)/(length(comp2));
yyaxis left
 plot(fax_Hz(anfang:ende),b(1,anfang:ende),'color',[.5 .5 .5],'linewidth',1.5)
 ylabel('Amplitude in $\mu$V','Interpreter','latex')
 set(gca,'YColor','k')
 set(gca,'FontSize',24);
 ylim(gca,[-600 600]);
 yyaxis right
 plot(fax_Hz(anfang:ende), scores2(anfang:ende),'b','linewidth',2)
  xlabel('Time in seconds','Interpreter','latex')
  ylabel('Probability in \%','Interpreter','latex')
  ax=gca;
  set(gca,'YColor','b')
  set(gca,'FontSize',24);
  ylim(ax,[-1.2 1.2]);
  set(gca,'XLim',[fax_Hz(anfang) fax_Hz(ende)])
  hold on 
  plot(fax_Hz(anfang:ende),soll2(anfang:ende)/952.4,'--r','linewidth',2)
   legend('EEG-Data','Result','Target')
   grid on 

%  plot(fax_Hz,b(1,1:length(comp2)))
%  plotyy(fax_Hz,b(1,1:length(comp2)),fax_Hz, scores2) 
 
 %% Plotten gesamtes eeg signal



%% subplots für CHannel 1 5 10 20
%  fax_bins = [1:length(comp2)];
% fax_Hz=fax_bins*length(comp)/(length(comp2));
% 
% subplot(4,1,1)
%  plot(fax_Hz,b(1,1:length(comp2)),'color',[.5 .5 .5])
%  ylabel('Amplitude in $\mu$V','Interpreter','latex')
%  set(gca,'YColor','k')
%  set(gca,'FontSize',24);
%  set(gca,'Xlim',[0 fax_Hz(end)])
%   hold on 
%   plot(fax_Hz(anfang:ende),soll2(anfang:ende),'--r','linewidth',2)
%  
%  subplot(4,1,2)
%  plot(fax_Hz,b(5,1:length(comp2)),'color',[.5 .5 .5])
%  ylabel('Amplitude in $\mu$V','Interpreter','latex')
%  set(gca,'YColor','k')
%  set(gca,'FontSize',24);
%  set(gca,'Xlim',[0 fax_Hz(end)])
%   hold on 
%   plot(fax_Hz(anfang:ende),soll2(anfang:ende),'--r','linewidth',2)
%  
%  subplot(4,1,3)
%  plot(fax_Hz,b(10,1:length(comp2)),'color',[.5 .5 .5])
%  ylabel('Amplitude in $\mu$V','Interpreter','latex')
%  set(gca,'YColor','k')
%  set(gca,'FontSize',24);
%  set(gca,'Xlim',[0 fax_Hz(end)])
%   hold on 
%   plot(fax_Hz(anfang:ende),soll2(anfang:ende),'--r','linewidth',2)
%   
%    subplot(4,1,4)
%  plot(fax_Hz,b(20,1:length(comp2)),'color',[.5 .5 .5])
%  ylabel('Amplitude in $\mu$V','Interpreter','latex')
%  set(gca,'YColor','k')
%  set(gca,'FontSize',24);
%  set(gca,'Xlim',[0 fax_Hz(end)])
%  xlabel('Time in seconds','Interpreter','latex')
%   hold on 
%   plot(fax_Hz(anfang:ende),soll2(anfang:ende),'--r','linewidth',2)

