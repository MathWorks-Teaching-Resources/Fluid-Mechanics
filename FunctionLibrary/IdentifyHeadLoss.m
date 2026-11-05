function IdentifyHeadLoss()

    load HeadLossData.mat

    figure
    
    img = imshow(img);
    img.UserData.guessesCounter = 0;
    img.UserData.headLossesFlag = zeros(size(boxes,1),1);
    img.UserData.originalImage = img.CData;
    img.UserData.hintCounter = 1;
    img.UserData.boxes = boxes;
    img.UserData.label = label;
    img.ButtonDownFcn = @(src,event)CallbackFcnIdentifyHeadLoss(src,event);
    img.CData(:,:,1) = rgb2gray(img.UserData.originalImage);
    img.CData(:,:,2) = rgb2gray(img.UserData.originalImage);
    img.CData(:,:,3) = rgb2gray(img.UserData.originalImage);

    disableDefaultInteractivity(gca)

    subtitle("Identify the head losses in the system by clicking on them")
    img.Parent.Subtitle.Visible = "on";

end

%%
function CallbackFcnIdentifyHeadLoss(src,event)

if ~all(src.UserData.headLossesFlag)
   
    
    % Update the guess counter:
    src.UserData.guessesCounter = src.UserData.guessesCounter + 1;
   
    % Load the head losses data:
    boxes = src.UserData.boxes;
    % label = src.UserData.label;

    % Hints = ["Flow through pipe is associated with some head-losses";
    %     "Every pipe fitting such as elbows and tees are associated with some head-losses";
    %     "Orifice such as the washer and the shower-head are also associated with some head-losses";
    %     "Perfect fluid flow does not exist, everything introduces head-losses."];

    xc = [ floor(event.IntersectionPoint(1))  floor(event.IntersectionPoint(2)) ];
    idx = boxes(:,1) <= xc(1) & xc(1) <= boxes(:,1)+boxes(:,3) ...
        & boxes(:,2) <= xc(2) & xc(2) <= boxes(:,2)+boxes(:,4);
    idx = find(idx);
    src.UserData.headLossesFlag(idx) = 1;

    if ~isempty(idx)
        for i = 1:size(idx)
            rc = boxes(idx(i),:);
            xl = [rc(2):rc(2)+rc(4)]; xl(xl > size(src.CData,1)) = []; xl(xl < 1) = []; xl = floor(xl);
            yl = [rc(1):rc(1)+rc(3)]; yl(yl > size(src.CData,2)) = []; yl(yl < 1) = []; yl = floor(yl);
            src.CData(xl,yl,:) = src.UserData.originalImage(xl,yl,:);
        end
    else
        % Update miss counter and display hint
    end
    
    src.Parent.Subtitle.String = "Head Losses found: "...
        + num2str(nnz(src.UserData.headLossesFlag))...
        +"/"+num2str(length(src.UserData.headLossesFlag));
    
    if all(src.UserData.headLossesFlag)
        src.CData = src.UserData.originalImage;
        src.Parent.Subtitle.String = "Congratulation! You have identified all the head losses correctly!";
    end

end

end

%[appendix]{"version":"1.0"}
%---
