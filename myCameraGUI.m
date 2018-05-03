   
function varargout = myCameraGUI(varargin)
% MYCAMERAGUI MATLAB code for myCameraGUI.fig
%      MYCAMERAGUI, by itself, creates a new MYCAMERAGUI or raises the existing
%      singleton*.
%
%      H = MYCAMERAGUI returns the handle to a new MYCAMERAGUI or the handle to
%      the existing singleton*.
%
%      MYCAMERAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYCAMERAGUI.M with the given input arguments.
%
%      MYCAMERAGUI('Property','Value',...) creates a new MYCAMERAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myCameraGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myCameraGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help myCameraGUI

% Last Modified by GUIDE v2.5 01-Jul-2016 18:18:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myCameraGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @myCameraGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before myCameraGUI is made visible.
function myCameraGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myCameraGUI (see VARARGIN)

addpath(genpath('../'));


% Choose default command line output for myCameraGUI
handles.video = videoinput('winvideo', 1,'MJPG_1600x1200');
CameraLoop_basic(handles.video);
triggerconfig(handles.video,'manual');
handles.video.FramesPerTrigger = Inf; % Capture frames until we manually s

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes myCameraGUI wait for user response (see UIRESUME)
uiwait(handles.MyCameraGUI);

end

function CameraLoop_basic(video_handle)
set(video_handle,'TimerPeriod', 0.1, ...
      'TimerFcn',['if(~isempty(gco)),'...
                      'handles=guidata(gcf);'...                                 % Update handles
                      'image(getsnapshot(handles.video));'...                    % Get picture using GETSNAPSHOT and put it into axes using IMAGE
                      'set(handles.cameraAxes,''ytick'',[600],''xtick'',[800],''xaxislocation'',''top'',''ticklength'',[.01,.025]),'...    % Remove tickmarks and labels that are inserted when using IMAGE
                      'hold on;'...
                      'plot(800,600,''x'',''color'',''g'');'...
                      'hold off;'...
                  'else '...
                      'delete(imaqfind);'...                                     % Clean up - delete any image acquisition objects
                  'end']);
end


% --- Outputs from this function are returned to the command line.
function varargout = myCameraGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles.output = hObject;
varargout{1} = handles.output;

end

function moveCoordinates_Callback(hObject, eventdata, handles)
% hObject    handle to moveCoordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of moveCoordinates as text
%        str2double(get(hObject,'String')) returns contents of moveCoordinates as a double

contents = str2double(strsplit(get(hObject,'String'),','));
disp(contents)
if numel(contents) ~= 3 || any(isnan(contents))
    disp('Please provide 3 numerical coordinates separated by commas. ex) 300,300,300');
else
    global sixk;
    if isempty(sixk)
        sixk = serial('COM6', 'BaudRate', 9600);
    end
    if isequal(sixk.status,'closed')
        fopen(sixk);
    end
    fprintf(sixk, 'DRIVE111');
    pause(.5);
    fprintf(sixk, sprintf('D%i,%i,%i',contents(1),contents(2),contents(3)));
    fprintf(sixk, 'GO111');

    pause(1);
    %fprintf(sixk, 'DRIVE000');
    %fclose(sixk);
end

end

% --- Executes during object creation, after setting all properties.
function moveCoordinates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to moveCoordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in captureImage.
function captureImage_Callback(hObject, eventdata, handles)
% hObject    handle to captureImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    frame = getsnapshot(handles.video);
    %frame = get(get(handles.cameraAxes,'children'),'cdata'); % The current displayed frame
    %save('testframe.mat', 'frame');
    imwrite(frame, 'captured_image.png');
    disp('Frame saved to file captured_image.png');
end

% --- Executes on button press in startStopCamera.
function startStopCamera_Callback(hObject, eventdata, handles)
% hObject    handle to startStopCamera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if strcmp(get(handles.startStopCamera,'String'),'Start Camera')
          % Camera is off. Change button string and start camera.
          set(handles.startStopCamera,'String','Stop Camera')
          start(handles.video)
          %set(handles.startAcquisition,'Enable','on');
          set(handles.captureImage,'Enable','on');
          %figure(handles{1})
    else
          % Camera is on. Stop camera and change button string.
          set(handles.startStopCamera,'String','Start Camera')
          stop(handles.video)
          %set(handles.startAcquisition,'Enable','off');
          set(handles.captureImage,'Enable','off');
    end
end

% --- Executes on button press in startAcquisition.
function startAcquisition_Callback(hObject, eventdata, handles)
% hObject    handle to startAcquisition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if strcmp(get(handles.startAcquisition,'String'),'Start Acquisition')
      % Camera is not acquiring. Change button string and start acquisition.
      set(handles.startAcquisition,'String','Stop Acquisition');
      trigger(handles.video);
    else
          % Camera is acquiring. Stop acquisition, save video data,
          % and change button string.
          stop(handles.video);
          disp('Saving captured video...');
          videodata = getdata(handles.video);
          save('testvideo.mat', 'videodata');
          disp('Video saved to file ''testvideo.mat''');
          start(handles.video); % Restart the camera
          set(handles.startAcquisition,'String','Start Acquisition');
    end
end


% --- Executes when user attempts to close MyCameraGUI.
function MyCameraGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MyCameraGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
% Stop the motor drivers when closing the GUI
    global sixk;
    if isempty(sixk)
        sixk = serial('COM6', 'BaudRate', 9600);
    end
    if isequal(sixk.status,'open')
        fprintf(sixk, 'DRIVE000');
        fclose(sixk);
    end
    
% Hint: delete(hObject) closes the figure
    delete(hObject);
    delete(imaqfind);
end


% --- Executes on button press in move.
function move_Callback(hObject, eventdata, handles)
% hObject    handle to move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end
% % --- Executes on button press in RaisePlatform.
% function raise_Callback(hObject, eventdata, handles)
% % hObject    handle to RaisePlatform (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%     cam = serial('COM11');
%     fopen(cam);
%     pause(3);
%     fprintf(cam,'0');
%     fclose(cam);
%     
% end
% 
% 
%     
% % --- Executes on button press in LowerPlatform.
% function lower_Callback(hObject, eventdata, handles)
% % hObject    handle to LowerPlatform (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%     cam = serial('COM11');
%     fopen(cam);
%     pause(3);
%     fprintf(cam,'1');
%     fclose(cam);
% end


% --- Executes on button press in findHoles.
function findHoles_Callback(hObject, eventdata, handles)
% hObject    handle to findHoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if strcmp(get(handles.findHoles,'String'),'Find Holes')
        set(handles.findHoles,'String','Clear')
          % Camera is off. Change button string and start camera.
       image = getsnapshot(handles.video);
       [cols, rows] = find_holes(rgb2gray(im2double(image)));
    %    figure;
    %    imshow(image);
       stop(handles.video);
       hold on;
       plot(cols, rows, 'r*');
%         set(handles.video,'TimerPeriod', 0.5, ...
%           'TimerFcn',[sprintf('handles=guidata(gcf);image(getsnapshot(handles.video));set(handles.cameraAxes,''ytick'',[600],''xtick'',[800]);hold on; plot(800,600,''x'',''color'',''g''); plot(%i,%i,''r*''); hold off;',cols,rows)]);

    else
          % Camera is on. Stop camera and change button string.
          set(handles.findHoles,'String','Find Holes')
          start(handles.video)
    end
end

% --- Executes on button press in autofocus.
function autofocus_Callback(hObject, eventdata, handles)
% hObject    handle to autofocus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sixk;
if isempty(sixk)
    sixk = serial('COM6', 'BaudRate', 9600);
end
if isequal(sixk.status,'closed')
    fopen(sixk);
end
fprintf(sixk, 'DRIVE111');
mark = 0;
num_vectors = 30;
motor_step = 100;
scan_step = 100;
con = 1;
reference_image = getsnapshot(handles.video);
reference_image = rgb2gray(reference_image);
im_size = size(reference_image);
FSV_step = fix(im_size(1)/num_vectors);
%FSV_ref = zeros(1,num_vectors*im_size(2));
FSV_ref = zeros(im_size(1),num_vectors);
for j = 1:num_vectors
    FSV_ref(:,j) = abs(fft(reference_image(:,FSV_step*j)));
    %FSV_ref(im_size(1)*(j-1) +1: im_size(1)*j) = transpose(fft(reference_image(:,FSV_step*j)));

end
FSV_list = zeros(im_size(1),num_vectors,scan_step);

while con ==1
    corr_list = zeros(1,scan_step);
    if mark==1
        reference_image = getsnapshot(handles.video);
        reference_image = rgb2gray(reference_image);
        im_size = size(reference_image);
        FSV_step = fix(im_size(1)/num_vectors);
        %FSV_ref = zeros(1,num_vectors*im_size(2));
        FSV_ref = zeros(im_size(1),num_vectors);
        for j = 1:num_vectors
            FSV_ref(:,j) = abs(fft(reference_image(:,FSV_step*j)));
            %FSV_ref(im_size(1)*(j-1) +1: im_size(1)*j) = transpose(fft(reference_image(:,FSV_step*j)));

        end
    end
        
    for i = 1:scan_step
         fprintf(sixk, sprintf('D,,%i',motor_step)); % move in increments of 1mm.
         fprintf(sixk, 'GO,,1');
         pause(.05);
         disp(i)
        image =getsnapshot(handles.video);

        image = rgb2gray( image );
        im_size = size(image);
        FSV_step = fix(im_size(1)/num_vectors);
        FSV = zeros(im_size(1),num_vectors);
        for j = 1:num_vectors
            FSV(:,j) = abs(fft(image(:,FSV_step*j)));
            %FSV(im_size(1)*(j-1) +1: im_size(1)*j) = transpose(fft(reference_image(:,FSV_step*j)));
        end

        FSV_list(:,:,i) = FSV;
    end
    for i = 1:scan_step
        %correlation = corrcoef(transpose(FSV_list(i,:)),transpose(FSV_ref));
        correlation = corrcoef(FSV_ref,FSV_list(:,:,i));
        corr_list(i) = correlation(2,1);
    end
%     %go 75percent.
    if mark ==1
        [value,ind] = min(corr_list);
        
        fprintf(sixk,sprintf('D,,-%i',motor_step*(numel(corr_list)-ind+1)));
        fprintf(sixk,'GO,,1');
        
        
        
        %fprintf(sixk, 'DRIVE000');
        %fclose(sixk);
        break;
    end
    if min(corr_list) == corr_list(numel(corr_list))
        con = 1;
    else
        mark = 1;
        con = 1;
        [value,ind] = min(corr_list);
        
        fprintf(sixk,sprintf('D,,-%i',motor_step*(numel(corr_list)-ind +2)));
        motor_step = fix(motor_step/10);
        fprintf(sixk,'GO,,1');
    end
disp('done');
    
    
    
end
    disp('done');
end
    
% --- Executes on button press in Up.
function Up_Callback(hObject, eventdata, handles)
% hObject    handle to Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global move_matrix;
    global measured;
    if ~measured
        measure_Callback(hObject, eventdata, handles)
    end
    number = str2double(get(handles.move_unit,'String'));
    if isnan(number) || ~isnumeric(number)
        disp('Please provide a number');
    else
        vector = [0 str2double(get(handles.move_unit,'String'))] * move_matrix;
        vector = round(vector);
        str2double(get(handles.move_unit,'String'))
        disp(vector);
        global sixk;
        if isempty(sixk)
            sixk = serial('COM6', 'BaudRate', 9600);
        end
        if isequal(sixk.status,'closed')
            fopen(sixk);
        end
        fprintf(sixk, 'DRIVE111');
        pause(2);
        fprintf(sixk, sprintf('D%i,%i,%i',vector(1),vector(2),0));
        fprintf(sixk, 'GO1,1,1');
        %fprintf(sixk, 'DRIVE000');
        %fclose(sixk);
    end
    
        
end

% --- Executes on button press in Left.
function Left_Callback(hObject, eventdata, handles)
% hObject    handle to Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global move_matrix;
    global measured;
    if ~measured
        measure_Callback(hObject, eventdata, handles)
    end
    
    number = str2double(get(handles.move_unit,'String'));
    if isnan(number) || ~isnumeric(number)
        disp('Please provide a number');
    else
        vector = [-1*str2double(get(handles.move_unit,'String')) 0] * move_matrix;
        vector = round(vector);
        sixk = serial('COM6', 'BaudRate', 9600);
        global sixk;
        if isempty(sixk)
        	sixk = serial('COM6', 'BaudRate', 9600);
        end
        if isequal(sixk.status,'closed')
            fopen(sixk);
        end
        pause(2);
        fprintf(sixk, sprintf('D%i,%i,%i',vector(1),vector(2),0));
        fprintf(sixk, 'GO1,1,1');
        %fprintf(sixk, 'DRIVE000');
        %fclose(sixk);
    end
end
% --- Executes on button press in Right.
function Right_Callback(hObject, eventdata, handles)
% hObject    handle to Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global move_matrix;
    global measured;
    if ~measured
        measure_Callback(hObject, eventdata, handles)
    end
    
    number = str2double(get(handles.move_unit,'String'));
    if isnan(number) || ~isnumeric(number)
        disp('Please provide a number');
    else
        vector = [str2double(get(handles.move_unit,'String')) 0] * move_matrix;
        vector = round(vector);
        global sixk;
        if isempty(sixk)
            sixk = serial('COM6', 'BaudRate', 9600);
        end
        if isequal(sixk.status,'closed')
            fopen(sixk);
        end
        fprintf(sixk, 'DRIVE111');
        pause(2);
        fprintf(sixk, sprintf('D%i,%i,%i',vector(1),vector(2),0));
        fprintf(sixk, 'GO1,1,1');
        %fprintf(sixk, 'DRIVE000');
        %fclose(sixk);
    end
end


function move_unit_Callback(hObject, eventdata, handles)
% hObject    handle to move_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of move_unit as text
%        str2double(get(hObject,'String')) returns contents of move_unit as a double

end
% --- Executes during object creation, after setting all properties.
function move_unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to move_unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in measure.
function measure_Callback(hObject, eventdata, handles)
% hObject    handle to measure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    image = getsnapshot(handles.video);
    pause(2);
    [cols, rows] = find_holes(rgb2gray(im2double(image)));
    [x,ind] = max(cols);
    y = rows(ind);
%     figure; imshow(image); hold on; plot(x,y,'r*');
    global sixk;
    if isempty(sixk)
        sixk = serial('COM6', 'BaudRate', 9600);
    end
    if isequal(sixk.status,'closed')
        fopen(sixk);
    end
    fprintf(sixk, 'DRIVE111');
    pause(2);
    
    fprintf(sixk, 'D400,0,0');
    fprintf(sixk, 'GO1,,');
     fprintf(sixk, 'D-400,0,0');
    fprintf(sixk, 'GO1,,');
     fprintf(sixk, 'D400,0,0');
    fprintf(sixk, 'GO1,,');
    pause(3);
    image1 = getsnapshot(handles.video);
    pause(2);
    [cols, rows] = find_holes(rgb2gray(im2double(image1)));
    [x1,ind] = max(cols);
    y1 = rows(ind);
    %figure; imshow(image1); hold on; plot(x1,y1,'r*');
    x_vector = [x1-x y-y1];
    fprintf(sixk, 'D0,400,0');
    fprintf(sixk, 'GO,1,');
    pause(3);
    image2 = getsnapshot(handles.video);
    pause(2);
    fprintf(sixk, 'D-400,-400,0');
    fprintf(sixk, 'GO1,1,');
    %fprintf(sixk, 'DRIVE000');
    %fclose(sixk);
    [cols, rows] = find_holes(rgb2gray(im2double(image2)));
    [x2,ind] = max(cols);
    y2 = rows(ind);
    %figure; imshow(image2); hold on; plot(x2,y2,'r*');
    y_vector = [x2-x1 y1-y2];
    
    cols = [x,x1,x2]; rows = [y,y1,y2];
    unit_matrix = [x_vector ;y_vector];
    unit_matrix = inv(unit_matrix);
    disp(unit_matrix);
    global move_matrix;
    move_matrix = unit_matrix*400;
    disp('finished');
    global measured;
    measured = 1;



end


% --- Executes on button press in Down.
function Down_Callback(hObject, eventdata, handles)
% hObject    handle to Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global move_matrix;
    global measured;
    if ~measured
        measure_Callback(hObject, eventdata, handles)
    end
    number = str2double(get(handles.move_unit,'String'));
    if isnan(number) || ~isnumeric(number)
        disp('Please provide a number');
    else
        vector = [0 -str2double(get(handles.move_unit,'String'))] * move_matrix;
        vector = round(vector);
        global sixk;
        if isempty(sixk)
            sixk = serial('COM6', 'BaudRate', 9600);
        end
        if isequal(sixk.status,'closed')
            fopen(sixk);
        end
        fprintf(sixk, 'DRIVE111');
        pause(3);

        fprintf(sixk, sprintf('D%i,%i,%i',vector(1),vector(2),0));
        fprintf(sixk, 'GO111');
        pause(1);
        %fprintf(sixk, 'DRIVE000');
        %fclose(sixk);
    end
end



function laser_input_Callback(hObject, eventdata, handles)
% hObject    handle to laser_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of laser_input as text
%        str2double(get(hObject,'String')) returns contents of laser_input as a double

end
% --- Executes during object creation, after setting all properties.
function laser_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laser_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on button press in Laser.
function Laser_Callback(hObject, eventdata, handles)
% hObject    handle to Laser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    duration = str2double(get(handles.laser_input,'String'));
    if isnan(duration) || ~isnumeric(duration)
        disp('Please provide a number');
    else
        a=arduino('COM1');
        writeDigitalPin(a, 'D13', 1);
        pause(duration);
        writeDigitalPin(a, 'D13',0);
        clear a;
    end
    
    
end



function number_of_holes_Callback(hObject, eventdata, handles)
% hObject    handle to number_of_holes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of number_of_holes as text
%        str2double(get(hObject,'String')) returns contents of number_of_holes as a double
end

% --- Executes during object creation, after setting all properties.
function number_of_holes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to number_of_holes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in center_hole.
function center_hole_Callback(hObject, eventdata, handles)
% hObject    handle to center_hole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global x_1000;
global y_1000;
global x_200;
global y_200;

number = str2double(get(handles.number_of_holes,'String'));
if isnan(number) || ~isnumeric(number)
    disp('Please provide a number');
elseif (number > 36) || (number < 1)
    disp('Please enter a valid number from 1 to 36');
else

    %find_single_hole_autonomous(handles.video);
    
    %fopen(sixk);
    global sixk;
    if isempty(sixk)
        sixk = serial('COM6', 'BaudRate', 9600);
    end
    if isequal(sixk.status,'open')
        fclose(sixk);
    end
    
    %disp('starting');
    
    [x_1000, y_1000, x_200, y_200] = find_single_hole_autonomous_function(x_1000, y_1000, x_200, y_200, handles.video, number, sixk);
   
    %disp('ending');
    
    %fprintf(sixk, 'DRIVE111');
    %pause(2);
    %fprintf(sixk, sprintf('D%i,%i,%i',vector(1),vector(2),0));
    %fprintf(sixk, 'GO1,1,1');
    %fprintf(sixk, 'DRIVE000');
    
    %fclose(sixk);
end
end



function feeder_length_Callback(hObject, eventdata, handles)
% hObject    handle to feeder_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of feeder_length as text
%        str2double(get(hObject,'String')) returns contents of feeder_length as a double

end

% --- Executes during object creation, after setting all properties.
function feeder_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to feeder_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% % --- Executes on button press in feeder.
% function feeder_Callback(hObject, eventdata, handles)
% % hObject    handle to feeder (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% number = str2double(get(handles.feeder_length,'String'));
% if isnan(number) || ~isnumeric(number)
%     disp('Please provide a number');
% else
%     feed = serial('COM12','BaudRate',9600);
%     fopen(feed);
%     pause(3);
%     fwrite(feed,'2'); % reverse command to serial object
%     fwrite(feed,get(handles.feeder_length,'String'));
%     pause(1);
%     fclose(feed);
%     disp('done');
% end
% end

% --- Executes on button press in feeder.
function feeder_Callback(hObject, eventdata, handles)
% hObject    handle to feeder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

number = str2double(get(handles.feeder_length,'String'));   %entered value --> double
if isnan(number) || ~isnumeric(number)
    disp('Please provide a number');
else
    
    feeder = serial('COM12');
    fopen(feeder);
    disp('Matlab serial object opened')
   
    while(1)                        %wait for arduino ready
        if(feeder.BytesAvailable)
            disp(fgetl(feeder));
            break;
        end
    end
    
    fprintf(feeder, get(handles.feeder_length,'String'));

    while(1)                        %wait for response from arduino
        if(feeder.BytesAvailable)
            disp(fgetl(feeder));
            break;
        end
    end
    fclose(feeder);
end

% number = str2double(get(handles.feeder_length,'String'));   %entered value --> double
% if isnan(number) || ~isnumeric(number)
%     disp('Please provide a number');
% else
%     feeder = serial('COM12','BaudRate',9600);
%     fopen(feeder);
%     pause(1);
%     if(number < 0)
%         fwrite(feeder,'1') %'forward' command to retract fiber
%     else
%         fwrite(feeder,'2'); % 'reverse' command to advance fiber
%     end
%     fwrite(feeder,num2str(abs(number));
%     pause(1);
%     fclose(feeder);
%     disp('done');
% end
end

% disable all motor drivers; useful if stage is about to crash
% --- Executes on button press in kill.
function kill_Callback(hObject, eventdata, handles)
% hObject    handle to kill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global sixk;
    if isempty(sixk)
        sixk = serial('COM6', 'BaudRate', 9600);
    end
    if isequal(sixk.status,'closed')
        fopen(sixk);
    end
    fprintf(sixk, '!K');            % forces immediate STOP
    fprintf(sixk, 'DRIVE000');
    %fclose(sixk);
    
    MyCameraGUI_CloseRequestFcn(hObject, eventdata, handles);
end


% --- Executes on button press in mark.
function mark_Callback(hObject, eventdata, handles)
% hObject    handle to mark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.mark,'String'),'Mark')
    set(handles.mark,'String','Clear')
    [x,y] = ginput(1);
    set(handles.video,'TimerPeriod', 0.1, ...
          'TimerFcn',[sprintf('handles=guidata(gcf);image(getsnapshot(handles.video));set(handles.cameraAxes,''ytick'',[],''xtick'',[]);hold on; plot(800,600,''x'',''color'',''g''); plot(%i,%i,''r*''); hold off;',x,y)]);
else
    set(handles.mark,'String','Mark');
    CameraLoop_basic(handles.video);
end
end
 


% --- Executes on button press in RaisePlatform.
function RaisePlatform_Callback(hObject, eventdata, handles)
% hObject    handle to RaisePlatform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global sixk;
    if isempty(sixk)
        sixk = serial('COM6', 'BaudRate', 9600);
    end
    if isequal(sixk.status,'closed')
        fopen(sixk);
    end
    fprintf(sixk, 'DRIVE111');
    pause(2);
    fprintf(sixk, sprintf('D%i,%i,%i',0,0,-100));
    fprintf(sixk, 'GO1,1,1');
    %fprintf(sixk, 'DRIVE000');
    %fclose(sixk);
end

% --- Executes on button press in LowerPlatform.
function LowerPlatform_Callback(hObject, eventdata, handles)
% hObject    handle to LowerPlatform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global sixk;
    if isempty(sixk)
        sixk = serial('COM6', 'BaudRate', 9600);
    end
    if isequal(sixk.status,'closed')
        fopen(sixk);
    end
    fprintf(sixk, 'DRIVE111');
    pause(2);
    fprintf(sixk, sprintf('D%i,%i,%i',0,0,100));
    fprintf(sixk, 'GO1,1,1');
    %fprintf(sixk, 'DRIVE000');
    %fclose(sixk);
end
