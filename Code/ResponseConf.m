function [responseConf] = ResponseConf(screenName,rectSize,devID)
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

textColor = [256, 256, 256];
x0 = rectSize(3)/2;% screen center
y0 = rectSize(4)/2;

confList = {'1' '2' '3' '4' '5'};
nConfList = length(confList);

insTxtSize = 30;
Screen('TextSize',screenName,insTxtSize);
insText = 'Please rate how confident you are in your response.';
iWidth = RectWidth(Screen('TextBounds',screenName,insText));
iHeight = RectHeight(Screen('TextBounds',screenName,insText)); 

for i=1:nConfList
    Screen('TextSize',screenName,50);
    text = confList{i};
    tWidth(i) = RectWidth(Screen('TextBounds',screenName,text));
    tHeight(i) = RectHeight(Screen('TextBounds',screenName,text));
end

xBoxLength = max(tWidth)+10;    % Box width/height in pixels
yBoxLength = max(tHeight)+10;
boxSpace = 10;     % Distance between each box
xSideSpace = (rectSize(3)-((5*xBoxLength)+(4*boxSpace)))/2;    % Distance from the sides of the screen and start of the grid
ySideSpace = y0/2;

numRows = 1;
numColumns = 5;

xTopCoord(1) = xSideSpace;
yTopCoord(1) = ySideSpace;
xBotCoord(1) = xTopCoord+xBoxLength;
yBotCoord(1) = yTopCoord+yBoxLength;

count = 1;
% Draw the first number of evenly spaced rows
for k=1:numRows
    for l=1:numColumns
        
        xNum(count) = (xTopCoord(count)+(xBoxLength/2))-tWidth(count)/2;
        yNum(count) = (yTopCoord(count)+(yBoxLength/2))-tHeight(count)/2;
        
        destRect(:,count) = [xTopCoord(count) yTopCoord(count) xBotCoord(count) yBotCoord(count)];
        
        xTopCoord(count+1) = xTopCoord(count)+boxSpace+xBoxLength;
        xBotCoord(count+1) = xTopCoord(count+1)+xBoxLength;
        
        yTopCoord(count+1) = yTopCoord(count);
        yBotCoord(count+1) = yBotCoord(count);
        
        count=count+1;
    end
    xTopCoord(count) = xSideSpace;
    xBotCoord(count) = xTopCoord(count)+xBoxLength;
    
    yTopCoord(count) = yTopCoord(count-1)+boxSpace+yBoxLength;
    yBotCoord(count) = yTopCoord(count)+yBoxLength;
    
end


[MX, MY, buttons] = GetMouse(screenName);
ShowCursor;
responseConf = [];
countConf = [];

[keyIsDown, secs, keycode] = KbCheck(devID);

while 1
    
    [keyIsDown, secs, keycode] = KbCheck(devID);
    

    
    % Instructions
    Screen('TextSize',screenName,insTxtSize);
    Screen('DrawText',screenName,insText,x0-iWidth/2,iHeight/2,textColor);
    
    Screen('TextSize',screenName,50);
    for k=1:nConfList
        Screen('DrawText',screenName,confList{k},xNum(k),yNum(k),[0 0 0]);
    end
    
    Screen('FrameRect',screenName,[0 0 0],destRect);
    
    if ~isempty(countConf)
        Screen('FrameRect',screenName,[255 255 255],destRect(:,countConf),1);
    end
    Screen('Flip',screenName);
    
    [MX, MY, buttons] = GetMouse(screenName);
    for i=1:nConfList
        if buttons(1) == 1
            if MX>=xTopCoord(i) && MX<=xBotCoord(i) && MY>=yTopCoord(i) && MY<=yBotCoord(i)
                responseConf = i;
                countConf = i;
            end
        end
    end
    if keyIsDown
        if ~isempty(responseConf)
            break
        end
    end
end

HideCursor;
% 
% ListenChar(0);
% ShowCursor;
% 
% Screen('CloseAll');




