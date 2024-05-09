function [responseLet] = ResponseLetters(screenName,rectSize)
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
% Instructions
% Screen('TextSize',w,20);
% text='Press any key to begin.';
% tWidth=RectWidth(Screen('TextBounds',w,text));
% Screen('DrawText',w,text,x0-tWidth/2,y0-50,textColor);
% Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
% Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
% Screen('Flip',w);
% KbWait(dev_ID);
% KbReleaseWait(dev_ID);

letList = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'};
nLetList = length(letList);
numList = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '0'};
boxLength = 100;    % Box width/height in pixels
boxSpace = 10;     % Distance between each box
xSideSpace = (rectSize(3)-((7*boxLength)+(6*boxSpace)))/2;    % Distance from the sides of the screen and start of the grid
ySideSpace = 10;

xTopCoord(1) = xSideSpace;
yTopCoord(1) = ySideSpace;
xBotCoord(1) = xTopCoord+boxLength;
yBotCoord(1) = yTopCoord+boxLength;

count = 1;
% Draw the first number of evenly spaced rows
for k=1:3
    for l=1:7 
        destRect(:,count) = [xTopCoord(count) yTopCoord(count) xBotCoord(count) yBotCoord(count)];
        
        Screen('TextSize',screenName,50);
        text = letList{count};
        tWidth = RectWidth(Screen('TextBounds',screenName,text));
        tHeight = RectHeight(Screen('TextBounds',screenName,text));
        xLet(count) = (xTopCoord(count)+(boxLength/2))-tWidth/2;
        yLet(count) = (yTopCoord(count)+(boxLength/2))-tHeight/2;
        
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

xTopCoord(count) = xTopCoord(count)+boxSpace+boxLength;
xBotCoord(count) = xTopCoord(count)+boxLength;
% Draw the last row with an odd amount of letters
for k=1:1
    for l=1:5
        
        destRect(:,count) = [xTopCoord(count) yTopCoord(count) xBotCoord(count) yBotCoord(count)];
        
        Screen('TextSize',screenName,50);
        text = letList{count};
        tWidth = RectWidth(Screen('TextBounds',screenName,text));
        tHeight = RectHeight(Screen('TextBounds',screenName,text));
        xLet(count) = (xTopCoord(count)+(boxLength/2))-tWidth/2;
        yLet(count) = (yTopCoord(count)+(boxLength/2))-tHeight/2;
        
        xTopCoord(count+1) = xTopCoord(count)+boxSpace+boxLength;
        xBotCoord(count+1) = xTopCoord(count+1)+boxLength;
        
        yTopCoord(count+1) = yTopCoord(count);
        yBotCoord(count+1) = yBotCoord(count);
        
        count=count+1;
    end
    xTopCoord(count) = xSideSpace;
    xBotCoord(count) = xTopCoord(count-1)+boxLength;
    
    yTopCoord(count) = yTopCoord(count-1)+boxSpace+boxLength;
    yBotCoord(count) = yTopCoord(count)+boxLength;
end


[MX, MY, buttons] = GetMouse;
ShowCursor;
while ~buttons(1)==1
    for k=1:nLetList
        Screen('DrawText',screenName,letList{k},xLet(k),yLet(k),[0 0 0]);
    end
    
    Screen('FrameRect',screenName,[0 0 0],destRect);
    Screen('Flip',screenName);
    
    [MX, MY, buttons] = GetMouse;
    responseLet = [];
    while ~isempty(responseLet)
        for i=1:length(xTopCoord)
            if buttons(1) ==1
                if MX>=xTopCoord(i) && MX<=xBotCoord(i) && MY>=yTopCoord(i) && MY<=yBotCoord(i)
                    responseLet =  i;
                end
            end
        end
    end
end

ShowCursor;
%
% ListenChar(0);
% ShowCursor;
% 
% Screen('CloseAll');

