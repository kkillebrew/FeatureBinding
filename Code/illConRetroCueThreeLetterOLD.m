% Illusory Conjunction experiment

close all;
clear all;

load('PreallocateNoise');

% Five different combinations of 4 letters out of 5 colors and letters
letterList ={{'Q' 'W' 'E' 'R'} {'W' 'E' 'R' 'T'} {'Q' 'W' 'E' 'T'} {'Q' 'E' 'T' 'R'} {'Q' 'W' 'T' 'R'}};
nLetter = length(letterList);
% bl = [0 0 256];   % 1
% gr = [0 256 0];   % 2
% ye = [256 256 0]; % 3
% ma = [256 0 256]; % 4
% re = [256 0 0];   % 5
colorList = [3 2 1 4; 3 2 1 5; 3 1 4 5; 3 2 4 5; 2 4 1 5];
nColor = length(colorList);
cueTimeList = [.1];     % in milliseconds
nCueTime = length(cueTimeList);
cuePresentList = [1 0];
nCuePresent = length(cuePresentList);
nTrials = 10;

numSize = 40;
letSize = 50;

variableList = repmat(fullyfact([nLetter nColor nCueTime nCuePresent]),[nTrials,1]);
trialOrder=randperm(length(variableList));
numTrials = length(trialOrder);

buttonLeft=KbName('LeftShift');
buttonRight=KbName('RightShift');
one = KbName('1!');
two = KbName('2@');
three = KbName('3#');
four = KbName('4$');
five = KbName('5%');
six = KbName('6^');
seven = KbName('7&');
eight = KbName('8*');
nine = KbName('9(');
buttonQ = KbName('Q');
buttonW = KbName('W');
buttonE = KbName('E');
buttonR = KbName('R');
buttonT = KbName('T');

rawdata = [];
letterOrder = [];
colorOrder = [];
numVal = [];
numAnswer = [];
letAnswer = [];
cueLength = 50;

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

% Setting location for numbers
yCoordCountNum = 50;
for j=1:2   
    xCoordNum(j) = x0;
    yCoordNum(j) = y0-yCoordCountNum;
    yCoordCountNum = -50;
end

Screen('BlendFunction',w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);  % Must have for alpha values for some reason
noise=Screen('MakeTexture',w,noiseMatrix);

% break_trials = .25:.25:.75; % list of proportion of total trials at which to offer subject a self-timed break
break_trials = .1:.1:.9;    % list of proportion of total trials at which to offer subject a self-timed break

% Sets the inputs to come in from the other computer
[nums, names] = GetKeyboardIndices;
dev_ID=nums(1);
con_ID=nums(1);

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

[keyIsDown, secs, keycode] = KbCheck;
for n=1:numTrials
    
    letterIdx=variableList(trialOrder(n),1);
    letterVal=letterList{letterIdx};
    rawdata(n,1)=letterIdx;
    
    colorIdx=variableList(trialOrder(n),2);
    colorVal=colorList(colorIdx,:);
    rawdata(n,2)=colorIdx;
    
    cueDurationIdx=variableList(trialOrder(n),3);
    cueDurationVal=cueTimeList(cueDurationIdx);
    rawdata(n,3)=cueDurationIdx;
    
    cuePresentIdx = variableList(trialOrder(n),4);
    cuePresentVal = cuePresentList(cuePresentIdx);
    rawdata(n,4) = cuePresentVal;
    
    % Randomly determine which of the four letters will be cued
    whichLetterVal = randi(4);
    rawdata(n,5) = whichLetterVal;
    
    % Blank Screen With Fixation
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(1);
    
    % Randomly assing the choosen letter and color combos to locations on
    % the screen and the two numbers
    % 1=top left 2=bot left 3=top right 4=bot right
    letterOrder(n,:) = randperm(4);
    colorOrder(n,:) = randperm(4);
    numVal(n,:) = randi(9,[1 2]);
    while numVal(n,1)==numVal(n,2)
        numVal(n,:) = randi(9,[1 2]);
    end
    
    % Display text for 50 ms
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
        tWidth(i)=RectWidth(Screen('TextBounds',w,text));
        tHeight(i)=RectHeight(Screen('TextBounds',w,text));
        Screen('DrawText',w,text, xCoordLet(i)-tWidth(i)/2, yCoordLet(i)-tHeight(i)/2, color);
        
        letterOrderData{n,i} = letterVal{letterOrder(n,i)};
    end
    for i=1:length(numVal(n,:))
        Screen('TextSize',w,numSize);
        text = letterVal{letterOrder(n,i)};
        nWidth=RectWidth(Screen('TextBounds',w,text));
        nHeight=RectHeight(Screen('TextBounds',w,text));
        Screen('DrawText',w,num2str(numVal(n,i)), xCoordNum(i)-nWidth/2, yCoordNum(i)-nHeight/2, [numColor numColor numColor]);
    end
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    % Wait for 200ms
    WaitSecs(.2);
    
    % Mask
    Screen('DrawTexture',w,noise,[],destRectNoise,[],[]);
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    % Display for 500 ms
    WaitSecs(.2);
    
    % How long should the cue be presented after the mask
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(cueDurationVal);
    
    % Post Cue
    % If cue present = 1 present the cue
    if cuePresentVal == 1
        if whichLetterVal == 1
            Screen('DrawLine',w,[0 0 0],x0-10,y0-10,x0-(cueLength+10),y0-(cueLength+10),5);
        elseif whichLetterVal == 2        
            Screen('DrawLine',w,[0 0 0],x0-10,y0+10,x0-(cueLength+10),y0+(cueLength+10),5);
        elseif whichLetterVal == 3
            Screen('DrawLine',w,[0 0 0],x0+10,y0-10,x0+(cueLength+10),y0-(cueLength+10),5);
        elseif whichLetterVal == 4
            Screen('DrawLine',w,[0 0 0],x0+10,y0+10,x0+(cueLength+10),y0+(cueLength+10),5);
        end
    end
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(.2);
    
    % Blank Fixation period
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(1);
    
    % Probe
    if whichLetterVal == 1
        Screen('FrameRect',w,[0 0 0],[xCoordLet(whichLetterVal)-tWidth(whichLetterVal)/2,...
            yCoordLet(whichLetterVal)-tHeight(whichLetterVal)/2,...
            (xCoordLet(whichLetterVal)-tWidth(whichLetterVal)/2)+tWidth(whichLetterVal),...
            (yCoordLet(whichLetterVal)-tHeight(whichLetterVal)/2)+tHeight(whichLetterVal)]);
    elseif whichLetterVal == 2
        Screen('FrameRect',w,[0 0 0],[xCoordLet(whichLetterVal)-tWidth(whichLetterVal)/2,...
            yCoordLet(whichLetterVal)-tHeight(whichLetterVal)/2,...
            (xCoordLet(whichLetterVal)-tWidth(whichLetterVal)/2)+tWidth(whichLetterVal),...
            (yCoordLet(whichLetterVal)-tHeight(whichLetterVal)/2)+tHeight(whichLetterVal)]);
    elseif whichLetterVal == 3
        Screen('FrameRect',w,[0 0 0],[xCoordLet(whichLetterVal)-tWidth(whichLetterVal)/2,...
            yCoordLet(whichLetterVal)-tHeight(whichLetterVal)/2,...
            (xCoordLet(whichLetterVal)-tWidth(whichLetterVal)/2)+tWidth(whichLetterVal),...
            (yCoordLet(whichLetterVal)-tHeight(whichLetterVal)/2)+tHeight(whichLetterVal)]);
    elseif whichLetterVal == 4
        Screen('FrameRect',w,[0 0 0],[xCoordLet(whichLetterVal)-tWidth(whichLetterVal)/2,...
            yCoordLet(whichLetterVal)-tHeight(whichLetterVal)/2,...
            (xCoordLet(whichLetterVal)-tWidth(whichLetterVal)/2)+tWidth(whichLetterVal),...
            (yCoordLet(whichLetterVal)-tHeight(whichLetterVal)/2)+tHeight(whichLetterVal)]);
    end
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    
    % Ask for answers
    % Ask for numbers first
    [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    for h=1:2
        Screen('TextSize',w,20);
        text=sprintf('%s%d%s','Please report the ',h,' number.');
        tWidth=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,x0-tWidth/2,y0-50,textColor);
        Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
        Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
        Screen('Flip',w);
        [keyIsDown, secs, keycode] = KbCheck(dev_ID);
        while ~keyIsDown
            [keyIsDown, secs, keycode] = KbCheck(dev_ID);
            if keycode(one)
                numAnswer(n,h) = 1;
            end
            if keycode(two)
                numAnswer(n,h) = 2;
            end
            if keycode(three)
                numAnswer(n,h) = 3;
            end
            if keycode(four)
                numAnswer(n,h) = 4;
            end
            if keycode(five)
                numAnswer(n,h) = 5;
            end
            if keycode(six)
                numAnswer(n,h) = 6;
            end
            if keycode(seven)
                numAnswer(n,h) = 7;
            end
            if keycode(eight)
                numAnswer(n,h) = 8;
            end
            if keycode(nine)
                numAnswer(n,h) = 9;
            end
        end
        KbReleaseWait(dev_ID);
    end
    if numAnswer(n,1) == numVal(n,1)
        rawdata(n,6) = 1;                   % Indicates the top number was correct
    else
        rawdata(n,6) = 0;
    end
    if numAnswer(n,2) == numVal(n,2)
        rawdata(n,7) = 1;                   % Indicates the bottom number was correct
    else
        rawdata(n,7) = 0;
    end
    
    % Ask for numbers first
    [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    Screen('TextSize',w,20);
    text='Please report the letter at the probed location';
    tWidth=RectWidth(Screen('TextBounds',w,text));
    Screen('DrawText',w,text,x0-tWidth/2,y0-50,textColor);
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    while ~keyIsDown
        [keyIsDown, secs, keycode] = KbCheck(dev_ID);
        if keycode(buttonQ)
            letAnswer{n} = 'Q';
        end
        if keycode(buttonW)
            letAnswer{n} = 'W';
        end
        if keycode(buttonE)
            letAnswer{n} = 'E';
        end
        if keycode(buttonR)
            letAnswer{n} = 'R';
        end
        if keycode(buttonT)
            letAnswer{n} = 'T';
        end
    end
    KbReleaseWait(dev_ID);
    
    % Determine which values were presented but are not correct
    count=1;
    for p=1:length(letterVal)
        if ~strcmp(letterVal{p}, letterVal{whichLetterVal})
            otherLetters{count} = letterVal{p};
            count=count+1;
        end
    end
    
    if strcmp(letAnswer{n}, letterVal{whichLetterVal})     % If the answer they choose is the same as the actual value at that location mark 2
        rawdata(n,8) = 2;                   % Indicates the letter was correct
    elseif strcmp(letAnswer{n}, otherLetters)
        rawdata(n,8) = 1;                   % if the answer was one of the other values presented mark 1
    else
        raawdata(n,8) = 0;
    end
    
    
    % Add in a check for feature accuracy every 10 trials that updates the
    % exposure times
    
    % Measure response first for numbers and then for cued target then take
    % a confidance rating
    
    [keyIsDown, secs, keycode] = KbCheck;
end

ShowCursor;
ListenChar(0);
Screen('CloseAll');