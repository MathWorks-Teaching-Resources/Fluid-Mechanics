%[text] # Draw Saturn Rocket
%[text] The `DrawSaturn(opts)` function is used throughout [ManOnTheMoon.m](file:../Scripts/ManOnTheMoon.m) to plot the Saturn V rocket and all the details coming from the question in this script.
%[text] **Input Arguments:**
%[text] - `ControlVolume (integer)`
%[text] - `DrawFootball (logical)` 
%[text] - `Highlight (string)`
%[text] - `NormalVector (logical)`
%[text] - `Gravity (logical)`
%[text] - `ZoomIn (logical)`
%[text] - `DrawExhaustVelocity (logical)`
%[text] - `DrawExhaustMassFlow (logical)`
%[text] - `WriteExhaustVelocity (logical)`
%[text] - `WriteExhaustMassFlow (logical)`
%[text] - `WriteMass (logical)`
%[text] - `DrawThrust (logical)`
%[text] - `DrawAcceleration (logical)`
%[text] - `PathAngle (scalar)`
%[text] - `WriteEquation (string)` \
%[text] **Example:**
%[text] `DrawSaturn(ZoomIn=true, DrawExhaustVelocity=true, WriteExhaustVelocity=true)`
%[text]{"align":"center"} ![](text:image:1ea1)
function ax = DrawSaturn(opts)
    arguments
        opts.ControlVolume (1,1) uint8 {mustBeMember(opts.ControlVolume, [0 1 2 3])} = 0 
        opts.DrawFootball (1,1) logical = false
        opts.Highlight (1,1) string {mustBeMember(opts.Highlight, ["none" "CV" "CSR" "CSL" "CSB"])} = "none"
        opts.NormalVector (1,1) logical = false
        opts.Gravity (1,1) logical = false
        opts.ZoomIn (1,1) logical = false
        opts.DrawExhaustVelocity (1,1) logical = false
        opts.DrawExhaustMassFlow (1,1) logical = false
        opts.WriteExhaustVelocity (1,1) logical = false
        opts.WriteExhaustMassFlow (1,1) logical = false
        opts.WriteMass (1,1) logical = false
        opts.DrawThrust (1,1) logical = false
        opts.DrawAcceleration (1,1) logical = false
        opts.PathAngle (1,1) double = 0 % (degree)
        opts.WriteEquation (1,1) string = ""
    end

    % Define the axis:
    f = figure;
    ax = axes(f);
    xlabel(ax,"Horizontal axis (m)")
    ylabel(ax,"Vertical axis (m)")
    axis equal
    ColorHighlight = ax.ColorOrder(3,:);

    % Plot Control Volume background for config A and C:
    if opts.ControlVolume == 1 || opts.ControlVolume == 3
        CV = patch([-40 40 40 -40],[0 0 120 120],ax.ColorOrder(1,:),FaceAlpha=0.2, ...
            LineStyle="none",DisplayName='Control Volume');
        CV.Annotation.LegendInformation.IconDisplayStyle = 'off';
        CS = line([-40  40],[120 120],Color=ax.ColorOrder(1,:),LineWidth=2,LineStyle="--");
        CS.Annotation.LegendInformation.IconDisplayStyle = 'off';
        CS = line([ 40  40],[  0 120],Color=ax.ColorOrder(1,:),LineWidth=2,LineStyle="--");
        CS.Annotation.LegendInformation.IconDisplayStyle = 'off';
        CS = line([-40 -40],[  0 120],Color=ax.ColorOrder(1,:),LineWidth=2,LineStyle="--");
        CS.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end 
    
    % Define the rocket shape:
    xR = [0 5 5  3.3 3.3 2.0 2.0 1.14 1.14 0.63 0.63  0  ]; % (m) x-position
    yR = [0 0 64 70  82  91  95  98   101  103  110.5 112]; % (m) y-position
    xC = 0.5*(xR(2:end-1)+xR(3:end));
    yC = 0.5*(yR(2:end-1)+yR(3:end));
    nC = [xR(3:end)-xR(2:end-1); yR(3:end)-yR(2:end-1)];
    nC = nC ./ vecnorm(nC);

    % Plot the rocket background:
    if opts.Highlight ~= "CV"
        patch([-xR flip(xR(2:end))],[yR flip(yR(2:end))],[0.7 0.7 0.7], ...
            EdgeColor="none",DisplayName='Saturn V');
    else
        patch([-xR flip(xR(2:end))],[yR flip(yR(2:end))],ColorHighlight, ...
            EdgeColor="none",DisplayName='Saturn V');
    end
    
    
    % Plot right Control Surface:
    CSR = line(xR(2:end),yR(2:end),Color=[0 0 0],LineStyle="-",LineWidth=2);
    CSR.Annotation.LegendInformation.IconDisplayStyle = 'off';
    if opts.Highlight == "CSR"
        CSR.Color = ColorHighlight;
        CSR.Annotation.LegendInformation.IconDisplayStyle = 'on';
        CSR.DisplayName = "Right Control Surface";
    elseif opts.ControlVolume == 1 || opts.ControlVolume == 2
        CSR.Color = ax.ColorOrder(1,:);
        CSR.LineStyle = "--";
    end

    % Plot left Control Surface:
    CSL = line(-xR(2:end),yR(2:end),Color=[0 0 0],LineStyle="-",LineWidth=2, ...
        DisplayName='');
    CSL.Annotation.LegendInformation.IconDisplayStyle = 'off';
    if opts.Highlight == "CSL"
        CSL.Color = ColorHighlight;
        CSL.Annotation.LegendInformation.IconDisplayStyle = 'on';
        CSL.DisplayName = "Left Control Surface";
    elseif opts.ControlVolume == 1 || opts.ControlVolume == 2
        CSL.Color = ax.ColorOrder(1,:);
        CSL.LineStyle = "--";
    end
    

    % Plot bottom Control Surface:
    CSB = line([-xR(2) xR(2)],[yR(2) yR(2)],Color=[0 0 0],LineStyle="-",LineWidth=2);
    CSB.Annotation.LegendInformation.IconDisplayStyle = 'off';
    if opts.Highlight == "CSB"
        CSB.Color = ColorHighlight;
        CSB.Annotation.LegendInformation.IconDisplayStyle = 'on';
        CSB.DisplayName = "Bottom Control Surface";
    elseif opts.ControlVolume == 2
        CSB.Color = ax.ColorOrder(1,:);
        CSB.LineStyle = '--';
    end

    RotZ = @(x) [cosd(x) -sind(x) 0.0;...
                 sind(x)  cosd(x) 0.0;...
                 0.0      0.0     1.0]; 
    % Plot Vector normal:
    if opts.NormalVector && opts.Highlight ~= "none"
        switch (opts.Highlight)
            case "CSR"
                NormalPosition = [xC; yC; 0*yC];
                NormalDirection = 15*RotZ(-90)*[nC(1,:); nC(2,:); 0*nC(2,:)];
            case "CSL"
                NormalPosition = [-xC; yC; 0*yC];
                NormalDirection = 15*RotZ(-90)*[nC(1,:); nC(2,:); 0*nC(2,:)];
                NormalDirection(1,:) = -NormalDirection(1,:); 
            case "CSB"
                if (opts.ZoomIn)
                    NormalPosition = [0 0 0]';
                    NormalDirection = [0 -3 0]';
                else
                    NormalPosition = [0 0 0]';
                    NormalDirection = [0 -20 0]';
                end
        end
        NormalPosition = RotZ(-opts.PathAngle)*NormalPosition;
        NormalDirection = RotZ(-opts.PathAngle)*NormalDirection;
        hold on
        quiver(NormalPosition(1,:),NormalPosition(2,:),NormalDirection(1,:), ...
            NormalDirection(2,:),0,AutoScale="off",LineWidth=2,Color=ColorHighlight, ...
            MaxHeadSize=0.5,DisplayName="$\vec{n}$");
        hold off
    end

    % Draw football field
    if opts.DrawFootball
        xF = [40 89 89 40];
        yF = [0 0 9.1 9.1]; % 9.1 meters = 10 yards
        patch(xF,yF,ax.ColorOrder(7,:))
        for i = 1:10
            yF = yF + 9.1;
            patch(xF,yF,ax.ColorOrder(5,:))
            if i ~= 1
                text(42.5,i*9.1,(i-1)+" 0",Rotation=90,Color="w",HorizontalAlignment="center",FontWeight="bold")
                text(86.5,i*9.1,(11-i)+" 0",Rotation=-90,Color="w",HorizontalAlignment="center",FontWeight="bold")
            end
        end
        yF = yF + 9.1;
        patch(xF,yF,ax.ColorOrder(7,:))
    else
        legend(Location="bestoutside",Interpreter="latex")
    end
    
    % Draw Arrows Out for Exhaust Velocity (requires zoom in bottom)
    if opts.DrawExhaustVelocity && opts.ZoomIn
        hold on 
        x_Ue = [-4:-1 1:4];
        y_Ue = 0*x_Ue;
        u_Ue = 0*x_Ue;
        v_Ue = u_Ue - 2;
        q_Ue = quiver(x_Ue,y_Ue,u_Ue,v_Ue,AutoScale="off",LineWidth=2, ...
            Color=ax.ColorOrder(1,:),MaxHeadSize=0.5,DisplayName="$\vec{u}$");
        if opts.WriteExhaustVelocity
            q_Ue.DisplayName = "$\vec{u} = -u_e\cdot\vec{e_y}$";
        end
    end
    
    % Draw Box out for Exhaust Mass Flow (requires zoom in bottom)
    if opts.DrawExhaustMassFlow && opts.ZoomIn
        p_Me = patch([-5 5 5 -5],[-2 -2 0 0],ax.ColorOrder(1,:),FaceAlpha=0.2,LineStyle="none");
        l_Me = line([-5 -5 5 5],[0 -2 -2 0],Color=ax.ColorOrder(1,:),LineStyle="--",LineWidth=2);
        p_Me.Annotation.LegendInformation.IconDisplayStyle = 'off';
        l_Me.Annotation.LegendInformation.IconDisplayStyle = 'off';
        if opts.WriteExhaustMassFlow
            p_Me.Annotation.LegendInformation.IconDisplayStyle = 'on';
            p_Me.DisplayName = "$\dot{m}_e$";
        end
    end
    
    if opts.PathAngle ~= 0
        l = line([0 0],[-10 130],LineStyle="-.",Color="k");
        l.Annotation.LegendInformation.IconDisplayStyle = 'off';
        hl = line([0 0],[0 yR(end)+20],LineStyle="-.",Color="k");
        rotate(hl,[0 0 1],opts.PathAngle,[0 yR(end) 0])
        hl.Annotation.LegendInformation.IconDisplayStyle = 'off';
        i = linspace(0,opts.PathAngle, 100);
        x = 80*cosd(i-90);
        y = 80*sind(i-90)+yR(end);
        hold on
        p = plot(x,y,"k-");
        p.Annotation.LegendInformation.IconDisplayStyle = 'off';
        hold off
        text(mean(x),mean(y)-4,"$\alpha$",Interpreter="latex",FontSize=14)    
        child = allchild(ax);
        rotate(child,[0 0 1],-opts.PathAngle,[0 0 0])
    end

    if opts.WriteMass
        text(0, 2.5,"$m(t)$",Interpreter="latex",HorizontalAlignment="center",FontSize=14)
    end
   
    if opts.DrawThrust
        xPos = [0 0];
        if opts.ZoomIn
            xDir = [0 2];
        else
            xDir = [0 20];
        end
        hold on
        quiver(xPos(1),xPos(2),xDir(1),xDir(2),0,AutoScale="off",LineWidth=2,...
            Color=ax.ColorOrder(7,:),MaxHeadSize=0.5,DisplayName="$\vec{F}_{Thrust}$")
        hold off
    end

    if opts.DrawAcceleration
        xPos = [0 0];
        if opts.ZoomIn
            xDir = [0 -3];
        else
            xDir = [0 -20];
        end
        hold on
        quiver(xPos(1),xPos(2),xDir(1),xDir(2),0,AutoScale="off",LineWidth=2, ...
            Color=ax.ColorOrder(5,:),MaxHeadSize=0.5,DisplayName="$\vec{F}_{Acceleration}$");
        hold off
    end

    if opts.Gravity
        xPos = [2 4];
        if opts.ZoomIn
            xDir = [0 -3];
        else
            xDir = [0 -20];
        end
        hold on
        quiver(xPos(1),xPos(2),xDir(1),xDir(2),0,AutoScale="off",LineWidth=2, ...
            Color="k",MaxHeadSize=0.5,DisplayName="$\vec{g}$");
        hold off
    end

    if opts.ControlVolume == 1
        l = line([ 5  40],[0 0],Color=ax.ColorOrder(1,:),LineWidth=2,LineStyle="--");
        l.Annotation.LegendInformation.IconDisplayStyle = 'off';
        l = line([-5 -40],[0 0],Color=ax.ColorOrder(1,:),LineWidth=2,LineStyle="--");
        l.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    if opts.ControlVolume == 3
        l = line([-40 40],[0 0],Color=ax.ColorOrder(1,:),LineWidth=2,LineStyle="--");
        l.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    
    % change the plotting limit if zooming onto the bottom of the rocket:
    if opts.ZoomIn
        ylim([-5 5])
    end
end

%[appendix]{"version":"1.0"}
%---
%[text:image:1ea1]
%   data: {"align":"baseline","height":357,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAA0gAAAJ2CAIAAADqgjXlAAA750lEQVR42u3df2yUaYLY+fmRzGWjyya5KFFOFyW3\/6Aty2vHa3SOkWVhIRYhkA9HHC1k0kKIWCAWJA8MAbGo02qWbTUrxIaAUGvSCyFNnJiwLSPLZ3nweCBuNevB2+shFgvnM4PWDGvk81qW3ZbHFvcM71BTlO1yAcb1vu7PRwhVvS5XvX7eqnq\/VfW+b33jGQAAK8I3DAEAgLADAEDYAQAg7AAAEHYAAMIOAABhBwCAsAMAQNgBAAg7AACEHQAAwg4AAGEHAICwAwAQdgAACDsAAIQdAADCDgBA2AEAIOwAABB2AAAIOwAAYQcAgLADAEDYAQAg7AAAEHYAAMIOAABhBwCAsAMAQNgBAAg7AACEHQAAwg4AAGEHACDsAAAQdgAACDsAAIQdAADCLh8zMzMTc0xNTRkZAEDYJczx48dXzdHY2GhkAABhlzA7d+4sLi4+9rKmpiYjAwAIu4QJVbd7927jAAAIu2R79OjRqlWrPvzwQ0MBAAi7ZGtvbw9hF\/7v6em5fPny1atX+\/v7DQsAIOyS59SpUyHsqqurM\/ecOHz48MzMjMEBAIRdkuzbty+U3J49e+7fvz89Pd3b27t169Yw5cSJE7l\/ce6OtEn88wcHB9e+sG3bts8B+Dr53d\/93fRa4Ic\/\/KEqEHaJd\/v27ZaWlswp4+PjlZWVRUVFY2NjucNuBfz54WH8jRd+67d+6zoAXyfhmT+9FhB2wm7FOnToUOi2zs5OYQeAsEPYJduxY8dCt924cUPYASDsEHbJMD09XV9fv3\/\/\/qzpe\/fuDd02ODgo7AAQdgi7xKipqUmlUpkNd\/\/+\/TClrq4u9y8KOwCEHcIuXjo6OqLDnVy7dq27u7u5ubmysrK0tPTevXvCDgBhh7BLmPb29rVr16aPWlJbW9vX17fobwk7AIQdwi6mBgYGuru7nzx5kuflhR0Awg5ht0IIOwCEHcJO2Ak7AIQdwk7YCTsAhB3CTtgJOwCEnbBD2AEg7BB2wk7YASDsEHbCTtgBIOwQdsJO2AEg7IQdwg4AYYewE3bCDgBhh7ATdsIOAGGHsBN2wg4AYSfsEHbCDgBhJ+wQdgAIO4SdsBN2AAg7hJ2wE3YACDuEnbATdgAIO2GHsANA2CHshJ2wA0DYIeyEnbADQNgh7ISdsANA2Ak7hJ2wAxB2Vu7CTtgJOwCEHcJO2Ak7AIQdwk7YCTsAhB3CTtgJOwCEnbBD2AEg7BB2wk7YASDsEHbCTtgBIOwQdsJO2AEg7IQdwg4AYYewE3bCDgBhh7ATdsIOAGGHsBN2wg4AYSfsEHbCDkDYCTthJ+yEHQDCDmEXZ8PDwx0dHSMjI8IOAGGHsEu27du3h2Lr7u4WdgAIO4Rdgl24cGHVc8IOAGGHsEuw\/v7+VCpVUVEh7AAQdgi7BJuamtqwYUN9ff37778v7AAQdgi7BAs9V15e\/uTJE2EHgLBD2CVYZ2dnqLSWlpao8PIPuyzCDgBhh7ArpJGRkcrKygMHDqTfuvOOHQDCDmGXSA0NDVVVVaOjo8JO2AEIO4Rdgl25ciX02c2bNzM3thN2AAg7hF0i365btbD023jCDgBhh7CLu0uXLh172caNG0Ox7d69O5yemJgQdgAIO4RdUvkoFgBhh7ATdsIOAGGHsBN2wg4AYYewKyBhB4CwQ9gJO2EHgLBD2Ak7YQeAsEPYCTthB4CwE3YIOwCEHcJO2Ak7AIQdwk7YCTsAhB3CTtgJOwCEnbBD2AEg7BB2wk7YASDsEHbCTtgBIOwQdsJO2AEg7IQdwk7YASDshB3CDgBhh7ATdsIOAGGHsBN2wg4AYYewE3bCDgBhJ+wQdgAIO4SdsBN2AAg7hJ2wE3YACDuEnbATdgAIO2GHsBN2AMLOyl3YCTthB4CwQ9gJO2EHgLBD2Ak7YQeAsEPYCTthB4CwE3YIOwCEHcJO2Ak7AIQdwk7YCTsAhB3CTtgJOwCEnbBD2AEg7BB2wk7YASDsEHbCTtgBIOwQdsJO2AEg7IQdwk7YAQg7YSfshJ2wA0DYIexiaHJysrOzs62t7csvvxR2AAg7hF1SXbt2rbS0dNULGzdufPDggbADQNgh7BKmu7s7JNqWLVv6+vqmpqZaW1tXr15dVVU1MTEh7AAQdgi7JNmxY0cqlXr8+HF6yuXLl0O0hbu7sANA2CHskqSlpeXMmTOZUzo6OkK0nT9\/XtgBIOwQdsl2\/PjxEG09PT3CDgBhh7BLpAcPHrS2tu7atSsU24kTJxa9\/Ko5hB0Awg5hFwtHjhyJ+qy6uvr6YhvYeccOAGGHsIuv0dHR2dnZgYGBnTt3hmg7d+6csANA2CHskm1qaqqysrKoqGhmZkbYASDsEHbJduDAgdBtt2\/fFnYACDuEXTJMT0+vXbt2z549WdMbGhpCtz18+FDYASDsEHaJsWnTplQqldlw9+\/fD1M2bNhgGzsAhB3CLklu3boV7Qn72WefdXd3NzU1RRvY5f4cVtgBIOwQdnHU1dW1du3a9OHoamtre3t7F\/0tYQeAsEPYxdTg4GB3d\/fw8HCelxd2AAg7hN0KIewAEHYIO2En7AAQdgg7YSfsABB2CDthJ+wAEHbCDmEHgLBD2Ak7YQeAsEPYCTthB4CwQ9gJO2EHgLATdgg7AIQdwk7YCTsAhB3CTtgJOwCEHcJO2Ak7AISdsEPYCTsAhJ2wQ9gBIOwQdsJO2AEg7BB2wk7YASDsEHbCTtgBIOyEHcIOAGGHsBN2wg4AYYewE3bCDgBhh7ATdsIOAGEn7BB2wg5A2Fm5CzthJ+wAEHYIO2En7AAQdgg7YSfsABB2CDthJ+wAEHbCDmEHgLBD2Ak7YQeAsEPYCTthB4CwQ9gJO2EHgLATdgg7AIQdwk7YCTsAhB3CTtgJOwCEHcJO2Ak7AISdsEPYCTsAYSfshN3KMj093dXV1draeuPGjYmJCWEHgLBD2CVSc3NzWVnZqheKioo+\/vhjYQeAsEPYJUxHR0dItLq6up6enqmpqbt379bX14cpn376qbADQNgh7JIkJF1RUdHo6Gh6ysTERHl5eU1NjbADQNgh7JJk69atDQ0NWRPDlEW7TdgBIOwQdnE3Ozu7Zs2asrIyYQeAsEPYJdsnn3wSou3kyZPCDgBhh7BLsJs3bxYVFdXU1IyNjS0adlmEHQDCDmEXFx0dHcXFxZWVlYODg4te2Dt2AAg7hF1MXbhwIbRaTU3N0NBQPpcXdgAIO4RdHB09ejSE2rZt20ZGRvL8FWEHgLBD2MXO\/v37Q6Xt27dvamoq\/98SdgAIO4RdvJw\/fz4kWmNj46v+orADQNgh7GJkZGSkuLg4JNrevXsb55iZmRF2AAg7hF0ytLW1rVrY9PS0sANA2CHsVj5hB4CwQ9gJO2EHgLBD2Ak7YQeAsEPYCTthB4CwE3YIOwCEHcJO2Ak7AIQdwk7YCTsAhB3CTtgJOwCEnbBD2AEg7BB2wk7YASDsEHbCTtgBIOwQdsJO2AEg7IQdwk7YASDshB3CDgBhh7ATdsIOAGGHsBN2wg4AYYewE3bCDgBhJ+ziZ2ZmZmho6O7dux988EF9ff3ly5fv378\/MjIi7IQdAMJO2CVGb2\/vunXrVi2gtLT06NGjo6Ojwk7YASDshF18tbe3l5WVRQFXXl6+YcOG7du3Nzc337lz59q1a3V1dTU1NalUKrpA+NHY2JiwE3YACDthFy+Tk5ObN28O\/VRVVRUaLnexDQ0N7d69O8q7s2fPCjthB4CwE3YxEsqpurp6cHAw\/1+ZnZ09d+5c+MW9e\/cKO2EHgLATdnFx48aN1\/7dixcvCjthB4CwE3YIOwCEHcJO2Ak7AIQdwm5RT58+3bBhw+rVq0vnU1ZWJuyEHQDCTtglwNjY2KqcUqmUsBN2AAg7YZcA7733Xgipw4cPT0xM+ChW2AEg7Ehw2EUHtJuamrKNnbADQNiR7LBrbGwMITUzMyPshB0Awo5kh93w8HAIqZaWFmEn7AAQdiQ77ILLly9HXxcWIm9kPsJO2AEg7IRdMjQ1NdkrVtgBIOxIfNgNDQ1FAVdRUbF27dqaOdatWyfshB0Awk7YJUB9fX0IqXAXtI2dsANA2JHssIsOd2KvWGEHgLAj8WF36tSpEFLxOTqxsANA2CHsXtPU1FQIqePHj7\/tG+ru7n706JGwA0DYIezeohs3boSWqq6u\/vDDD+\/evds\/x5vfxBdffBFuorm5WdgBIOwQdm9LX1\/fqpze\/HAnt2\/fLi8vF3YACDuE3VsPu+051dfXv\/aVT09Pnzt3LqRhcXGxsANA2CHsEqyhoSFU2p49e6JjIAs7AIQdwm6JDQwMvPbv3rp1K\/8Lnz59Orp8R0eHsANA2CHsll4op507d46Pj7\/Sb3V2dpaXl2\/fvv01bvFVwy6LsANA2CHsFnzHrqysLATTxo0bHz58mPvCo6Oj586diy7f2Nj4erfoHTvPcQDCDmH3Fp09ezb9lti6desaGhr6+voePHgQsi\/8H+6UW7ZsqaioiC5QVVUVJr72bQk7z3EAwg5h93bNzMx8\/PHHq1evznG4kw0bNuR5YGFhJ+wAEHbCrvCePn169+7dvXv31tbWbtq0aevWrU1NTYODg9PT00ty\/cLOcxyAsEPYrRDCznMcgLBD2Ak7YQeAsEPYCTthB4CwQ9gJO2EHgLATdiwBYQeAsEPYCTthB4CwQ9gJO2EHgLBjpYbd2NjY7OyssBN2AAg7YZcwFy9ePHz4cHS6p6enpKQk+tqJDz74QNgJOwCEnbBLjK1bt0ZfHZbuqmD16tWpVCqcOHv2rLATdgAIO2GXAIODgyGktmzZMjQ0FM729\/eHs2vXro1+WlFRUVRUJOyEHQDCTtglQGNjYwipycnJ6OymTZvC2e7u7uhsW1tbOPv06VNhJ+wAEHbCLu5qa2tLSkrSZ0tLS0NXjY2NRWcHBgbC2ejNPGEn7AAQdsIu1urq6lKpVHR6eHg4RFVFRUX6p83Nzd6xE3YACDthlwzRl311dnaG04cOHQqnP\/zww+hHs7OzJSUl6ewTdsIOAGEn7OIu2g22rKwsOjE+Ph4mHjx4MDp76tQpYSfsABB2wi4ZQsnV1NSkUqmKiorbt29HE6OwO3HiREFCU9gBIOwQdktpamqqUO8gCjsAhB3CbiUQdgAIO4Rdvvqfyzqbg7ATdgAIO2EXUzU1NSGeent7w+m+vr5VOdkrVtgBIOyEXXwdOXJkx44d6bDbkdO7774r7IQdAMJO2CHshB2AsBN2wm65LLrr69mzZ4WdsANA2Am7BOjr66uoqIgOSpxlcnJy3bp1trETdgAIO2GXmLCLdpK4evVq5vTPPvssmr5mzRphJ+wAEHbCLhmam5ujhmtoaIim7Nq1K5qy\/J\/DCjsAhB3C7o2MjY2tWbMmFFVJSUkqlQonKisrR0ZGCjIzwg4AYYewe1O7d++O3qhb\/kOcCDsAhB3CbsnesVu\/fn3mcYnXrFnjHTthB4CwE3YJc\/78+SjmtmzZMj09bRs7YQeAsCPZe8V+\/\/vfz5we7pTR9KqqKmEn7AAQdsIuGWG3evXqp0+fzv3R5OTkxo0bHcdO2AEg7IRdMszOzi76Qa2wE3YACDthh7ATdgDCTtgJu9hY9MtkhZ2wA0DYCbsYuXDhwubNmze8bN26dVVVVbaxE3YACDthlxjl5eWrFrZ69WphJ+wAEHbCLgF6e3tDSJWVlQ0MDESHPgl3x6Ghoba2tqKiojDdNnbCDgBhJ+ySoa6uLoRU+ksmSktLN2\/enNlYJ06cEHbCDgBhJ+wSYNOmTcXFxemzNTU1lZWV6bOffPJJUVHRm1z\/7Oxsd3d3a2tr+H\/RQ6sIOwCEHcLujd6xywy7rVu3ZnbVo0ePwtl5D1+cj76+vlCK6c31wun+\/n5hB4CwQ9i9FZcuXQohNTo6Gp29cuVKODs8PBydHRwcDGeHhoZe45rHxsYqn+vq6pqammpvbw+nq6qqxsfHhR0Awg5ht\/RGRkZCSIXkevLkSTgbGi6cPXjwYPTT2tracHZiYuI1rvncuXPhd9va2tJTOjo6wpRFv8pC2AEg7BB2r+nw4cPRR6UzMzPhbFVVVbSfbFFRUTixYcOG17vaEIUlJSVZ29WFKWG6sANA2CHs3pb29vbM3qquro5Sb+3ata93haHnUqnUjh07sqbv3LkzTM+9F8XKCzsAvs6EnbArvNHnXvvXx8fHQ58dOHAga3qYEqZPTk4KOwCEHcIuGaLdaQ8dOpQ1vbGxMUzPvW\/s3G+\/kHdLbPen3\/jujV\/++\/V\/HKMZq3z3VzMWTsfHPyn91Yz9X6ctzWQLo5QesfAvVsK9Kz1j4V7nsZnopSnphN1KMjw8nCPs7t27t+LfsRN2wk7YxVd6xMLoCbtEPzbjvDSFnbBbSSYnJ+f9KHb\/\/v1fk49i4+x\/P9GdfiocHPkqPjP2b\/\/v\/zc9Y+F0jAL9\/\/n\/0jO29twdSzPxT9YvRiyMXqxmLNy70vMW7nUem4lemgi7laaoqGjuzhP19fWLfpWFsBN2wk7YCTthJ+wQdvGyffv24uLizB1gw+lQdWG6sJMCwk7YSQFhJ+wQdkly8eLFkGhNTU3pKeF0mBKmCzspIOyEnRQQdsIOYZckU1NT69evLykpuXTpUnd3d\/i\/uLg4TAnThZ0UEHbCTgoIO2GHsFsa91\/Ra9\/Q48ePt2\/fnj5qSTgdfXGZsJMCwk7YSQFhJ+wQdkujpqZmVd5SqdQb3tzw8HB3d3c+SSfshJ2wE3bCTtgJO4Tdq2lsbNyWt3feeWeZZ0\/YCTthJ+yEnbATdgi7FULYCTthJ+yEnbATdgi7t2LRfR2EnbATdpamsBN2libCLkYuXLiwefPmDS9bt25dVVXVm29jJ+yEnbATdlJA2Ak7hN0yKS8vz7HzxOrVq4WdsBN2wk7YCTthh7BLgN7e3hBSZWVlAwMDfX194fT169eHhoba2tqKiorC9OWfJWEn7ISdsBN2wk7YIexeR11dXQipkZGR6GxpaenmzZszG+vEiRPCTtgJO2En7ISdsEPYJcCmTZuKi4vTZ2tqaiorK9NnP\/nkk6KiImEn7ISdsBN2wk7YIewSoK6uLjPstm7dmtlVjx49CmefPn0q7ISdsBN2wk7YCTuEXdxdunQphNTo6Gh09sqVK+Hs8PBwdHZwcDCcHRoaEnbCTtgJO2En7IQdwi7uRkZGQkhVVlZGX\/kVGi6cPXjwYPTT2tracHZiYkLYCTthJ+yEnbATdgi7BDh8+HB0ZJOZmZlwtqqqKtpPtqioKJzYsGHDMs+PsBN2wk7YCTthJ+wQdq+vvb29trY2fba6ujpKvbVr1y7\/zAg7YSfshJ2wE3bCDmG3lEafK8hNCzthJ+yEnbATdsIOYff6xsfHz549mzll06ZNt27dEnbCzspD2Ak7YSfsEHZJ0tLSEn3wmt5JYnJyMppSV1cn7ISdlYewE3bCTtgh7JJhfHw8arisd+yGhoZ27NgRpjc2Ngo7YSfshJ2wE3bCDmGXAKHnQkjduTP\/umrjxo3pvWWFnbATdsJO2Ak7YYewi7Xa2trMb57Icu\/evZBZ0SHuhJ2wE3bCTtgJO2GHsIt72KVSqYV+2tfXJ+yEnZWHsBN2wk7YIeyS4dNPPw0h1dXVNe9Pa2pqlj+zhJ2wE3bCTtgJO2GHsHsdMzMz0c4TV69enZ2dTU8fHR3ds2dPmH7gwAFhJ+yEnbATdsJO2CHskqGtrW3VC+Xl5RUVFSUlJdHZ6urq5Z8fYSfshJ2wE3bCTtgh7F7f8PDwli1boi+HjYS8yzoAirATdsJO2Ak7YSfsEHZJMjk5OTY2Nj09XcB5EHbCTtgJO2En7IQdwm6FEHbCTtgJO2En7IQdwi5f\/c9lnc1B2Ak7YSfshJ2wE3YIu5iKDmLS29v77MWR6nLIcZQ7YSfshJ2lKeyEnaWJsCuwI0eO7NixIx12O3J69913hZ2wE3bCTtgJO2GHsEPYCTthJ+ziJYySsBN2sGLDrq+vb9OmTVNTU\/P+dM+ePRUVFTMzM8JO2Ak7YbdynqyFnbCDFRx2IaQWCruNGzeGn46Pjws7YSfshJ2wE3bCDmEXR48fP16XIYTUuvlE+1j4rlhhZ+Uh7FZq2IV\/wk7YQeLDLti3b9+q\/Cz\/908IO2En7ISdsBN2wg5h92pGnuvq6goh9fjx45H5FOQrKISdsBN2wu7rmQLCTtgh7N7UX\/7lX65fv355bqu7u\/vRo0fCTgoIO2EnBYSdsEPYvRXHjx8PIXXq1Km3fUNffPFFuKHm5mZhJwWEnbCTAsJO2CHs3ora2toQUg8ePHirt3L79u3y8nJhJwWEnbCTAsJO2CHs3qI7d+6EkNq1a9dbuv7p6elz586lUqni4mJhJwWEnbCTAsJO2CHs3q62trbQUlVVVSdOnOjv778\/x5tceUNDQ7jyPXv2NDU1CTspIOyEnRQQdsIOYfcWRQcoziGVSr3J9Z8+ffrWrVvhREdHh7CTAsJO2EkBYSfsEHZvN+y25fTOO+8syQ0JOykg7ISdFBB2wg5ht0K8UthlMXrCTtgJO2HnsSnsEHavZmxsbGhoaGBg4FV\/cXZ2dvplbxh27kzCTtgJO2HnsSnsEHavqaurq6KiInp7rLq6Okw5ceJEaWlpd3dej5PW1tZF32MTdlJA2Ak7KSDshB3C7q27ePFiVGNVVVXpsNu9e3c08c6dxVdj4TL7XibshJ2wE3bCTtgJO4TdchsbG4sCbnR0NJytfi76UfQ+XGVl5ZLckLCTAsJO2EkBYSfsEHZv19mzZ0NIPXnyJDqbGXbBwYMHw0\/Hx8eFnbATdsJO2Ak7YYewi7va2tri4uL02aywGxgYCJn1+PFjYSfshJ2wE3bCTtgh7OKurq6uqKhoobDr7OwMmTU8PCzshJ2wE3bCTtgJO4Rd3EXfJ9ba2jpv2K1Zs2b5M0vYCTthJ+yEnbATdgi71w+poKWlJTPsRkdHt23bFqYfPHhQ2Ak7YSfshJ2wE3YIu2To6enJOgpdeXl5dKKmpqYgoenOJOyEnbATdh6bwg5h95rGx8d37dpVVFSU2XanT58uyMwIO2En7ISdsBN2wg5htzSFNzIyMjk5WcB5EHbCTtgJO2En7IQdwi5fX375ZZxnT9gJO2En7ISdsBN2CLt81dTUhHjatWvXkhygTtgJO2FnaQo7YWdpIuwKZufOnelt6SorKy9fvjw9PS3shJ2Vh7ATdsJO2EHywi6YnJxsamqKDlMX2bJly6NHj4SdsLPyEHbCTtgJO3iW0J0nhoeHjx49WlxcnN4Z9uzZsxMTE8JO2Fl5CDthJ+yEHcIuqQYHBzdt2pR+A2\/9+vX9\/f3CTthZeQg7YSfshB3CLqmmp6evX79eXV0d5V1JSckHH3wg7ISdsBN2wk7YCTuEXYKNjo6ePXs2NFYqlRJ2wk7YCTthJ+yE3ev5l3\/8k9RHX\/zG73\/+tw53fed7nf\/qP91N\/+j\/OPPj3\/yDz\/\/p+7\/80YFrD5L+4Hq\/\/eFvn\/7Tkz94OPdHX\/3858s\/Pz8ZGi\/5w9vfOfzDb3+v828c6vw7R3+0\/T\/e\/dqF3ezs7M2bN9etWxe9aVdUVCTshJ2wE3bCTtgJu9fzrRdzGP0LkTd35qN\/\/+Lf9ST6kfUPjt\/6nw7\/MPyBc\/+WP\/nzvwoTQ1ot5\/z8r\/\/2v0cD+61DnSGs\/96xm984+Iuz3zzU+aPBsa9F2A0ODm7evDm9mV1NTU13dwEeJ8JO2Ak7YSfshN2KCbvRr35+4NqDecPuZ+Nfbf+Pd18p7Hp++tc153pf9d+682\/9ietf\/9f+UHXphfLN7\/4g86f\/\/A9vh4l\/83s3lm3Yf+1wVzSqoefSE38yNB5N\/OZ385qTpIbd48eP9+\/fn94xtrS09OTJk6Ojo4WaH2En7ISdsBN2wm7FhF3WfGaGXdaP8gm7f\/nHP\/lG442st\/oW\/3fwRuv\/GHmrf+A3D3X+yZ\/\/VTix57\/9xdxyCkkXJpb84e3lGe3fufBn6b896yPgKDHzHO2EhV1It1OnTq1evTr9Ft2GDRsGBwcLPmPCTtgJO2En7ISdsEuQyz\/+2bcO\/rLk\/vbzt8r+8Xs3X\/obn8fof7j9l2+aLl\/9PFxz8akvFq3MaEi\/fTD7w9+fjX8V\/Sifz4UTE3ZNTU3p\/V6DioqKixcvTk5OxmT2hJ2wE3bCTtgJO2G3zMKtf+fwD1\/p3\/vtv9xJ4idD4xc+H3r2fA+J6G+J3r2LRBvYfeO7S\/A57K8f+1F0Vb9z4c\/yGe2\/+b0bYd6y\/uX\/aWzCvis22Llz59DQUNxmT9gJO2En7ISdsBN28Q+7uXu\/1pzr\/cXOCi830xJuYJcOuxxbDabfk8v971sr6R277du3t7e3x3b2hN1b8sd\/+jha8c9NgfCjAq5Fwk1Htz535ZH+UQHXZ\/OGXZgSBs3STJZ0kcxNgZgszblhV\/ClGfPHZgyXZnLDbkl853udc\/\/GaOKSbGA3+tXP\/+Hxm3PHMOsyGe\/YvdF+uCvqOHbCbiX1XHrdHz0Rz02B9NPizv+8fF83Em46vRqLamnuyiOa1fB\/uMByrkUy16\/zhl0Y1fSgLedaJHNpZg5RwZdmnGUuzcwhSqdAfJbm3LAr+GMzGqK5j80wP9FPw7\/lfGxmzknmEBV8aS5b2P1i54nvvvrOE41vfeeJzL8l67aig4xEG9h91PnTjnu\/+umf\/Plf\/Z2jP\/p7x26Gf\/\/g+K0lm40X+5fM3cYuS3RwlrmLIJpnYSfsYvouRVaUZKVA+nkw\/FvmFMh6Rp678sh8vC3n54xZ69e5YRet1aJ\/y7nyiPPSTETYzZsChVqamQsrWppZszr3Asv\/2Ixe28TzsZk1J3OXZqw+NV4o7Hp++tevFHY\/GhyL5+FOMv\/MzCkh4zInfvt7naHtotPRvqvbLv4kOvt3j938P\/\/Dny\/JbPz937u10F6xkX\/2QXcIyujtvTCk6QOjhLPRBQ623Bd2wi6mMqMkeuLLSoFCrdWy5iTMZ9bKo4Brtaw5mRt2hVqrvdLSjNu2UHF4bRPFbu4xLOBrm6ywy1yay5zpWXOS47G5JFvEv8lrmxxLM1bbJHzzu7\/cT\/OfvP\/fM6enNxpbGR\/Fzr1LhL\/3F++cvfhINP3TMzd\/Gk7\/b+\/\/asvI\/\/lo187\/sjT385+O\/mozu3\/6\/udZP32\/\/WHW8e1+cezilyvwHx6\/+YtPkD2BCrs4P9LSz3RZq7ECrtWyXnxnrTwKuFbL6qessCvgWu2VlqYt7Raq4YXOLv\/SzFpeWTmV+dNlftGV9WDMEXaFfWzGamkusmo7+fmLnTE7Q3ZE8fG\/\/N7NaPfM9DyHDLr8458l9+H2refHGUl\/FBtC7Zvf\/UGY8p3nxy5ed\/7O332RU99+vuHdXzwZ\/6jzp9X\/\/se\/9m9+GFpqCefkv\/zZ0\/SohhsNMfez8a9CTf6j937xZt63Dv4g\/eZcEGY4swKjrfR+0X+eQIVdPOVYW4QUKODzYNZ7clkrjwKu1eb200Jht\/wfd2bVcHyWZoJe22SmQKyWZtZDtVBvDM\/tpxwvugr72MxcfAVfmovK2pwr2rQ\/JEXWd47VnOtN7mMtnVO\/+Qeff+f517P+ZGg8RFuY8s8+6A5\/aTj77MVRUULzhTH57dN\/GoIvM7OWUPGpL9Lvlab\/\/cbvfz73ktHh977x\/Gh80aw+s\/OEsIutrA8vMlNg7qdUhXqOnrvyKOBabe4aN3MAC7tWi\/PSTMRrm6wUKOzSzHptkzmfmTNWkIPsZD4AY\/vYzBylrKUZ200RQtP8xZPxEEDpT\/16fvrXIXd+Nv7VvFuDJdGe\/\/YXIU+jI9tFfq9tINRb+Bujs9HB5P7Re7eWbcyjI+3lGOHw0\/QH4iHv\/tV\/uivshF18Zb34zkyBrBXe8s\/bQjOTNb3gNTzv6YKs1fJcmjawy2dpZg1gQQ4EmDkzCz0ECpLpC93tM2esIG8MZy7NzJnJWpo2RYiz6B27uTsIhyIs4Fz9jRffV5E+drGwE3bxlc\/+8AVZq2V10rz\/CrJWy\/ogbKF\/sV2a1mr5LM2CN0rWa5uF\/hXkRVfWO3PxKc44L01eqaJ+7d\/8MH32p6Nf\/e3DXQeuPSjgLP1yT9jv3qj+9z8WdsIu7vLpp4LMWNaOCPFZq+XTT4X6uDO2SzPRr23ivDQL8qIrn9c2Hpu8ttb\/MfLN73b+xu9\/\/i\/+Xc\/f\/71bv37sR2\/+TbJv7lsvNrMTdsIu7hZ68R2H58F4rtXyWeMWaq0W56WZ3Nc2hVqai762KeC32CX3sWlThKT4qPOn\/\/q\/9hd248LM\/Ta+dfAHv\/kHnws7YZcAi774LuAh2nN\/FFXAtdqi\/VSotdqiS9NaLUFLc9F+KmCmL9pPsV2aNkUgT799+k\/DHebXDnc9e\/FRbGZlCjthF2uxXavlXnkUcK22aD\/FdmlaqyVraeZ+bVPAF125+8ljkxUg+o6Kbx+6ER3KLusrOoSdsIu13P1UwBnL\/VFUYb\/tMbYfd8Z2aSb0tU2cl2YBX3Tl7iePTVaAHw2OfevgL+85v3Phz7LvZgZI2MVZjhffBX8ejOdaLfcat7BrtTgvzSS+tins0szx2qaAmyIk97FpUwSW7P5vCIRdnOV48V3YtdqzhT+KKvhaLUc\/FXatlmNpWqslbmnm6KeCZ3qOfort0rQpAsJO2H1t7qNxXasttPIo+FotRz\/FdmlaqyVxaS702qbgL7oW6iePTYQdwq7wFuqngs\/YQh9FFXyttlA\/xeHjztguzcS9tonz0iz4i66F+sljE2H39TU9Pd3V1dXa2nrjxo2JiQlhF7cX3zF5HoznWm2hNW4c1mpxXprJem0Th6U572ubgm+KkMTHpk0REHZvV3Nzc1lZ2aoXioqKPv74Y2EXqxffcVirPZvvo6iYrNXm7ac4rNXmXZrWagldmvP2U0wyfd5+iu3StCkCwu4t6ujoCJVWV1fX09MzNTV19+7d+vr6MOXTTz8VdvFZecRkrTZ35RGTtdq8\/RTbpWmtltylOfe1TUxedM3tJ49NhN3XVEi6oqKi0dHR9JSJiYny8vKamhphF59+ismMzf0oKiZrtbn9FJ+PO2O7NBP02ibOSzMmL7rm9pPHJsLua2rr1q0NDQ1ZE8OU3Okm7JbzxXesngfjuVabu8aNz1otzkszKa9t4rM0s17bxGRThGQ9Nm2KgLBbbrOzs2vWrCkrKxN2MXnxHZ+12rOXP4qK1Votq5\/is1bLWprWaolemln9FKtMz+qn2C5NmyIg7JbbJ598Errt5MmTucMui3F7eyuPWK3VMlcesVqrZfVTbJemtVrSl2bma5tYvejK7CePTYQdv3Tz5s2ioqKampqxsbHcYWesluc5Ooaf3EUrtvB\/3BolPWixWt1mzlis3uNMykPA0vTYBGE3j9nZ2emXzb1MR0dHcXFxZWXl4OBg7msTdssjtk+CsZ2xsP6I7VtiPoS1ND023asRdkumtbU194enFy5cCBNramqGhoYWvTZhBwAIu4K5c+fOvpdl\/vTo0aOh1bZt2zYyMpLPtQk7AEDYxdH+\/ftDqIXUm5qayvNXhB0AIOxi5\/z586HSGhsbX+m3hB0AIOziZWRkpLi4OFTa3r17G+eYmZkRdgCAsEuGtra2VQubd89ZYQcACLsVRdgBAMJO2AEACDthBwAg7IQdACDsEHYAgLATdgAAwk7YAQAIO2EHAAg7hB0AIOyEHQCAsBN2AADCTtgBAMIOYQcACDuEHQAg7IQdAICwE3YAAMJO2AEAwg5hBwAIO2EHACDshB0AgLATdgCAsEPYAQDCTtgBAAg7YQcAIOyEHQCAsBN2AICwQ9gBAMJO2AEACDthBwAg7IQdACDsEHYAgLATdgAAwk7YAQAIO2EHAAg7hB0AIOyEnbADAIRdPE1OTnZ2dra1tX355ZfCDgAQdkl17dq10tLSVS9s3LjxwYMHwg4AEHYJ093dHSpty5YtfX19U1NTra2tq1evrqqqmpiYEHYAgLBLkh07dqRSqcePH6enXL58OXTb9evXhR0AIOySpKWl5cyZM5lTOjo6QredP39e2AEAwi7Zjh8\/Hrqtp6dH2AEAwi6RHjx40NraumvXrhBtJ06cyH1hYQcACLv4OnLkSLRXbHV1de4N7KKwy2IAAQBht0xmZ2enX5Z1gdHR0XCZgYGBnTt3hlA7d+5c7rBzZwIAhF1htLa25vke29TUVGVlZVFR0czMjLADAIRd7Ny5c2ffy3Jc+MCBAyHdbt++LewAAGGXDNPT02vXrt2zZ0\/W9IaGhpBuDx8+FHYAgLBLjE2bNqVSqcyGu3\/\/fpiyYcOGHL8l7AAAYRc7t27divaE\/eyzz7q7u5uamqIN7HJ8DivsAABhF1NdXV1r165N71RRW1vb29ub+1eEHQAg7OJrcHCwu7t7eHg4nwsLOwBA2K0Qwg4AEHbCDgBA2Ak7AABhJ+wAAGGHsAMAhJ2wAwAQdsIOAEDYCTsAQNgh7AAAYSfsAACEnbADABB2wg4AEHYIOwBA2CHsAABhJ+wAAISdsAMAEHbCDgAQdgg7AEDYCTsAAGEn7AAAhJ2wAwCEHcIOABB2wg4AQNgJOwAAYSfsAACEnbADAIQdwg4AEHbCDgBA2Ak7AABhJ+wAAGGHsAMAhJ2wAwAQdsIOAEDYCTsAQNgh7AAAYbdyDQ8Pd3R0jIyMCDsAQNgl2\/bt20O0dXd3CzsAQNgl2IULF1Y9J+wAAGGXYP39\/alUqqKiQtgBAMIuwaampjZs2FBfX\/\/+++8LOwBA2CVY6Lny8vInT54IOwBA2CVYZ2dnCLWWlpao8IQdACDsEmlkZKSysvLAgQPR2fzDLouRBACE3TKZnZ2dflk0vaGhoaqqanR09FXDzp0JABB2hdHa2jr3PbYrV66EEzdv3kxfTNgBAMIu7u7cubPvZc+ev123amHpt\/GEHQAg7OLu0qVLx162cePGEG27d+8OpycmJoQdACDskspHsQCAsBN2AADCTtgBAAi7QhF2AICwE3YAAMJO2AEACDthBwAIO4QdACDshB0AgLATdgAAwk7YAQDCDmEHAAg7YQcAIOyEHQCAsBN2AICwQ9gBAMIOYQcACDthBwAg7IQdAICwE3YAgLBD2AEAwk7YAQAIO2EHACDshB0AIOwQdgCAsBN2AADCTtgBAAg7YQcAIOyEHQAg7BB2AICwE3YAAMJO2AEACDthBwAIO4QdACDshB0AgLATdgAAwk7YAQDCDmEHAAg7YSfsAABhJ+wAAITd2zIzMzMxx9TUlLADAIRdwhw\/fnzVHI2NjUsbdlrwNRg0I2bQDJoRM2gIu1ezc+fO4uLiYy9ramoSdh7VRsygYdCMmEETdgkTqm737t1v+97mDupRbcQMmkEzYhg0Yfd2PXr0KNx1PvzwQ2HnUW3EDBoGzYgZNGGXbO3t7eGuE\/7v6em5fPny1atX+\/v7hZ1HtREzaBg0I2bQhF3ynDp1Ktx1qqurM\/ecOHz48MzMTO57GwAQK8KOZ\/v27Qt3hT179ty\/f396erq3t3fr1q1hyokTJwwOACDs4mh2dnb6ZdH027dvt7S0ZF5yfHy8srKyqKhobGzMPQYAEHax09ramv8btocOHQoX6OzsdI8BAIRd7Ny5c2ffy3Jc+NixYyHsbty44R4DAAi7ZJienq6vr9+\/f3\/W9L1794awGxwcNEQAgLBLjJqamlQqldlw9+\/fD1Pq6uoMDgAg7JKko6MjOtzJtWvXuru7m5ubKysrS0tL7927Z3AAAGGXMO3t7WvXrk3vVFFbW9vX12dYAABhl1QDAwPd3d1PnjwxFACAsAMAQNgBACDsAACEHQAAwg4AAGH3NXf\/\/v329vaOjo7h4WGj8UrCiIVxGxkZMRSLmp6e7urqam1tvXHjxsTEhAGZ1+zsbHd3dxil8H84bUDctTyJWV0KO17B06dPd+7cmT5aXiqVOnPmjGHJ3\/bt28O4hXWwocitubm5rKwsfU8rKir6+OOPDUuWvr6+mpqa9CiF0\/39\/YbFXcuTmNWlsCMvMzMzmzdvDs+Dly5dmpqaGhgYePfdd8P99erVqwYnHxcuXIge4Z4Tc4u+SaWurq6npyfc0+7evVtfXx+mfPrppwYnbWxsrPK5rq6uMErt7e3hdFVV1fj4uMFx1\/IkZnUp7Fjc5cuXw\/0y3E3TU0ZGRsId1zfS5qO\/vz+8YquoqPCcuKhwjwr3q9HR0fSUiYmJ8vLympoag5N27ty5cF9qa2vLqpbz588bHHctT2JWl8KOxb3zzjuVlZVZ2\/F88ZzByS28YtuwYUN9ff3777\/vOXFRW7dubWhoyJoYpoShMzhptbW1JSUlWY\/HMCVMNzjuWp7ErC6FHYsId9DwWq2xsfHZ8zeZb926FR7Y4YSRyUd4KiwvL3\/y5InnxNe++61Zs6asrMxQZD4ed+zYkTV9586dYbq9KNy1PIlZXQo7FvHw4cPwYH7vvfeuXLlSWloabWYRHufXrl0zOLl1dnaGsWppaYmeHD0nvoZPPvkkjNvJkycNRWR8fDwMyIEDB7Kmhylh+uTkpCFy1\/IkZnUp7MglvOYId83q6uqSkpJz586Fx3lzc3M4Gya2trYan4WMjIxUVlamV8CeE1\/DzZs3i4qKampqxsbGjEbk0aNH4Y506NChrOmNjY1hun1j3bU8iVldCjt+ZXZ2dvpl0TNg9LKjq6srfcnHjx9HT4sGbd5Be\/Z8852qqqr0xtqeE\/MZtEwdHR3FxcVhvTI4OGjE0oaHh3OE3b179wzRoty18uRJ7DVeMFhdCrt4CS8pVr0sTLx9+3Y4sXbt2qwL79+\/P0x\/+vSpQZs7aFeuXAknwoM8fTHPiYsOWqbo2ArhqXBoaMhwZZqcnJz3o9jo8eij2EW5a+XJk9hrsLoUdrFz586dfS979vxY7eEeOXeHsiNHjoTpPT09Bm3uoEV72y0k85gLBi09aGlHjx4No7Rt2zbHuJ9XePU\/d+eJ+vr6MN3g5OaulT9PYq\/B6lLYJUZ4\/TH38ArRS5B5P0Tj0qVLx162cePGMFy7d+8Op32XUQ7R\/Sqk3tTUlNGY1\/bt24uLizMfj+F0qLow3eC4a3kSs7oUdizuzJkz4U7Z1NSUnjI0NGRF8kp8ipGP8+fPh1GKDhbAQi5evJj1eAynw5Qw3eC4a3kSs7oUdixubGyspqYm3DXPnj1769at69evR2f7+voMjufEpTIyMlJcXBxGae\/evY1zOBZU2tTU1Pr160tKSi5duhTuUeH\/MG5hijei3LU8iVldCjvy9fTp0\/CcmPml4x7enhOXVltbW45tenyKkenx48fRN7JHwuknT54YFnctT2JWl8KOVzM+Ph7uoAMDA4YCCm54eDg8HiUdWF0KOwAAhB0AAMIOAABhBwAg7AAAEHYAAAg7AACEHQCAsAMAQNgBACDsAAAQdgAAwg4AAGEHJF9\/f39DQ8OhQ4cWusDevXvDBaampt7whj799NNwPT09PYX6S58+ffpKl7906VKY4d7e3rc6V0s4LF9++eWqVavu3r37JlfS0tJSXl4+NDTkoQHCDkie7u7uUANVVVULXaC4uDhcYGJi4g1v6P333w\/X09rauvx\/4\/j4+JEjR\/bt2\/dKv3Xs2LEwwx0dHW913pZqWKanp9etW3fw4ME3n6UtW7a8++67Hhog7ABht6A7d+40Nzc\/evRo+f\/Gnp6e8CfEM+yWaljOnj2bSqWW5J22L774Ivzh169f9+gAYQcIu9iJc9gtibGxsbKyssbGxqW6wi1bttTU1MzOznqAgLADVn7YPX369OLFi4cPHz548ODZs2cfPnyY+dPe3t7PPvssXKazszNc4PTp00NDQ19++WWYGL2lNDMz89nCMjeGy31Dz55vWBb9ysjIyIULFw4dOhQu3Nramo6SO3funDlzJvwJdXV14ZKZW7MNDAyEX4muPGTc9evXM1Mmz7DLcSXhj43+oqxfCbMXJj5+\/Dg9\/5nvtI2Pj1+5ciW6whMnToQFtOhCPH\/+fJjVmzdvzjsyT548CUMXru29994LE6Of3rt37+TJk6EFP\/roo7mjGmYgXGFLS4sHCAg7YIWHXciF0tLSMDGVSkU\/DSdC3GQl0alTp1a9EEIhc2OycG2rFpbeX2HRG3r2Yhu1jz\/+ePXq1ZlX8s4770xPT4cLhELKnJ5+Wyv6xaCoqCi68mDz5s1jY2P5h13uK5mamtq4cWM0e+lfaW5uDlM2bdoUzV7WNnYhEysrK8OUcG3R3x68++670YUXsm7dupKSkqw32KJrDklXXl6eOQJhVKNuSysrK7t\/\/37m7w4PD4fpu3fv9gABYQckL+xCFXUtICRLZtjdvn07nA2tkH5XLFxD6MIwsampKTOJwi8eOHCgra3tzJkzIXSyCmb0ZeEC+\/fvDxc4cuRI\/jeUzpdwWyHgove9QhdWV1dHNfns+buD0UZje\/fuDXkUzoaJ165dC1O2bNmSfrPqwYMHIcjCxPPnz+cZdvlcSQimqEqjy4T\/Q4GFYhscHMyc\/\/Sw1NfXh7Nh0KKzT548CYUaply6dGmh2QgtGP1180ZnGJnjx48\/ffo0jGG4kjBlzZo1YX7CGIahGB8fP3jwYJg4d6+LtWvXhjmPhgsQdkCSwm5R6bDbunVrZnmk8yVMrKioiAosSqJwybmdsdDun3\/0R38UfhqyJl0S+dxQ+mq3bduWebGrV69mxsrcbez27Nkz98gg7e3tmb+1aNjlcyXB97\/\/\/TBl+\/btYZ5ra2vD6VCECw1L6LDQsplXGDo1zHkUqfNqaWkJ1\/Dhhx\/OG3ZZIxMlb7o7n714cy5kXNavhygP00PZe4yAsAMSFnYlJSXHFpBKpdJhNzU1Fb2LNvd6duzYEX70xRdfpJPo3LlzeYZd1GHr168fHR2NpuR5Q88yPorNvMytW7cyS27enSfm7hkQFVL6s9p8Popd9Eoy57murm7ue2NZwxJ9dPvee+\/19fXluQTDhefdHi79UWzmxIaGhjAxa7u96NPYrF8\/fvx49LmtxwgIOyBhYZfnNnZRMO3Zs2fuxY4cOZI+RkaURFnHy1go7MIMhHasqKjIPORHnjeUvtqs24r+qNxh9+z5fhUXL148evRo+FEom6yN8PLceSL3lUQeP34cbQK4bt268fHxHMPS1dWV3lYvjEm4nvCn5d7ALvostb29fd6wywq+KOyGh4cXDbumpqYw\/fTp0x4jIOyAlRl2ITsWOm5IlEFRRkSnsxpu3rB78OBBeXl5uImsr17I84YWutpFwy6UVvSpaLRDxsaNG0MenTx58pXCLp8riYyNjUVbB1ZXV6d3zlho\/h8+fPjRRx9t2LAh\/Tn4mjVrcuwbG25r3vmcd2SisEu\/M5oj7KKdPMKVeIyAsANWZtjdu3dv7sZzc\/Miz7AbHh6ONvma+zFinjf02mEXBdmhQ4f6+\/vTH6d2dna+UtjlcyWRaHu1TZs2zf1Rjk+oQziGuoq2NQxtt9BR5aK3MLM2RnzzsIs2Dbx8+bLHCAg7YGWGXWiLoqKiVCqV9bZTmB4lWrSzZz5hF64w2uYsa1O89BXmc0OvF3YPHz4MZ0tLS7Nu9NNPPw3T9+\/fn0\/Y5Xklz54ftCVMCRWY3nki84PjzPl\/8uTJRx99lNVS4beiA6AsdIzos2fPzltgbxh20WFi5vYiIOyAFRJ2z15sqn\/06NHMy0QHyE2\/wZZP2O3evTucDfWw0O3mc0N5hl10QJCdO3dGZ0MURvuLZG67NjIyUlNTk\/lbucMuzyt5\/PhxaKYQqQ8ePHj24ugn5eXl0dGJs+Y\/VGz003A96escHx8PtxKuYaF37MIczjuSbxh2u3btCtOzjm8HCDtgRYVdaIKoXXbs2HH9+vXQDdHx51avXh36Kc+wi95kChFz5MiRgwcPNr7s6tWred5QnmEX2ivaWG3v3r3R\/rPRO2ch9UIVdXV1ff\/73w8jEG3Wtn379nzCLs8rCSey3pWM\/vb6+vp55\/+jjz4KZ8MffvHixXC1TU1N0YHxzpw5s9BshEUTRnLTpk1LGHYhIsNyX7NmjQcICDtgJYfds+fvSx06dCg6DEpk9+7dmV9LtWjYRRdYSHqD\/UVvKM+we\/b8rb7oekIzPXv+Rlr0QXCktLT01KlTk5OT1dXVRUVF0Rtm+ew8kftKLly4EH0Im9VMmQcxnjv\/p0+fLikpSV9tCNnMw87NKzqi3pMnT5Yq7KJDOp88edIDBIQd8LUwPT0d+unWrVsLbfsVtxsKRRWuIfOT01BmN2\/evHv37pt82\/2SXMncWe3v7+\/q6srzk9Do6DBZX7b2JqKD2KU3ZASEHQDLp7a2dv369UtyVSF\/S0tLM\/f\/AIQdAMsn+vB0SXZivXDhQiqVyvrIGxB2ACyfw4cPb9y48Q0\/ER4bG1u9evW8x6ABhB0AyyQ02ZEjR3p7e9\/kSm7cuPHBBx8s4faCgLADAEDYAQAIOwAAhB0AAMIOAICl8P8DDQV2S6ryCwIAAAAASUVORK5CYII=","width":475}
%---
