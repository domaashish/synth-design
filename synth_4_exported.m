classdef synth_4_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        OSC2Label              matlab.ui.control.Label
        OSC1Label              matlab.ui.control.Label
        amplitudedBKnob        matlab.ui.control.Knob
        amplitudedBKnobLabel   matlab.ui.control.Label
        Lamp                   matlab.ui.control.Lamp
        LampLabel              matlab.ui.control.Label
        timeperiodSlider       matlab.ui.control.Slider
        timeperiodSliderLabel  matlab.ui.control.Label
        Switch                 matlab.ui.control.ToggleSwitch
        Label                  matlab.ui.control.Label
        frequency2Slider       matlab.ui.control.Slider
        frequency2SliderLabel  matlab.ui.control.Label
        frequency1Slider       matlab.ui.control.Slider
        frequency1SliderLabel  matlab.ui.control.Label
        UIAxes                 matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
        player 
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            value = app.Switch.Value;
            if  strcmpi(value,'On')
                app.Lamp.Color = 'g';
                f = app.frequency1Slider.Value;
                q = app.frequency2Slider.Value;
                k = app.timeperiodSlider.Value;
                a = app.amplitudedBKnob.Value;
                fs = 44100;
                t = linspace(0, k, k * fs);
                u = sin(f*t);
                h = sin(q*t);
                y = a*(u+h);
                app.player = audioplayer(y,fs);
                play(app.player);
                plot(app.UIAxes, t(1:1000), y(1:1000));
                xlabel(app.UIAxes, 'Time (s)');
                ylabel(app.UIAxes, 'Amplitude');
            else 
                app.Lamp.Color = 'r';
                stop(app.player);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 432 590];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Color = 'none';
            app.UIAxes.GridColor = [0 0 1];
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            colormap(app.UIAxes, 'hsv')
            app.UIAxes.Position = [29 44 382 185];

            % Create frequency1SliderLabel
            app.frequency1SliderLabel = uilabel(app.UIFigure);
            app.frequency1SliderLabel.HorizontalAlignment = 'right';
            app.frequency1SliderLabel.Position = [29 466 64 22];
            app.frequency1SliderLabel.Text = 'frequency1';

            % Create frequency1Slider
            app.frequency1Slider = uislider(app.UIFigure);
            app.frequency1Slider.Limits = [20 1000];
            app.frequency1Slider.Position = [114 475 284 3];
            app.frequency1Slider.Value = 200;

            % Create frequency2SliderLabel
            app.frequency2SliderLabel = uilabel(app.UIFigure);
            app.frequency2SliderLabel.HorizontalAlignment = 'right';
            app.frequency2SliderLabel.Position = [161 403 64 22];
            app.frequency2SliderLabel.Text = 'frequency2';

            % Create frequency2Slider
            app.frequency2Slider = uislider(app.UIFigure);
            app.frequency2Slider.Limits = [100 1000];
            app.frequency2Slider.Position = [246 412 152 3];
            app.frequency2Slider.Value = 100;

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'center';
            app.Label.Position = [194 241 25 22];
            app.Label.Text = '';

            % Create Switch
            app.Switch = uiswitch(app.UIFigure, 'toggle');
            app.Switch.Orientation = 'horizontal';
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.Position = [196 299 64 28];

            % Create timeperiodSliderLabel
            app.timeperiodSliderLabel = uilabel(app.UIFigure);
            app.timeperiodSliderLabel.HorizontalAlignment = 'right';
            app.timeperiodSliderLabel.Position = [28 528 64 22];
            app.timeperiodSliderLabel.Text = 'time period';

            % Create timeperiodSlider
            app.timeperiodSlider = uislider(app.UIFigure);
            app.timeperiodSlider.Limits = [2 60];
            app.timeperiodSlider.Position = [113 537 290 3];
            app.timeperiodSlider.Value = 2;

            % Create LampLabel
            app.LampLabel = uilabel(app.UIFigure);
            app.LampLabel.HorizontalAlignment = 'right';
            app.LampLabel.Position = [324 302 35 22];
            app.LampLabel.Text = 'Lamp';

            % Create Lamp
            app.Lamp = uilamp(app.UIFigure);
            app.Lamp.Position = [374 302 20 20];
            app.Lamp.Color = [1 0 0];

            % Create amplitudedBKnobLabel
            app.amplitudedBKnobLabel = uilabel(app.UIFigure);
            app.amplitudedBKnobLabel.HorizontalAlignment = 'center';
            app.amplitudedBKnobLabel.FontSize = 9;
            app.amplitudedBKnobLabel.Position = [60 241 61 22];
            app.amplitudedBKnobLabel.Text = 'amplitude(dB)';

            % Create amplitudedBKnob
            app.amplitudedBKnob = uiknob(app.UIFigure, 'continuous');
            app.amplitudedBKnob.Limits = [0 1];
            app.amplitudedBKnob.FontSize = 9;
            app.amplitudedBKnob.Position = [58 297 60 60];

            % Create OSC1Label
            app.OSC1Label = uilabel(app.UIFigure);
            app.OSC1Label.FontName = 'Arial Black';
            app.OSC1Label.Position = [34 443 64 22];
            app.OSC1Label.Text = 'OSC - 1';

            % Create OSC2Label
            app.OSC2Label = uilabel(app.UIFigure);
            app.OSC2Label.FontName = 'Arial Black';
            app.OSC2Label.FontWeight = 'bold';
            app.OSC2Label.FontColor = [0 0 1];
            app.OSC2Label.Position = [169 381 53 22];
            app.OSC2Label.Text = 'OSC - 2';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = synth_4_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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