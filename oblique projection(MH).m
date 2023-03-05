classdef MHprojekt < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        SiawyrzutuSlider       matlab.ui.control.Slider
        SiawyrzutuSliderLabel  matlab.ui.control.Label
        StartSymulacjiButton   matlab.ui.control.Button
        KtwyrzutuSlider        matlab.ui.control.Slider
        KtwyrzutuSliderLabel   matlab.ui.control.Label
        MasapikiSlider         matlab.ui.control.Slider
        MasapikiSliderLabel    matlab.ui.control.Label
        UIAxes                 matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)

        end

        % Value changed function: MasapikiSlider
        function MasapikiSliderValueChanged(app, event)

        end

        % Value changed function: KtwyrzutuSlider
        function KtwyrzutuSliderValueChanged(app, event)

        end

        % Button pushed function: StartSymulacjiButton
        function StartSymulacjiButtonPushed(app, event)
 
  % rzut ukośny piłki 
 
  %Stałe

  A=pi*(.0366*2)^2/4; %m^2
  C=.5;               % (Współczynnik przeciągania kuli)
  rho= 1.2;           %kg/m^3 (Gęstość powietrza)
  D=rho*C*A/2;        % (równanie oporu)
  g=9.81;             %m/s^2 (współczynnik grawitacji)

    %Zmienne możliwe do zmiany za pomocą suwaków 
        theta = app.KtwyrzutuSlider.Value;
        m = app.MasapikiSlider.Value;
        v= app.SiawyrzutuSlider.Value;

    delta_t= .01; %s
    x(1)=0;
    y(1)=0;
   
    vx=v*cosd(theta);
    vy=v*sind(theta);
    t(1)=0; 

    %Start
    %warunki konieczne 
    
    if(v==0)
    v = 0.00000000001;
    end
    
    if(theta==0)
    theta = 0.00000000001;
    end
    
    if(m==0)
    m = 0.00000000001;
    end
    
    i=1;
    while min(y)>= 0
        ax=-(D/m)*v*vx;
        ay=-g-(D/m)*v*vy;
        vx=vx+ax*delta_t;
        vy=vy+ay*delta_t;

        x(i+1)=x(i)+vx*delta_t+.5*ax*delta_t^2;
        y(i+1)=y(i)+vy*delta_t+.5*ay*delta_t^2;
        t(i+1)=t(i)+delta_t;

        i=i+1;
    end ;
            %color wykresu oddjące rzeczywistą wysokość rzutu
            numColors = 256;
            colorIndex = round(rescale(y, 1, numColors));
            cmap = jet(numColors);
            markerColors = cmap(colorIndex, :);

            %
            c = colorbar(app.UIAxes);
            colormap(app.UIAxes, jet(numColors))
            c.Label.String = "Osiągnięta wysokość (%)";
      
            

            scatter3(app.UIAxes,t,x,y,10,markerColors);

            
      

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Rzut Ukośny')
            xlabel(app.UIAxes, 'Czas (sec)')
            ylabel(app.UIAxes, 'Długość (m)')
            zlabel(app.UIAxes, 'Wysokość (m)')
            app.UIAxes.Position = [286 155 334 204];

            % Create MasapikiSliderLabel
            app.MasapikiSliderLabel = uilabel(app.UIFigure);
            app.MasapikiSliderLabel.HorizontalAlignment = 'right';
            app.MasapikiSliderLabel.Position = [36 313 59 22];
            app.MasapikiSliderLabel.Text = 'Masa piłki';

            % Create MasapikiSlider
            app.MasapikiSlider = uislider(app.UIFigure);
            app.MasapikiSlider.ValueChangedFcn = createCallbackFcn(app, @MasapikiSliderValueChanged, true);
            app.MasapikiSlider.Position = [116 322 150 3];

            % Create KtwyrzutuSliderLabel
            app.KtwyrzutuSliderLabel = uilabel(app.UIFigure);
            app.KtwyrzutuSliderLabel.HorizontalAlignment = 'right';
            app.KtwyrzutuSliderLabel.Position = [29 241 68 22];
            app.KtwyrzutuSliderLabel.Text = 'Kąt wyrzutu';

            % Create KtwyrzutuSlider
            app.KtwyrzutuSlider = uislider(app.UIFigure);
            app.KtwyrzutuSlider.Limits = [0 90];
            app.KtwyrzutuSlider.ValueChangedFcn = createCallbackFcn(app, @KtwyrzutuSliderValueChanged, true);
            app.KtwyrzutuSlider.Position = [118 250 150 3];

            % Create StartSymulacjiButton
            app.StartSymulacjiButton = uibutton(app.UIFigure, 'push');
            app.StartSymulacjiButton.ButtonPushedFcn = createCallbackFcn(app, @StartSymulacjiButtonPushed, true);
            app.StartSymulacjiButton.Position = [329 116 100 22];
            app.StartSymulacjiButton.Text = 'Start Symulacji ';

            % Create SiawyrzutuSliderLabel
            app.SiawyrzutuSliderLabel = uilabel(app.UIFigure);
            app.SiawyrzutuSliderLabel.HorizontalAlignment = 'right';
            app.SiawyrzutuSliderLabel.Position = [29 178 70 22];
            app.SiawyrzutuSliderLabel.Text = 'Siła wyrzutu';

            % Create SiawyrzutuSlider
            app.SiawyrzutuSlider = uislider(app.UIFigure);
            app.SiawyrzutuSlider.Position = [120 187 150 3];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MHprojekt

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end