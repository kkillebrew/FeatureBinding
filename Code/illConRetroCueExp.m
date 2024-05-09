% Illusory Conjunction experiment

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
% stimPresTime = list of stimulus presentation times calculated every ten
%    trials

close all;
clear all;

screenNum = 1;

% Sets the inputs to come in from the other computer
[nums, names] = GetKeyboardIndices;
dev_ID=nums(2);
con_ID=nums(1); 

pathOut = '/Volumes/C-Lab/Google Drive/Lab Projects/Feature Binding/Data/';
% pathOut = '/Users/C-Lab/Google Drive/Lab Projects/Feature Binding/Data/';

c = clock;
time_stamp = sprintf('%02d/%02d/%04d %02d:%02d:%02.0f',c(2),c(3),c(1),c(4),c(5),c(6)); % month/day/year hour:min:sec
datecode = datestr(now,'mmddyy');
experiment = 'orientation';

% get input
subjid = input('Enter Subject Code:','s');
runid  = input('Enter Run:');

datafile=sprintf('%s_%s_%s_%03d',subjid,experiment,datecode,runid);
datafile_full=sprintf('%s_full',datafile);

% check to see if this file exists
if exist(fullfile(pathOut,[datafile '.mat']),'file')
    tmpfile = input('File exists.  Overwrite? y/n:','s');
    while ~ismember(tmpfile,{'n' 'y'})
        tmpfile = input('Invalid choice. File exists.  Overwrite? y/n:','s');
    end
    if strcmp(tmpfile,'n')
        display('Bye-bye...');
        return; % will need to start over for new input
    end
end

load('PreallocateNoise');

totalTime=GetSecs;

% Treisman had 10 letter combos and 10 color combos (5 choose 3) and 40 total choosen
% letter/color combos.

% Five different combinations of 4 letters out of 5 colors and letters
% letterList ={{'Q' 'W' 'E' 'R'} {'W' 'E' 'R' 'T'} {'Q' 'W' 'E' 'T'} {'Q' 'E' 'T' 'R'} {'Q' 'W' 'T' 'R'}};
letList = {'T' 'S' 'N' 'P' 'X'};
letters = {'T' 'S' 'N' 'P' 'X'};
letterList = [1 2 3 4 5];
% bl = [0 0 256];   % 1
% gr = [0 256 0];   % 2
% ye = [256 256 0]; % 3
% ma = [256 0 256]; % 4
% re = [256 0 0];   % 5

colors = {'b' 'g' 'y' 'm' 'r'};
colorList = [1 2 3 4 5];

nLetter = length(letterList);
nColor = length(colorList);
preCueIntervalList = [.6 .7];     % in seconds
nCueTime = length(preCueIntervalList);
cuePresentList = [1 0];
nCuePresent = length(cuePresentList);
nTrials = 50;

numResonse = [];
letResponse = [];
colResponse = [];

featureErrorLet = [];
misbindingErrorLet = [];
errorTotalLet = 1;
misbindingTotalLet = 1;
featureErrorCol = [];
misbindingErrorCol = [];
errorTotalCol = 1;
misbindingTotalCol = 1;

letAcc = [];
nLetAcc = 1;
colAcc = [];
nColAcc = 1;
numAcc = [];
nNumAcc = 1;

numSize = 60;
letSize = 60;

variableList = repmat(fullyfact([nCueTime nCuePresent]),[nTrials,1]);
trialOrder=randperm(length(variableList));
numTrials = length(trialOrder);

for n=1:numTrials
    letterPosition(n,:) = randi(5,[1,3]);
    colorPosition(n,:) = randi(5,[1,3]);
    while letterPosition(n,1) == letterPosition(n,2) || letterPosition(n,2) == letterPosition(n,3) || letterPosition(n,1) == letterPosition(n,3)
        letterPosition(n,:) = randi(5,[1,3]);
    end
    while colorPosition(n,1) == colorPosition(n,2) || colorPosition(n,2) == colorPosition(n,3) || colorPosition(n,1) == colorPosition(n,3)
        colorPosition(n,:) = randi(5,[1,3]);
    end
end

% break_trials = .25:.25:.75; % list of proportion of total trials at which to offer subject a self-timed break
break_trials = .1:.1:.9;    % list of proportion of total trials at which to offer subject a self-timed break
acc_checks = 10:10:numTrials;

stimPresTime = zeros(1,length(acc_checks));
stimPresTime(1) = .2;
stimPresCount = 1;


rawdata = [];
% letterOrder = [];
% colorOrder = [];
numVal = [];
numAnswer = [];
letAnswer = [];
cueLength = 20;
countDisp = 0;
disptime = [];

mon_width_cm = 40;
mon_dist_cm = 73;
mon_width_deg = 2 * (180/pi) * atan((mon_width_cm/2)/mon_dist_cm);
PPD = (1024/mon_width_deg);

ListenChar(2);
HideCursor;
backColor = 128;
numColor = 0;
textColor = [256, 256, 256];

rect=[0 0 1024 768];     % test comps
[w,rect]=Screen('OpenWindow', screenNum,[backColor backColor backColor],rect);
x0 = rect(3)/2;% screen center
y0 = rect(4)/2;

% Setting location for letters
xCoordCountLet = 70;
yCoordCountLet = 70;
% for j=1:2
%     for h=1:2
%         xCoordLet(count) = x0+xCoordCountLet;
%         yCoordLet(count) = y0+yCoordCountLet;
%         count = count+1;
%         yCoordCountLet = 100;
%     end
%     yCoordCountLet = -100;
%     xCoordCountLet = 100;
% end
xCoordLet = zeros(3,1);
yCoordLet = zeros(3,1);
xCoordLet(2) = x0;
yCoordLet(2) = y0;
xCoordLet(1) = xCoordLet(2) - xCoordCountLet;
yCoordLet(1) = yCoordLet(2);
xCoordLet(3) = xCoordLet(2) + xCoordCountLet;
yCoordLet(3) = yCoordLet(2);

% Setting location for numbers
yCoordCountNum = 70;
for j=1:2
    xCoordNum(j) = x0;
    yCoordNum(j) = y0-yCoordCountNum;
    yCoordCountNum = yCoordCountNum*(-1);
end

Screen('BlendFunction',w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);  % Must have for alpha values for some reason
noise=Screen('MakeTexture',w,noiseMatrix);

% Instructions
Screen('TextSize',w,20);
text='Press any key to begin.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-50,textColor);
Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
Screen('Flip',w);
KbWait(dev_ID);
KbReleaseWait(dev_ID);

[keyIsDown, secs, keycode] = KbCheck(dev_ID);
for n=1:numTrials
    
    % Choosing the blank time before the cue
    preCueIntervalIdx=variableList(trialOrder(n),1);
    preCueInterVal=preCueIntervalList(preCueIntervalIdx);
    rawdata(n,1)=preCueIntervalIdx;
    
    % Choosing whether or not there will be a cue
    cuePresentIdx = variableList(trialOrder(n),2);
    cuePresentVal = cuePresentList(cuePresentIdx);
    rawdata(n,2) = cuePresentVal;
    
    % Randomly determine which of the four letters will be cued
    whichLetterVal = randi(3);
    rawdata(n,3) = whichLetterVal;
    
    % Blank Screen With Fixation
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(1);
    
    % Randomly assing the choosen letter and color combos to locations on
    % the screen and the two numbers
    % 1=top left 2=bot left 3=top right 4=bot right
    numVal(n,:) = randi(9,[1 2]);
    while numVal(n,1)==numVal(n,2)
        numVal(n,:) = randi(9,[1 2]);
    end
    
    % Display text for 200 ms
    for i=1:length(colorPosition(n,:))
        if colorPosition(n,i) == 1
            color = [0 0 256];   % blue
        elseif colorPosition(n,i) == 2
            color = [0 256 0];   % green
        elseif colorPosition(n,i) == 3
            color = [256 256 0]; % yellow
        elseif colorPosition(n,i) == 4
            color = [256 0 256]; % magenta
        elseif colorPosition(n,i) == 5
            color = [256 0 0];   % red
        end
        
        Screen('TextSize',w,letSize);
        text = letters{letterPosition(n,i)};
        tWidth(i)=RectWidth(Screen('TextBounds',w,text));
        tHeight(i)=RectHeight(Screen('TextBounds',w,text));
        Screen('DrawText',w,text, xCoordLet(i)-tWidth(i)/2, yCoordLet(i)-tHeight(i)/2, color);
    end
    for i=1:length(numVal(n,:))
        Screen('TextSize',w,numSize);
        text = numVal(n,i);
        nWidth=RectWidth(Screen('TextBounds',w,text));
        nHeight=RectHeight(Screen('TextBounds',w,text));
        Screen('DrawText',w,num2str(numVal(n,i)), xCoordNum(i)-tWidth(2)/2, yCoordNum(i)-nHeight/2, [numColor numColor numColor]);
    end
    Screen('Flip',w);
    % Wait for 200ms
    WaitSecs(stimPresTime(stimPresCount));
    
    % Mask
    Screen('DrawTexture',w,noise,[],destRectNoise,[],[]);
    Screen('Flip',w);
    % Display mask for 100 ms
    WaitSecs(1);
    
    % Wait 1 second before presenting retro cue
    Screen('Flip',w);
    WaitSecs(1);
    
    % Retro Cue
    % If cue present = 1 present the cue
    if cuePresentVal == 1
        if whichLetterVal == 1
            c1 = [255 255 255];
            c2 = [0 0 0];
            c3 = [0 0 0];
        elseif whichLetterVal == 2
            c1 = [0 0 0];
            c2 = [255 255 255];
            c3 = [0 0 0];
        elseif whichLetterVal == 3
            c1 = [0 0 0];
            c2 = [0 0 0];
            c3 = [255 255 255];
        end
    else
        c1 = [0 0 0];
        c2 = [0 0 0];
        c3 = [0 0 0];
    end
    
    % Draw three circles each time and white one if retro cue present
    Screen('FillOval',w,c1,[xCoordLet(1)-cueLength/2,yCoordLet(1)-cueLength/2,...
        xCoordLet(1)+cueLength/2,yCoordLet(1)+cueLength/2]);
    
    Screen('FillOval',w,c2,[xCoordLet(2)-cueLength/2,yCoordLet(2)-cueLength/2,...
        xCoordLet(2)+cueLength/2,yCoordLet(2)+cueLength/2]);
    
    Screen('FillOval',w,c3,[xCoordLet(3)-cueLength/2,yCoordLet(3)-cueLength/2,...
        xCoordLet(3)+cueLength/2,yCoordLet(3)+cueLength/2]);
    Screen('Flip',w);
    WaitSecs(.1);
    
    % Variable post cue time after retro cue
    Screen('Flip',w);
    WaitSecs(preCueInterVal);
    
    % Probe
    if whichLetterVal == 1
        c1 = [255 255 255];
        c2 = [0 0 0];
        c3 = [0 0 0];
    elseif whichLetterVal == 2
        c1 = [0 0 0];
        c2 = [255 255 255];
        c3 = [0 0 0];
    elseif whichLetterVal == 3
        c1 = [0 0 0];
        c2 = [0 0 0];
        c3 = [255 255 255];
    end
    
    Screen('FrameRect',w,c1,[xCoordLet(1)-tWidth(1)/2,...
        yCoordLet(1)-max(tHeight)/2,...
        (xCoordLet(1)-max(tWidth)/2)+max(tWidth),...
        (yCoordLet(1)-max(tHeight)/2)+max(tHeight)]);
    
    Screen('FrameRect',w,c2,[xCoordLet(2)-max(tWidth)/2,...
        yCoordLet(2)-max(tHeight)/2,...
        (xCoordLet(2)-max(tWidth)/2)+max(tWidth),...
        (yCoordLet(2)-max(tHeight)/2)+max(tHeight)]);
    
    Screen('FrameRect',w,c3,[xCoordLet(3)-max(tWidth)/2,...
        yCoordLet(whichLetterVal)-max(tHeight)/2,...
        (xCoordLet(3)-max(tWidth)/2)+max(tWidth),...
        (yCoordLet(3)-max(tHeight)/2)+max(tHeight)]);
    
    Screen('Flip',w);
    WaitSecs(2);
    
    % Calling functions to collect responses
    % rawdata(n,4) = did they get the number correct
    % numResponse = index to numREsponseChoice of what they actually choose
    % numResponseChoice = the list of 4 num choices presented
    [rawdata(n,4), numResponse(n), numResponseChoice(:,n)] = ResponseNumbers(w,rect,dev_ID,numVal(n,:));
    Screen('TextSize',w,50);
    if rawdata(n,4) == 1
        text = 'Correct';
        respColor = [0 255 0];
    else
        text = 'Incorrect';
        respColor = [255 0 0];
    end
    width=RectWidth(Screen('TextBounds',w,text));
    height=RectHeight(Screen('TextBounds',w,text));
    Screen('DrawText',w,text, x0-width/2, y0-height/2, respColor);
    Screen('Flip',w);
    WaitSecs(.5);
    
    % rawdata(n,5) = did they get the letter correct
    % rawdata(n,6) = did they get the color correct
    [rawdata(n,5), rawdata(n,6), letResponse(n), colResponse(n)] = ResponseLetters(w,rect,dev_ID,(letters{letterPosition(n,whichLetterVal)}),(colors{colorPosition(n,whichLetterVal)}));
    
    % rawdata(n,7) = were you confident (1=yes 0=no)
    [rawdata(n,7)] = ResponseConf(w,rect,dev_ID);
    
    
    
    %     % Looking for feature errors vs feature misbinding
    %     if rawdata(n,5) ~= 1
    %         countMisLet = 0;
    %         countMisCol = 0;
    %         for i=1:3
    %             if strcmp(letList{letResponse(n)},letters{letterPosition(n,i)})
    %                 featureErrorLet(errorTotalLet) = 1;
    %                 errorTotalLet = errorTotalLet+1;
    %                 countMisLet = 1;
    %             end
    %             if strcmp(colors{colResponse(n)},colors{colorPosition(n,i)})
    %                 featureErrorCol(errorTotalCol) = 1;
    %                 errorTotalCol = errorTotalCol+1;
    %                 countMisCol = 1;
    %             end
    %         end
    %         if countMisLet==0
    %             misbindingErrorLet(misbindingTotalLet) = 1;
    %             misbindingTotalLet = misbindingTotalLet + 1;
    %         end
    %         if countMisCol==0
    %             misbindingErrorCol(misbindingTotalCol) = 1;
    %             misbindingTotalCol = misbindingTotalCol + 1;
    %         end
    %     end
    %
    
    
    % Add in a check for feature accuracy every 10 trials that updates the
    % exposure times
    this_b = 0;
    for b = acc_checks
        if n==b
            this_b = b;
            break
        end
    end
    
    if this_b
        % Accuracy of the numbers
        numAcc = mean(rawdata(:,4)) * 100;
        % Accuracy of the letters
        letAcc = mean(rawdata(:,5)) * 100;
        % Accuracy of the colors
        colAcc = mean(rawdata(:,6)) * 100;
        stimPresCount = stimPresCount + 1;
        if numAcc >= 90
            if letAcc >= 70 && colAcc >= 70
                disp('Accuracy High, turning down stim duration');
                if stimPresTime(stimPresCount-1) > .1
                    stimPresTime(stimPresCount) = stimPresTime(stimPresCount-1) - .02;
                else
                    stimPresTime(stimPresCount) = stimPresTime(stimPresCount-1) - .005;
                end
            elseif letAcc < 70 || colAcc < 70
                disp('Accuracy Low, turning up stim duration');
                if stimPresTime(stimPresCount-1) <= .2
                    stimPresTime(stimPresCount) = stimPresTime(stimPresCount-1) + .02;
                elseif stimPresTime(stimPresCount-1) > .2
                    stimPresTime(stimPresCount) = stimPresTime(stimPresCount-1) + .005;
                end
            end
        else
            if letAcc >= 70 && colAcc >= 70
                disp('Num Acc low, let and col acc high');
                if stimPresTime(stimPresCount-1) <= .2
                    stimPresTime(stimPresCount) = stimPresTime(stimPresCount-1) + .02;
                elseif stimPresTime(stimPresCount-1) > .2
                    stimPresTime(stimPresCount) = stimPresTime(stimPresCount-1) + .005;
                end
            elseif letAcc < 70 || colAcc < 70
                disp('Accuracy Low, turning up stim duration');
                if stimPresTime(stimPresCount-1) <= .2
                    stimPresTime(stimPresCount) = stimPresTime(stimPresCount-1) + .02;
                elseif stimPresTime(stimPresCount-1) > .2
                    stimPresTime(stimPresCount) = stimPresTime(stimPresCount-1) + .005;
                end
            end
        end
    end
    
    
    
    
    
    %         % Calculate the feature error rate and accuracy of primary item
    %
    %         % Feature error = if you reported a color/letter that wasn't there
    %         % Conjunction error = if you reported a color/letter that was there
    %         %   but conjoined with the wrong letter/color
    %
    %         % For letter
    %         letAcc(nLetAcc) = sum(rawdata(:,5)/n);
    %         nLetAcc = nLetAcc + 1;
    %
    %         % For color
    %         colAcc(nColAcc) = sum(rawdata(:,6)/n);
    %         nColAcc = nColAcc + 1;
    %
    %         % Accuracy on the numbers for the past 10 trials
    %         numAcc(nNumAcc) = sum(rawdata([n-10;n],4))/10;
    %         nNumAcc = nNumAcc +1;
    %
    %         % Increasing/Decreasing stim time depending on preformance
    %         if numAcc(nNumAcc) > .75 && stimTime(n) <= 200
    %             if stimTime(n) <= 100
    %                 stimTime(n+1) = stimTime(n) - 5;
    %             elseif stimTime > 100
    %                 stimTime(n+1) = stimTime(n) - 20;
    %             end
    %         elseif numAcc(nNumAcc) < .75
    %             if stimTime(n) <= 100
    %                 stimTime(n+1) = stimTime(n) + 5;
    %             elseif stimTime > 100
    %                 stimTime(n+1) = stimTime(n) + 20;
    %             end
    %         end
    %     end
    % give subject break at certain trials...
    this_b = 0;
    for b = break_trials
        if n==round(b*length(trialOrder))
            this_b = b;
            break
        end
    end
    
    if this_b
        % display break message
        Screen('TextSize',w,20);
        text=sprintf('You have completed %d%% of the trials.',round(b*100));
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,x0-width/2,y0-100,textColor);
        text='Press any key when you are ready to continue.';
        width=RectWidth(Screen('TextBounds',w,text));
        
%         countDisp = countDisp+1;
%         fileID = fopen(sprintf('%s%s_timing_acc.txt',pathOut,subjid),'w');
%         if abs(((GetSecs-totalTime)/60)-(floor((GetSecs-totalTime)/60)))*60 < 10
%             disptime{countDisp,1} = sprintf('%d%s%1.0f',floor((GetSecs-totalTime)/60),':0',abs(((GetSecs-totalTime)/60)-(floor((GetSecs-totalTime)/60)))*60);
%         else
%             disptime{countDisp,1} = sprintf('%d%s%1.0f',floor((GetSecs-totalTime)/60),':',abs(((GetSecs-totalTime)/60)-(floor((GetSecs-totalTime)/60)))*60);
%         end
%         disptime{countDisp,2} = this_b*100;
%         disptime{countDisp,3} = mean(rawdata(:,4))*100;
%         formatSpec = '%s %1.0f %1.0f\n';
%         [nrows,ncols] = size(disptime);
%         for row = 1:nrows
%             fprintf(fileID,formatSpec,disptime{row,:});
%         end
%         fclose(fileID);
% %         fprintf(fileID,'%1.0f %1.0f %s \n',A);
        
        Screen('DrawText',w,text,x0-width/2,y0,textColor);
        text=sprintf('Your accuracy is %d%%',round(mean(rawdata(:,4))*100));
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,x0-width/2,y0+100,textColor);
        Screen('Flip',w);
        disp(this_b*100);
        if abs(((GetSecs-totalTime)/60)-(floor((GetSecs-totalTime)/60)))*60<10
            disp(sprintf('%d%s%1.0f',floor((GetSecs-totalTime)/60),':0',abs(((GetSecs-totalTime)/60)-(floor((GetSecs-totalTime)/60)))*60));
        else
            disp(sprintf('%d%s%1.0f',floor((GetSecs-totalTime)/60),':',abs(((GetSecs-totalTime)/60)-(floor((GetSecs-totalTime)/60)))*60));
        end
        
        
        [keyIsDown, secs, keycode] = KbCheck(dev_ID);
        KbReleaseWait(dev_ID);
        while 1
            [keyIsDown, secs, keycode] = KbCheck(dev_ID);
            if keyIsDown
                break
            end
        end
    end
    
    
    
    % Measure response first for numbers and then for cued target then take
    % a confidance rating
end

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
% stimPresTime = list of stimulus presentation times calculated every ten
%    trials

save(sprintf('%s%s',pathOut,datafile),'rawdata','numVal','numResponse','numResponseChoice','letterPosition',...
    'letResponse','colorPosition','colResponse','colors','letters','stimPresTime');
save(datafile_full);

% fclose(fileID);

% Instructions
Screen('TextSize',w,20);
text='You have finished! Let the experimenter know you are done.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-50,textColor);
Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
Screen('Flip',w);
KbWait(dev_ID);
KbReleaseWait(dev_ID);

ShowCursor;
ListenChar(0);
Screen('CloseAll');