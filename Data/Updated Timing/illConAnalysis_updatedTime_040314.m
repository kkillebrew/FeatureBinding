 % Important lists
% rawdata(:,1) = amount of time before the cue
% rawdata(:,2) = cue no cue
% rawdata(:,3) = index of letterPosition list which tells which
%   letter/position/color will be cued
% rawdata(:,4) = numbers correct?
% rawdata(:,5) = letter correct?
% rawdata(:,6) = color correct?
% rawdata(:,7) = confidence rating 1-5
% numVal = 2xnumTrials list of the actual numbers choosen
% numResponse = indexes for numResponseChoice list indicating what number
%   they actually chose
% numResponseChoice = 4xnumTrials cell array of the number choices for each
%   trial
% letterPosition = 3xnumTrials list of indexes for letters in the order they
%   appeared (1=left 2=middle 3=right)
% letResponse = list of the letters they actually choose
% colorPosition = 3xnumTrials list of indexes for colors in the order they
%   appeared (1=left 2=middle 3=right)
% colResponse = list of the colors they actually choose
% colors = cell array of the colors used
% letters = cell array of the letters used
% numAcc = list of accuracies per 10 trials

clear all
close all

lineColor{1}='r';
lineColor{2}='b';
xLabels = {'Cue','No Cue'};

% fileList = {'riley_test_orientation_040314_001.mat'};
% fileList = {'MLK_orientation_040714_001.mat','riley_test_orientation_040314_001.mat','DBD_orientation_040714_001.mat','CDB_orientation_040714_001'};
fileList = {'002_retroCue_041714_001','003_retroCue_041714_001','004_retroCue_041714_001'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Feature Binding/Data/Updated Timing/';

    numAcc = [];
    letAcc = [];
    colAcc = [];

for p=1:length(fileList)
    load(sprintf('%s%s',inputFile,fileList{p}));
   
    % Overall Accuracy
    % Accuracy of the numbers
    numAcc(p) = mean(rawdata(:,4)) * 100;
    % Accuracy of the letters
    letAcc(p) = mean(rawdata(:,5)) * 100;
    % Accuracy of the colors
    colAcc(p) = mean(rawdata(:,6)) * 100;
    
    % Accuracy for retro cue vs no retro cue
    letAccCue(p) = mean(rawdata((rawdata(:,2)==1),5)) * 100;
    letAccNoCue(p) = mean(rawdata((rawdata(:,2)==0),5)) * 100;
    
    colAccCue(p) = mean(rawdata((rawdata(:,2)==1),6)) * 100;
    colAccNoCue(p) = mean(rawdata((rawdata(:,2)==0),6)) * 100;
    
    % Did they get both letter and color correct
    conjunctionAccCue(p) = mean(and(rawdata(rawdata(:,2)==1,5),rawdata(rawdata(:,2)==1,6)))*100;
    conjunctionAccNoCue(p) = mean(and(rawdata(rawdata(:,2)==0,5),rawdata(rawdata(:,2)==0,6)))*100;
    
    % Accuracy for 600 ms post cue duration
    conjunctionAccCue6(p) = mean(rawdata((rawdata(rawdata(:,1)==1,2)==1),5) & rawdata((rawdata(rawdata(:,1)==1,2)==1),6))*100;
    conjunctionAccNoCue6(p) =  mean(rawdata((rawdata(rawdata(:,1)==1,2)==0),5) & rawdata((rawdata(rawdata(:,1)==1,2)==0),6))*100;
    
    % Accuracy for 700 ms post cue duration
    conjunctionAccCue7(p) = mean(and(rawdata((rawdata(rawdata(:,1)==2,2)==1),5),rawdata((rawdata(rawdata(:,1)==2,2)==1),6)))*100;
    conjunctionAccNoCue7(p) = mean(and(rawdata((rawdata(rawdata(:,1)==2,2)==0),5),rawdata((rawdata(rawdata(:,1)==2,2)==0),6)))*100;
    
    % Making error lists - feature errors, conjunction errors, and pure errors
    
    % Was is a "feature error" or an "illusory conjunction"
    % Only analyze the "error trials"
    
    figure()
    % Plotting the number accuracy
   subplot(2,3,1)
    bar(numAcc(p))
    %     hold on
        set(gca,'ylim',[0,100]);
    %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
    str = {'',sprintf('Number Accuracy for Participant %d',p),''}; % cell-array method
    title(str,'FontSize',15,'FontWeight','bold')
    xlabel('Numbers','FontSize',15);
    ylabel('Accuracy (%)','FontSize',15);
    
    % Plotting the letter accuracy for cue and no cue
    subplot(2,3,2)
    bar([letAccCue(p) letAccNoCue(p)])
    %     hold on
        set(gca,'ylim',[0,100],'XTickLabel',xLabels, 'XTick',1:numel(xLabels));
    %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
    str = {'',sprintf('Letter Accuracy for Participant %d',p),''}; % cell-array method
    title(str,'FontSize',15,'FontWeight','bold')
    xlabel('Letters','FontSize',15);
    ylabel('Accuracy (%)','FontSize',15);
    
    % Plotting the color accuracy for cue and no cue
    subplot(2,3,3)
    bar([colAccCue(p) colAccNoCue(p)])
    %     hold on
        set(gca,'ylim',[0,100],'XTickLabel',xLabels, 'XTick',1:numel(xLabels));
    %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
    str = {'',sprintf('Color Accuracy for Participant %d',p),''}; % cell-array method
    title(str,'FontSize',15,'FontWeight','bold')
    xlabel('Colors','FontSize',15);
    ylabel('Accuracy (%)','FontSize',15);
    
    subplot(2,3,4)
    bar([conjunctionAccCue(p) conjunctionAccNoCue(p)])
    %     hold on
    set(gca,'ylim',[0,100],'XTickLabel',xLabels, 'XTick',1:numel(xLabels));
    %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
    str = {'',sprintf('Conjunction Accuracy for Participant %d',p),''}; % cell-array method
    title(str,'FontSize',15,'FontWeight','bold')
    xlabel('Conjunction','FontSize',15);
    ylabel('Accuracy (%)','FontSize',15);
    
    subplot(2,3,5)
    h=bar([conjunctionAccCue6(p),conjunctionAccNoCue6(p); conjunctionAccCue7(p), conjunctionAccNoCue7(p)]);
    set(gca,'ylim',[0,100],'XTickLabel',['600ms Cue','600ms No Cue';'700ms Cue','700ms No Cue'], 'XTick',1:numel(xLabels));
    %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
    set(h,'BarWidth',1);    % The bars will now touch each other
    str = {'',sprintf('Conjunction Accuracy for Varied Post Retro Cue Time for Participant %d',p),''}; % cell-array method
    title(str,'FontSize',15,'FontWeight','bold')
    xlabel('Conjunction','FontSize',15);
    ylabel('Accuracy (%)','FontSize',15);
end

figure()
% Plotting the averages
% Plotting the number accuracy
subplot(2,3,1)
bar(mean(numAcc(:)))
hold on
errorbar(mean(numAcc(:)),(std(numAcc(:)))/sqrt(length(fileList)),'k.','LineWidth',2)
set(gca,'ylim',[0,100]);
str = {'',sprintf('Number Accuracy for Participant %d',p),''}; % cell-array method
title(str,'FontSize',15,'FontWeight','bold')
xlabel('Numbers','FontSize',15);
ylabel('Accuracy (%)','FontSize',15);

% Plotting the letter accuracy for cue and no cue
subplot(2,3,2)
bar([mean(letAccCue(:)) mean(letAccNoCue(:))])
hold on
errorbar([mean(letAccCue(:)), mean(letAccNoCue(:))], [(std(letAccCue(:)))/sqrt(length(fileList)), (std(letAccNoCue(:)))/sqrt(length(fileList))],'k.','LineWidth',2)
set(gca,'ylim',[0,100],'XTickLabel',xLabels, 'XTick',1:numel(xLabels));
str = {'',sprintf('Letter Accuracy for Participant %d',p),''}; % cell-array method
title(str,'FontSize',15,'FontWeight','bold')
xlabel('Letters','FontSize',15);
ylabel('Accuracy (%)','FontSize',15);

% Plotting the color accuracy for cue and no cue
subplot(2,3,3)
bar([mean(colAccCue(:)) mean(colAccNoCue(:))])
hold on
errorbar([mean(colAccCue(:)), mean(colAccNoCue(:))], [(std(colAccCue(:)))/sqrt(length(fileList)), (std(colAccNoCue(:)))/sqrt(length(fileList)),],'k.','LineWidth',2)
set(gca,'ylim',[0,100],'XTickLabel',xLabels, 'XTick',1:numel(xLabels));
str = {'',sprintf('Color Accuracy for Participant %d',p),''}; % cell-array method
title(str,'FontSize',15,'FontWeight','bold')
xlabel('Colors','FontSize',15);
ylabel('Accuracy (%)','FontSize',15);

% Plotting the conjunction accuracy for cue and no cue
subplot(2,3,4)
bar([mean(conjunctionAccCue(:)) mean(conjunctionAccNoCue(:))])
hold on
errorbar([mean(conjunctionAccCue(:)), mean(conjunctionAccNoCue(:))], [(std(conjunctionAccCue(:)))/sqrt(length(fileList)),...
    (std(conjunctionAccNoCue(:))/sqrt(length(fileList)))],'k.','LineWidth',2)
set(gca,'ylim',[0,100],'XTickLabel',xLabels, 'XTick',1:numel(xLabels));
str = {'',sprintf('Conjunction Accuracy for Participant %d',p),''}; % cell-array method
title(str,'FontSize',15,'FontWeight','bold')
xlabel('Conjunction','FontSize',15);
ylabel('Accuracy (%)','FontSize',15);

subplot(2,3,5)
c=[mean(conjunctionAccCue6),mean(conjunctionAccNoCue6); mean(conjunctionAccCue7), mean(conjunctionAccNoCue7)];
b=[(std(conjunctionAccCue6))/sqrt(length(fileList)),(std(conjunctionAccNoCue6))/sqrt(length(fileList)); ...
    (std(conjunctionAccCue7))/sqrt(length(fileList)), (std(conjunctionAccNoCue7))/sqrt(length(fileList))];
h=bar(c);
hold on

% Code from barweb.m to align the error bars with the bar groups
set(h,'BarWidth',1);    % The bars will now touch each other
set(gca,'XTicklabel','Modelo1|Modelo2|Modelo3')
set(get(gca,'YLabel'),'String','U')
hold on;
numgroups = size(c, 1); 
numbars = size(c, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, c(:,i), b(:,i), '.k', 'linewidth', 2);
end
%%%%%%%%
set(gca,'ylim',[0,100],'XTickLabel',['600ms Cue','600ms No Cue';'700ms Cue','700ms No Cue'], 'XTick',1:numel(xLabels));
str = {'',sprintf('Conjunction Accuracy for Varied Post Retro Cue Time for Participant %d',p),''}; % cell-array method
title(str,'FontSize',15,'FontWeight','bold')
xlabel('Conjunction','FontSize',15);
ylabel('Accuracy (%)','FontSize',15);







