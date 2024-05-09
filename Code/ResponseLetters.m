function [responseLetCorrect, responseColCorrect, responseLet, responseCol] = ResponseLetters(screenName,rectSize,devID,actualLetter,actualColor)
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
% 
% actualLetter = 'A';
% actualColor = 'y';

textColor = [256, 256, 256];
x0 = rectSize(3)/2;% screen center

letList = {'T' 'S' 'N' 'P' 'X'};
nLetList = length(letList);
% bl = [0 0 256];   % 1
% gr = [0 256 0];   % 2
% ye = [256 256 0]; % 3
% ma = [256 0 256]; % 4
% re = [256 0 0];   % 5
colors = {'b' 'g' 'y' 'm' 'r'};
colorList = [1 2 3 4 5];
nColorList = length(colorList);
colorVals(1,:) = [0 0 256];   % 1
colorVals(2,:) = [0 256 0];   % 2
colorVals(3,:) = [256 256 0]; % 3
colorVals(4,:) = [256 0 256]; % 4
colorVals(5,:) = [256 0 0];   % 5

insTxtSize = 30;
Screen('TextSize',screenName,insTxtSize);
insText = 'Please choose the letter and color of the probed item';
iWidth = RectWidth(Screen('TextBounds',screenName,insText));
iHeight = RectHeight(Screen('TextBounds',screenName,insText)); 

% Spacing variables
boxLengthLet = 100;    % Box width/height in pixels
boxSpaceLet = 10;     % Distance between each box
xSideSpaceLet = (rectSize(3)-((5*boxLengthLet)+(4*boxSpaceLet)))/2;    % Distance from the sides of the screen and start of the grid
ySideSpaceLet = 20 + iHeight;
letColorDistance = 50;
boxLengthCol = 100;
boxSpaceCol = 10;
xSideSpaceCol = (rectSize(3)-((nColorList*boxLengthLet)+((nColorList-1)*boxSpaceLet)))/2;
ySideSpaceCol = 10;

xTopCoord(1) = xSideSpaceLet;
yTopCoord(1) = ySideSpaceLet;
xBotCoord(1) = xTopCoord(1)+boxLengthLet;
yBotCoord(1) = yTopCoord(1)+boxLengthLet;

count = 1;
% Draw the first number of evenly spaced rows
for k=1:1
    for l=1:5
        destRect(:,count) = [xTopCoord(count) yTopCoord(count) xBotCoord(count) yBotCoord(count)];
        
        Screen('TextSize',screenName,50);
        text = letList{count};
        tWidth = RectWidth(Screen('TextBounds',screenName,text));
        tHeight = RectHeight(Screen('TextBounds',screenName,text));
        xLet(count) = (xTopCoord(count)+(boxLengthLet/2))-tWidth/2;
        yLet(count) = (yTopCoord(count)+(boxLengthLet/2))-tHeight/2;
        
        xTopCoord(count+1) = xTopCoord(count)+boxSpaceLet+boxLengthLet;
        xBotCoord(count+1) = xTopCoord(count+1)+boxLengthLet;
        
        yTopCoord(count+1) = yTopCoord(count);
        yBotCoord(count+1) = yBotCoord(count);
        
        count=count+1;
    end
    xTopCoord(count) = xSideSpaceLet;
    xBotCoord(count) = xTopCoord(count)+boxLengthLet;
    
    yTopCoord(count) = yTopCoord(count-1)+boxSpaceLet+boxLengthLet;
    yBotCoord(count) = yTopCoord(count)+boxLengthLet;

end

% xTopCoord(count) = xTopCoord(count)+boxSpaceLet+boxLengthLet;
% xBotCoord(count) = xTopCoord(count)+boxLengthLet;
% % Draw the last row with an odd amount of letters
% for k=1:1
%     for l=1:5
%         
%         destRect(:,count) = [xTopCoord(count) yTopCoord(count) xBotCoord(count) yBotCoord(count)];
%         
%         Screen('TextSize',screenName,50);
%         text = letList{count};
%         tWidth = RectWidth(Screen('TextBounds',screenName,text));
%         tHeight = RectHeight(Screen('TextBounds',screenName,text));
%         xLet(count) = (xTopCoord(count)+(boxLengthLet/2))-tWidth/2;
%         yLet(count) = (yTopCoord(count)+(boxLengthLet/2))-tHeight/2;
%         
%         xTopCoord(count+1) = xTopCoord(count)+boxSpaceLet+boxLengthLet;
%         xBotCoord(count+1) = xTopCoord(count+1)+boxLengthLet;
%         
%         yTopCoord(count+1) = yTopCoord(count);
%         yBotCoord(count+1) = yBotCoord(count);
%         
%         count=count+1;
%     end
%     xTopCoord(count) = xSideSpaceLet;
%     xBotCoord(count) = xTopCoord(count-1)+boxLengthLet;
%     
%     yTopCoord(count) = yTopCoord(count-1)+boxSpaceLet+boxLengthLet;
%     yBotCoord(count) = yTopCoord(count)+boxLengthLet;
% end

yTopCoordCol(1) = yTopCoord(count) + letColorDistance;
xTopCoordCol(1) = xSideSpaceCol;
yBotCoordCol(1) = yTopCoordCol(1)+boxLengthCol;
xBotCoordCol(1) = xTopCoordCol(1)+boxLengthCol;

count = 1;
for k=1:1
    for l=1:nColorList
        
        destRectCol(:,count) = [xTopCoordCol(count) yTopCoordCol(count) xBotCoordCol(count) yBotCoordCol(count)];
        
        xTopCoordCol(count+1) = xTopCoordCol(count)+boxSpaceCol+boxLengthCol;
        xBotCoordCol(count+1) = xTopCoordCol(count+1)+boxLengthCol;
        
        yTopCoordCol(count+1) = yTopCoordCol(count);
        yBotCoordCol(count+1) = yBotCoordCol(count);
        
        count=count+1;
    end
    xTopCoordCol(count) = xSideSpaceCol;
    xBotCoordCol(count) = xTopCoordCol(count)+boxLengthCol;
    
    yTopCoordCol(count) = yTopCoordCol(count-1)+boxSpaceCol+boxLengthCol;
    yBotCoordCol(count) = yTopCoordCol(count)+boxLengthCol;
end


[MX, MY, buttons] = GetMouse(screenName);
ShowCursor;
responseLetCorrect = [];
responseLet = [];
responseColCorrect = [];
responseCol = [];
countLet = [];
countCol = [];

[keyIsDown, secs, keycode] = KbCheck(devID);

while 1
    
    [keyIsDown, secs, keycode] = KbCheck(devID);
    

    
    % Instructions
    Screen('TextSize',screenName,insTxtSize);
    Screen('DrawText',screenName,insText,x0-iWidth/2,iHeight/2,textColor);
    
    for k=1:nLetList
        Screen('TextSize',screenName,50);
        Screen('DrawText',screenName,letList{k},xLet(k),yLet(k),[0 0 0]);
    end
    
    Screen('FrameRect',screenName,[0 0 0],destRect);
    
    for i=1:nColorList
        Screen('FillRect',screenName,colorVals(i,:),destRectCol(:,i));
    end
    
    if ~isempty(countLet)
        Screen('FrameRect',screenName,[255 255 255],destRect(:,countLet));
    end
    if ~isempty(countCol)
        Screen('FrameRect',screenName,[255 255 255],destRectCol(:,countCol),5);
    end
    
    Screen('Flip',screenName);
    
    [MX, MY, buttons] = GetMouse(screenName);
    for i=1:nLetList
        if buttons(1) ==1
            if MX>=xTopCoord(i) && MX<=xBotCoord(i) && MY>=yTopCoord(i) && MY<=yBotCoord(i)
                responseLet =  i;
                if letList{i} == actualLetter
                    responseLetCorrect = 1;
                else
                    responseLetCorrect = 0;
                end
                countLet = i;
            end
        end
    end
    
    [MX, MY, buttons] = GetMouse(screenName);
    for i=1:nColorList
        if buttons(1) ==1
            if MX>=xTopCoordCol(i) && MX<=xBotCoordCol(i) && MY>=yTopCoordCol(i) && MY<=yBotCoordCol(i)
                responseCol =  i;
                
                if colors{i} == actualColor
                    responseColCorrect = 1;
                else
                    responseColCorrect = 0;
                end
                countCol = i;
            end
        end
    end
    if keyIsDown 
        if ~isempty(responseColCorrect)
            if ~isempty(responseLetCorrect)
                break
            end
        end
    end
    
end


% ListenChar(0);
% ShowCursor;
% 
% Screen('CloseAll');

