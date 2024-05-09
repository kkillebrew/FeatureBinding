% Illusory Conjunction experiment

close all;
clear all;
% Five different combinations of 4 letters out of 5 colors and letters
letterList ={{'T' 'S' 'N' 'O'} {'S' 'N' 'O' 'X'} {'T' 'S' 'N' 'X'} {'T' 'N' 'X' 'O'} {'T' 'S' 'X' 'O'}};
nLetter = length(letterList);
% bl = [0 0 256];   % 1
% gr = [0 256 0];   % 2
% ye = [256 256 0]; % 3
% ma = [256 0 256]; % 4
% re = [256 0 0];   % 5
colorList = [3 2 1 4; 3 2 1 5; 3 1 4 5; 3 2 4 5; 2 4 1 5];
nColor = length(colorList);
cueTimeList = [100 500 1000];     % in milliseconds
nCueTime = length(cueTimeList);
nTrials = 10;

numSize = 40;
letSize = 50;

variableList = repmat(fullyfact([nLetter nColor nCueTime]),[nTrials,1]);
trialOrder=randperm(length(variableList));
numTrials = length(trialOrder);

buttonLeft=KbName('LeftShift');
buttonRight=KbName('RightShift');

rawdata = [];
letterOrder = [];
colorOrder = [];
numCoord = [];

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
[w,rect]=Screen('OpenWindow', 0,[backColor backColor backColor],rect);
x0 = rect(3)/2;% screen center
y0 = rect(4)/2;

% Setting location for letters
xCoordCountLet = -100;
yCoordCountLet = -100;
count = 1;
for j=1:2
    for h=1:2
        xCoordLet(count) = x0+xCoordCountLet;
        yCoordLet(count) = y0+yCoordCountLet;
        count = count+1;
        yCoordCountLet = 100;
    end
    yCoordCountLet = -100;
    xCoordCountLet = 100;
end

% break_trials = .25:.25:.75; % list of proportion of total trials at which to offer subject a self-timed break
break_trials = .1:.1:.9;    % list of proportion of total trials at which to offer subject a self-timed break

% Sets the inputs to come in from the other computer
[nums, names] = GetKeyboardIndices;
dev_ID=nums(1);
con_ID=nums(1);

% Instructions
Screen('TextSize',w,20);
text='Press any key to begin.';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0-50,textColor);
Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
Screen('Flip',w);
KbWait(dev_ID);
KbReleaseWait(dev_ID);

for n=1:numTrials
    letterIdx=variableList(trialOrder(n),1);
    letterVal=letterList{letterIdx};
    rawdata(n,1)=letterIdx;
    
    colorIdx=variableList(trialOrder(n),2);
    colorVal=colorList(colorIdx,:);
    rawdata(n,2)=colorIdx;
    
    cueIdx=variableList(trialOrder(n),3);
    cueVal=cueTimeList(cueIdx);
    rawdata(n,3)=cueIdx;
    
    % Randomly assing the choosen letter and color combos to locations on
    % the screen and the two numbers
    % 1=top left 2=top right 3=bot left 4=bot right
    letterOrder(n,:) = randperm(4);
    colorOrder(n,:) = randperm(4);
    numVal(n,:) = randi(9,[1 2]);
    
    % Display text for 50 ms
    movem = 0;
    for i=1:length(letterOrder(n,:))
        if colorVal(colorOrder(n,i)) == 1
            color = [0 0 256];   % blue
            colorOrderData{n,i} = 'B';
        elseif colorVal(colorOrder(n,i)) == 2
            color = [0 256 0];   % green
            colorOrderData{n,i} = 'G';
        elseif colorVal(colorOrder(n,i)) == 3
            color = [256 256 0]; % yellow
            colorOrderData{n,i} = 'Y';
        elseif colorVal(colorOrder(n,i)) == 4
            color = [256 0 256]; % magenta
            colorOrderData{n,i} = 'M';
        elseif colorVal(colorOrder(n,i)) == 5
            color = [256 0 0];   % red
            colorOrderData{n,i} = 'R';
        end
        
        Screen('TextSize',w,letSize);
        text = letterVal{letterOrder(n,i)};
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text, xCoordLet(i)-width/2, yCoordLet(i)-width, color);
        
        letterOrderData{n,i} = letterVal{letterOrder(n,i)};
    end
%     for i=1:length(numVal(n,:))
%         yCoordCountNum = 50;
%         xCoordNum(1) = (x0-width/2);
%         yCoordNum(1) = (y0-width/2)-yCoordCountNum;
%         xCoordNum(2) = (x0-width/2);
%         yCoordNum(2) = (y0-width/2)+yCoordCountNum;
%         
%         Screen('TextSize',w,numSize);
%         Screen('DrawText',w,num2str(numVal(n,i)), xCoordNum(i), yCoordNum(i), [numColor numColor numColor]);
%     end
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    KbWait(dev_ID);
    KbReleaseWait(dev_ID);
    
    % Mask
    
    % Add in a check for feature accuracy every 10 trials that updates the
    % exposure times
    
    % Measure response first for numbers and then for cued target then take
    % an confidance rating
end

ShowCursor;
ListenChar(0);
Screen('CloseAll');