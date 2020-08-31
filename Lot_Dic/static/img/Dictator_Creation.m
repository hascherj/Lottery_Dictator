try
%% Operating System Check%%
    KbName('UnifyKeyNames');
    if IsOSX==1
        TopPriority=0;
        sysTxtOff=0; % no text adjustments needed
        ptbPipeMode=kPsychNeedFastBackingStore; % enable imaging pipeline for mac
    elseif IsWin==1
        TopPriority=1;
        sysTxtOff=1; % windows draws text from the upper left corner instead of lower left. To correct
        % an adjustment factor of 1*letterheight is subtracted from the y coordinate of
        % the starting point
        ptbPipeMode=[]; % don't need to enable imaging pipeline
    else
        ListenChar(0); clear screen; error('Operating system not OS X or Windows.');
    end %if ismac
    
    if IsWin==1
        skipSync = 0;
    else
        skipSync = 0; %if necessary to skip sync
    end %if ispc
    
    %%% Keys %%%
    Nkey=KbName('space');
    RAkey=KbName('space');
    Lkey=KbName('leftarrow');
    Rkey=KbName('rightarrow');
    Upkey=KbName('uparrow');
    Downkey=KbName('downarrow');
    escKey=KbName('w');
    expKey=KbName('e');
    sixkey=KbName('q');
    leftButton=[KbName('1!') KbName('1') KbName(',<') KbName('leftarrow')];
    rightButton=[KbName('2@') KbName('2') KbName('.>') KbName('rightarrow')];
    if IsOSX==1
        enterButton=[KbName('enter') KbName('return')];
    else
        enterButton=KbName('return');
    end %if ismac
    
    %%% Font %%%
    mainFont = 'Arial';
    scaleSize = 55;
    ticLength = 12;
    ticWidth = 6;
    crossSize = 50; %size of fixation cross
    
    %%% Colors %%%
    whitecolor = [255 255 255]; %white
    redcol = [157 0 0]; %[206 0 0];
    marooncol = [60 0 0];
    greencol = [0 120 0]; %[0 90 0]; %[0 119 0];
    bluecol = [0 0 255];
    yellowcol = [165 165 0]; %[157 47 0]; %[200 69 0];
    purpcol = [157 0 129]; %[238 0 100]; %[238 0 238];
    slatecol = [50 50 169];
    aquacol = [0 204 255];
    cyancol = [0 142 142];
    orangecol = [157 90 0]; %more of a gold%[220 150 0];
    lavendercol = [102 22 255]; %[238 121 159];
    pericol = [113 113 198];
    greycol = 150;
ListenChar(2); %suppress keyboard output
screenCap = 1;

%% Open Screen
Screen('Preference', 'SkipSyncTests', 1);
    %%% Screen Dimensions %%%
    screens = Screen('Screens'); %count the screen
    
    maxScreens = max(screens);
    [onScreen, screenRect] = Screen('OpenWindow', maxScreens); % Open the second window
    
    %[ScreenX, ScreenY] = WindowSize(onScreen);
    ScreenX = screenRect(3);
    ScreenY = screenRect(4);
    cx=(ScreenX/2); %Middle of screen on X-axis
    cy=(ScreenY/2); %Middle of screen on Y-axis
    quadX = ScreenX/4; % the middle of the left half of the screen
    
    ScreenRect = [0 0 ScreenX ScreenY]; %Rectangle = size of whole display
    
    %%% Screen Visuals %%%
    fixX=cx;
    fixY=cy;
    bcolor = 0;
    greyCol = 150;
    fixCol = 255;
    fizSize = 25;
    fixThresh = 75; % can look 50 pixels away from fixation before it gets mad
    
        
    
    %Rectangles and Frame
    exampleLeft = [0+(ScreenX/16); cy-0*(ScreenY/16);cx-(ScreenX/16);cy+(5*(ScreenY/16))];
    wouldnoteatbox = [cx-150 round(ScreenY*0.85) cx+150 round(ScreenY*0.95)];

    
    
    Screen('FillRect', onScreen, [0 0 0]); % Make the screen black
    HideCursor;
    Screen('BlendFunction', onScreen, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    Screen('Flip', onScreen);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TASKS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    line1 = 'Press spacebar';
    
    % Draw all the text in one go
    Screen('TextSize',onScreen,scaleSize);
    DrawFormattedText(onScreen, line1,'center', ScreenY * 0.25, whitecolor, [], [], [], 1.5);
    
    Screen('Flip', onScreen);
    
    %Wait for button press
    while KbCheck
    end
    
    FlushEvents('keyDown');
    proceed = 0;
    while proceed == 0
        [keyIsDown, secs, keyCode] = KbCheck(-1);
        if keyIsDown
            if keyCode(escKey)
                ListenChar(0); clear screen; error('User terminated script with ESCAPE key.')
            elseif keyCode(RAkey)
                proceed = 1;
            end
        end
    end %while proceed
    
    WaitSecs(.1);
    
    while KbCheck % prevent keypress carryover from previous trials
    end
    
%% Actual Box Creation

%Values (out of 100) for the boxes
topVal = [65, 70, 75, 80, 85, 90, 95];
botVal = [35, 30, 25, 20, 15, 10, 5];

topBox = [(3/8)*ScreenX, (1/9)*ScreenY, (5/8)*ScreenX,(4/9)*ScreenY];
botBox = [(3/8)*ScreenX, (5/9)*ScreenY, (5/8)*ScreenX,(8/9)*ScreenY];

for i = 1:length(topVal)
    me = num2str(topVal(i));
    you = num2str(botVal(i));
    slash = '_';
    cond = [me slash you]; 
    
    Screen('FrameRect', onScreen, whitecolor, topBox, 4);
    Screen('FrameRect', onScreen, whitecolor, botBox, 4);
    
    topFilling = (topVal(i)/100)*(topBox(4)-topBox(2));
    botFilling = (botVal(i)/100)*(botBox(4)-botBox(2));
    
    topFill = [(3/8)*ScreenX+4, (4/9)*ScreenY-topFilling, (5/8)*ScreenX-4,(4/9)*ScreenY-2];
    botFill = [(3/8)*ScreenX+4, (8/9)*ScreenY-botFilling, (5/8)*ScreenX-4,(8/9)*ScreenY-2];
    
    Screen('FillRect', onScreen, bluecol, topFill);
    Screen('FillRect', onScreen, redcol, botFill);
    
    Screen('Flip', onScreen);
    
    %Take a pretty picture
    if screenCap == 1
                capSizeX=ScreenX; capSizeY=ScreenY;
                image=Screen('GetImage', onScreen, [cx-capSizeX/4 cy-(5/12)*capSizeY cx+capSizeX/4 cy+(5/12)*capSizeY]);
                imgname=[cond '.jpg'];
                imwrite(image, imgname, 'jpg');
    end
    
    
    %Wait for button press
    while KbCheck
    end
    
    FlushEvents('keyDown');
    proceed = 0;
    while proceed == 0
        [keyIsDown, secs, keyCode] = KbCheck(-1);
        if keyIsDown
            if keyCode(escKey)
                ListenChar(0); clear screen; error('User terminated script with ESCAPE key.')
            elseif keyCode(RAkey)
                proceed = 1;
            end
        end
    end %while proceed
    
    WaitSecs(.1);
    
    while KbCheck % prevent keypress carryover from previous trials
    end
    
end
%% End
    ListenChar(0);
    sca
    fclose('all');
    ShowCursor;
    Screen('CloseAll')
catch err  %quit out if the code encounters an error
    disp('There is an ERROR!');
    
    
    ListenChar(0); %restore normal keyboard use
    
    sca
    fclose('all');
    ShowCursor;
    Screen('CloseAll')
    rethrow(err);
end