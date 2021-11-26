
%% mouse demo 4 : On present une image, et on la bouge de gauche a droite avec les coordonee de la souris

% initialise lecran
Screen('Preference', 'SkipSyncTests', 1);
AssertOpenGL;
screens=Screen('Screens');
screenNumber=max(screens);

N = 2;


for trials = 1:N
    
    % la boucle commence ici
    
    [windowPtr,rect]=Screen('OpenWindow',screenNumber, 128);
    
    [xCenter, yCenter] = RectCenter(rect);
    
    HideCursor; % on cache la souris
    SetMouse(round(rect(3)/2), round(rect(4)/2));% on place la souris au centre pour commencer
    
    % on lit l'image avec imread, on trouve la taille et on la met pour ce
    % qu'on veut (ici on la divise par 2)
    im = imread('dune.png');
    %ici le col c'est la dimmension, on s'en sert pas mais si on ne le met pas il y a des erreurs avec size je crois
    [ySize xSize col] = size(im);
    xSize=xSize/2;% = 54.5
    ySize=ySize/2;% =54 , d'ou ySize/2 = 27,5
    im=imresize(im,[xSize ySize]);
    
    % donne les dimmensions de l'image
    imRect = [0 0 xSize ySize];
    
    resolution = Screen('Resolutions', screenNumber);
    % pour une raison que je ne comprends pas, cela représente 1/6 de rect
    xx=resolution.width;
    yy=resolution.height;
    
    % on cree la texture avec limage
    texturePtr = Screen('MakeTexture', windowPtr, im);
    
    % on definit les coordonnee du centre de l'image -> cette ligne ne sert pas dans le code mais elle aide à comprendre
    centerCoor = [round(xx - xSize/2) rect(4)-round(yy - ySize/2) round(xx - xSize/2) rect(4)-round(yy - ySize/2)];
    
    %dimmensions de la barre
    xdebutBarre = rect(3)/8;
    yBarre = rect(4)-round(yy - ySize);
    xfinBarre = rect(3)- rect(3)/8;
    
    
    % on fait un loop jusqu'a ce qu'on click (buttons == 1).
    buttons = 0;
    old_xCoor = 0;% commence a zero
    old_yCoor = 0;
    escapeKey = KbName('ESCAPE');
    exitDemo = false;
    
    
    while sum(buttons)==0
        %permet d'obtenir les coordonnées de la souris
        [xCoor, yCoor, buttons] = GetMouse;
        [keyIsDown,secs, keyCode] = KbCheck;
        
        if keyCode(escapeKey)
            sca;
        end
        
        if (old_xCoor ~= xCoor) || (old_yCoor ~= yCoor)
            old_xCoor = xCoor;
            old_yCoor = yCoor;
        end
        
        if xCoor < xdebutBarre %0
            xCoor = xdebutBarre; %0;
        elseif xCoor > xfinBarre; %screenXpixels
            xCoor = xfinBarre; %screenXpixels;
        end
        
        
        
        % on va aligner le centre de notre curseur sur yy => de part et d'autre de yy on a 27,5
        %destRect désigne l'endroit où le curseur s'affiche
        
        destRect = imRect + [xCoor-round(xSize/2) rect(4)-round(yy - ySize/2) xCoor-round(xSize/2) rect(4)-round(yy - ySize/2)];
        
        % imRect = [0 0 54.5 54] + [Xmouse - 27,5  Ypixels-(yy-27,5) Xmouse + 27,5 Ypixels-(yy-27,5)]
        %destRect = [Xmouse - 27,2, Ymin, Xmouse + 27,2, Ymax]
        % à noter que Ymax-Ymin= ySize (soit 54 ici)
        
        
        %On dessine la barre du curseur
        Screen('DrawLine', windowPtr, [0 0 0], xdebutBarre, yBarre, xfinBarre, yBarre, 30);
        Screen('DrawTexture', windowPtr, texturePtr, [], destRect, [],[],255);
        Screen('Flip', windowPtr);
        
        
    end
    sca;
    ShowCursor;
   
end