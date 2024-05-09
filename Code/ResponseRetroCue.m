function [responseLetCorrect, responseColCorrect, responseNumCorrect, responseLet, responseCol, responseNum, numList] = ResponseRetroCue(screenName,rectSize,devID,actualLetter,actualColor,actualNumber)

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

textColor = [256, 256, 256];
x0 = rectSize(3)/2;% screen center
y0 = rectSize(4)/2;

%%%%%%%%%%% Let and Col variables
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

%%%%%%%%%% Number Variables
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

%%%%%%%%%%%%%%% Spacing Variables
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










