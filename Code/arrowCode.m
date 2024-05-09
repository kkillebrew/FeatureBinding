close all;
clear all;

ListenChar(2);
HideCursor;
backColor = 128;
textColor = [256, 256, 256];

rect=[0 0 1024 768];     % test comps
[w,rect]=Screen('OpenWindow', 0,[backColor backColor backColor],rect);
x0 = rect(3)/2;% screen center
y0 = rect(4)/2;

rectArray = zeros(5,5);
t=Screen('MakeTexture',w,rectArray);

% destRect=[((x0-xCenter(m)*cos((i*pi)/(trialsDotAmount(n,m)/2)+shift(m)))-(radius(m))),...
%     ((y0-yCenter(m)*sin((i*pi)/(trialsDotAmount(n,m)/2)+shift(m)))-(radius(m))),...
%     ((x0-xCenter(m)*cos((i*pi)/(trialsDotAmount(n,m)/2)+shift(m))+(radius(m)))),...
%     ((y0-yCenter(m)*sin((i*pi)/(trialsDotAmount(n,m)/2)+shift(m))+(radius(m))))];

length = 50;

[keyIsDown, secs, keycode] = KbCheck;
while ~keyIsDown
    [keyIsDown, secs, keycode] = KbCheck;
    
    destRect = [((x0*cos(.5*pi)/(4/2))-length) ((y0*sin(.5*pi)/(4/2)-length)) ((x0*cos(.5*pi)/(4/2))+length) ((y0*sin(.5*pi)/(4/2)+length))];
    Screen('DrawTexture',w,t,[],destRect,);
    Screen('Flip',w);
    
end

ListenChar(0);
ShowCursor;
Screen('CloseAll',w);