function [responseCorrect,responseNum,numList] = ResponseNumbers(screenName,rectSize,devID,numberActual)
% close all;
% clear all;
% 
% mon_width_cm = 40;
% mon_dist_cm = 73;
% mon_width_deg = 2 * (180/pi) * atan((mon_width_cm/2)/mon_dist_cm);
% PPD = (1024/mon_width_deg);
% 
% ListenChar(2);
% HideCursor;
% backColor = 128;
% numColor = 0;
% textColor = [256, 256, 256];
% 
% rectSize=[0 0 1024 768];     % test comps
% [screenName,rectSize]=Screen('OpenWindow', 0,[backColor backColor backColor],rectSize);
% x0 = rectSize(3)/2;% screen center
% y0 = rectSize(4)/2;
% 
% % break_trials = .25:.25:.75; % list of proportion of total trials at which to offer subject a self-timed break
% break_trials = .1:.1:.9;    % list of proportion of total trials at which to offer subject a self-timed break
% 
% % Sets the inputs to come in from the other computer
% [nums, names] = GetKeyboardIndices;
% dev_ID=nums(1);
% con_ID=nums(1);
% 
% % Instructions
% Screen('TextSize',screenName,20);
% text='Press any key to begin.';
% tWidth=RectWidth(Screen('TextBounds',screenName,text));
% Screen('DrawText',screenName,text,x0-tWidth/2,y0-50,textColor);
% Screen('FillOval',screenName, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
% Screen('FillOval',screenName, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
% Screen('Flip',screenName);
% KbWait(dev_ID);
% KbReleaseWait(dev_ID);
% numberActual = [1 2];

% letList = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'};
% nLetList = length(letList);

textColor = [256, 256, 256];
x0 = rectSize(3)/2;% screen center
y0 = rectSize(4)/2;

% Randomly determines the order the choices are presented
countNum = randperm(4);

% Assigns the correct response to numList
numList{countNum(1)} = num2str(sprintf('%d%d',numberActual(1),numberActual(2)));

% Randomly chooses the two other numbers to be presented -- checks to make
% sure they are not equal to numberActual values and to each other
firstChoice = randi(9);
while firstChoice==numberActual(1) || firstChoice==numberActual(2)
   firstChoice = randi(9); 
end
secondChoice = randi(9);
while secondChoice==numberActual(1) || secondChoice==numberActual(2) || secondChoice==firstChoice
    secondChoice = randi(9);
end

% Assigns the second set (first correct number and second random) to numList in a random order
choice1 = randi(2);
if choice1 == 1
    numList{countNum(2)} = num2str(sprintf('%d%d',numberActual(1),firstChoice));
else
    numList{countNum(2)} = num2str(sprintf('%d%d',firstChoice,numberActual(1)));
end

% Assigns the third set (second correct number and second random) to numList in a random order
choice2 = randi(2);
if choice2 == 1
    numList{countNum(3)} = num2str(sprintf('%d%d',numberActual(2),secondChoice));
else
    numList{countNum(3)} = num2str(sprintf('%d%d',secondChoice,numberActual(2)));
end

% Assigns the two random numbers to numList in random positions
choice3 = randi(2);
if choice3 == 1
    numList{countNum(4)} = num2str(sprintf('%d%d',firstChoice,secondChoice));
else
    numList{countNum(4)} = num2str(sprintf('%d%d',secondChoice,firstChoice));
end
    
insTxtSize = 30;
Screen('TextSize',screenName,insTxtSize);
insText = 'Please choose the number pair that was presented';
iWidth = RectWidth(Screen('TextBounds',screenName,insText));
iHeight = RectHeight(Screen('TextBounds',screenName,insText)); 

% numList = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '0'};
nNumList = length(numList);
boxLength = 100;    % Box width/height in pixels
boxSpace = 10;     % Distance between each box
xSideSpace = (rectSize(3)-((4*boxLength)+(3*boxSpace)))/2;    % Distance from the sides of the screen and start of the grid
ySideSpace = y0/2;

numRows = 1;
numColumns = 4;

xTopCoord(1) = xSideSpace;
yTopCoord(1) = ySideSpace;
xBotCoord(1) = xTopCoord+boxLength;
yBotCoord(1) = yTopCoord+boxLength;

count = 1;
% Draw the first number of evenly spaced rows
for k=1:numRows
    for l=1:numColumns
        destRect(:,count) = [xTopCoord(count) yTopCoord(count) xBotCoord(count) yBotCoord(count)];
        
        Screen('TextSize',screenName,50);
        text = numList{count};
        tWidth = RectWidth(Screen('TextBounds',screenName,text));
        tHeight = RectHeight(Screen('TextBounds',screenName,text));
        xNum(count) = (xTopCoord(count)+(boxLength/2))-tWidth/2;
        yNum(count) = (yTopCoord(count)+(boxLength/2))-tHeight/2;
        
        xTopCoord(count+1) = xTopCoord(count)+boxSpace+boxLength;
        xBotCoord(count+1) = xTopCoord(count+1)+boxLength;
        
        yTopCoord(count+1) = yTopCoord(count);
        yBotCoord(count+1) = yBotCoord(count);
        
        count=count+1;
    end
    xTopCoord(count) = xSideSpace;
    xBotCoord(count) = xTopCoord(count)+boxLength;
    
    yTopCoord(count) = yTopCoord(count-1)+boxSpace+boxLength;
    yBotCoord(count) = yTopCoord(count)+boxLength;
    
end

[MX, MY, buttons] = GetMouse(screenName);
ShowCursor;
responseNum = [];
countNumber = [];
responseCorrect = 3;

[keyIsDown, secs, keycode] = KbCheck(devID);

while 1
    
    [keyIsDown, secs, keycode] = KbCheck(devID);
    
    % Instructions
    Screen('TextSize',screenName,insTxtSize);
    Screen('DrawText',screenName,insText,x0-iWidth/2,iHeight/2,textColor);
    
    Screen('TextSize',screenName,50);
    for k=1:nNumList
        Screen('DrawText',screenName,numList{k},xNum(k),yNum(k),[0 0 0]);
    end
    
    Screen('FrameRect',screenName,[0 0 0],destRect);
    
    if ~isempty(countNumber)
        Screen('FrameRect',screenName,[255 255 255],destRect(:,countNumber),5);
    end
    Screen('Flip',screenName);
    
    [MX, MY, buttons] = GetMouse(screenName);
    for i=1:nNumList
        if buttons(1) ==1
            if MX>=xTopCoord(i) && MX<=xBotCoord(i) && MY>=yTopCoord(i) && MY<=yBotCoord(i)
                % return the index of the number they selected, whether
                % it was correct, and the array of number choices
                % presented
                if i == countNum(1)
                    responseCorrect =  1;
                else
                    responseCorrect = 0;
                end
                responseNum = i;
                countNumber = i;
            end
        end
    end
        
    if keyIsDown
        if responseCorrect~= 3
            break
        
        end
    end
end

% ListenChar(0);
% ShowCursor;
% 
% Screen('CloseAll');

