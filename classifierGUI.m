function classifierGUI
%CLASSIFIERGUI builds a GUI which can be used for detecting diabetic
%retinopathy in fundus images. The classifier assigns an integer grade in
%the range 1-4 depending on the severity of the disease. The user has the
%option to choose either a pre-trained classifier (an artificial neural
%network) which meets WHO standards or to train their own neural network
%until a desired accuracy, sensitivity and specificity has been reached.

    % Load training set and pre-trained network
    load('feat3', 'feat3');
    load('nn_targ3', 'nn_targ3');
    load('targ2', 'targ2');
    load('neuralnetconfig', 'net');
    
    % Initialize some variables
    trained_net = net;
    net = [];
    fname = '';
    pre_trained_ch = 1;
    epoch = 10;
    
    %% Create GUI layout
    f = figure('Visible','off','Name','DR Classifier','Position',...
        [200,100,1000,550],'NumberTitle','off','MenuBar','none',...
        'Resize','off');
    hp = uipanel('Position',[.02 .02 .27 .81],'Visible','off');
    hp2 = uipanel('Position',[.02 .02 .27 .81]);
    hp3 = uipanel('Position',[.02 .02 .27 .81],'Visible','off');
    inst  = uicontrol('Style','text','FontSize',15,'String',...
        ['Choose a pre-trained classifier or select a new one to train',...
        ' and then select an image to classify:'],...
        'Position',[20,515,950,30],'HorizontalAlignment','left');
    inst2  = uicontrol('Style','text','FontSize',15,'String',...
        ['Welcome! This tool may be used to detect the presence of ',...
        'Diabetic Retinopathy in fundus images. Images will be ',...
        'graded in integer numbers on a scale of 1 to 4 where 1 ',...
        'indicates the absence of the disease, while grades 2, 3, and ',...
        '4 represent increasing severity of the disease. Select one of '...
        'the options on the panel on the left to continue.'],...
        'Units','normalized','Position',[0.33 0.3 0.6 0.3],...
        'HorizontalAlignment','left');
    selectimg = uicontrol('Style','pushbutton','FontSize',15,'Enable','off',...
             'String','Select image','Position',...
             [20,480,150,30],'Callback',@select_image_Callback);
    
    %hp panel components
    htext  = uicontrol('Parent',hp,'Style','text','String',...
        ['Re-train the classifier as many times as you like until a desired'...
        ' accuracy is reached.'],'Position',[15,30,230,400],...
        'FontSize',15,'HorizontalAlignment','left');
    hconfig1 = uicontrol('Parent',hp,'Style','text','FontSize',15,...
           'String','Accuracy:','Position',[15,260,99,30]);
    hconfig2 = uicontrol('Parent',hp,'Style','text','FontSize',15,...
           'String','Sensitivity:','Position',[15,230,102,30]);
    hconfig3 = uicontrol('Parent',hp,'Style','text','FontSize',15,...
           'String','Specificity:','Position',[15,200,103,30]);
    acctxt  = uicontrol('Parent',hp,'Style','text','FontSize',15,'Position',...
             [125,260,120,25],'String','','HorizontalAlignment','left');
    sentxt = uicontrol('Parent',hp,'Style','text','FontSize',15,'Position',...
             [125,230,120,25],'String','','HorizontalAlignment','left');
    spctxt = uicontrol('Parent',hp,'Style','text','FontSize',15,'Position',...
             [125,200,120,25],'String','','HorizontalAlignment','left');
    popuptxt = uicontrol('Parent',hp,'Style','text','FontSize',15,'Position',...
             [15,160,200,30],'String','Set max. epochs: ',...
             'HorizontalAlignment','left');
    train = uicontrol('Parent',hp,'Style','pushbutton','FontSize',15,'String',...
            '(Re)Train','Position',[120,127,100,32],...
            'Callback',@trainbutton_Callback);
    hpopup = uicontrol('Parent',hp,'Style','popupmenu',...
           'String',{'10','100','1000'},'FontSize',15,'Callback',@pop_up_Callback,...
           'Position',[15,136,90,23]);
    classify = uicontrol('Parent',hp,'Style','pushbutton',...
             'String','Classify Image','Position',[15,85,140,30],...
             'Callback',@classifybutton_Callback,'FontSize',15);
    back = uicontrol('Parent',hp,'Style','pushbutton',...
             'String','Back','Position',[15,15,90,30],...
             'Callback',@backbutton_Callback,'FontSize',15);
    
    % hp2 panel components     
    bg = uibuttongroup('Parent',hp2,'Visible','off','BorderType','none',...
                  'Position',[0.04 0.04 0.95 0.95],'FontSize',15,...
                  'SelectionChangedFcn',@bselection,...
                  'Title','Choose an option below:');
    r1 = uicontrol(bg,'Style',...
                  'radiobutton',...
                  'String','Pre-trained classifier',...
                  'Position',[1 330 200 30],...
                  'HandleVisibility','on','FontSize',13);
              
    r2 = uicontrol(bg,'Style','radiobutton',...
                  'String','Train a classifier',...
                  'Position',[1 270 150 30],...
                  'HandleVisibility','off','FontSize',13);          
    bg.Visible = 'on';
    proceed = uicontrol('Parent',hp2,'Style','pushbutton',...
             'String','Proceed','Position',[17,200,90,25],...
             'Callback',@proceedbutton_Callback,'FontSize',15);

    % hp3 panel components
    htext  = uicontrol('Parent',hp3,'Style','text','String',...
        ['Use the built-in classifier to grade images right away. The '...
        'classifier has been pre-trained to satisfy WHO standards (Min. ',...
        'Sensitivity = 80%, Min. Specificity = 95%).'],...
        'Position',[15,30,230,400],'HorizontalAlignment','left','FontSize',15);
    hconfig1 = uicontrol('Parent',hp3,'FontSize',15,'Style','text',...
           'String','Accuracy:','Position',[15,230,99,30]);
    hconfig2 = uicontrol('Parent',hp3,'FontSize',15,'Style','text',...
           'String','Sensitivity:','Position',[15,200,102,30]);
    hconfig3 = uicontrol('Parent',hp3,'FontSize',15,'Style','text',...
           'String','Specificity:','Position',[15,170,103,30]);
    acctxt3  = uicontrol('Parent',hp3,'FontSize',15,'Style','text','Position',...
             [125,230,120,25],'String','90.3%','HorizontalAlignment','left');
    sentxt3 = uicontrol('Parent',hp3,'FontSize',15,'Style','text','Position',...
             [125,200,120,25],'String','85.9%','HorizontalAlignment','left');
    spctxt3 = uicontrol('Parent',hp3,'FontSize',15,'Style','text','Position',...
             [125,170,120,25],'String','95.4%','HorizontalAlignment','left');
    classify2 = uicontrol('Parent',hp3,'FontSize',15,'Style','pushbutton',...
             'String','Classify Image','Position',[15,100,160,30],...
             'Callback',@classifybutton_Callback);
    back2 = uicontrol('Parent',hp3,'FontSize',15,'Style','pushbutton',...
             'String','Back','Position',[15,15,90,25],...
             'Callback',@backbutton_Callback);
         
    % Global text
    fntext  = uicontrol('Style','text','Position',[170,480,900,30],'FontSize',13);
    predtxt  = uicontrol('Style','text','FontSize',14,'Position',...
                        [35,70,250,25],'FontWeight','bold',...
                        'HorizontalAlignment','left');

    f.Visible = 'on';
    
    %%  Callback and helper functions
    % Callback function for selecting an image
    function select_image_Callback(~, ~)
      [filename, pathname] = uigetfile({'*.tif';'*.gif';'*.png';...
                '*.jpeg';'*.jpg'});
      oldfname = fname;
      fname = strcat(pathname, filename);
      if size(fname, 2) > 0
        fntext.String = fname;
        axes('Units','normalized','Position',[0.3 0.03 0.7 0.8]);
        imshow(imread(fname))
      else fname = oldfname;
      end
    end

    % Callback function for training
    function trainbutton_Callback(~, ~) 
        back.Enable = 'off';
        back2.Enable = 'off';
        selectimg.Enable = 'off';
        train.Enable = 'off';
        classify.Enable = 'off';
        classify2.Enable = 'off';
        
        [net, acc, sen, spc] = neuralnetscript(feat3, nn_targ3, epoch);
        acctxt.String = strcat(num2str(acc*100,'%2.1f'),'%');
        sentxt.String = strcat(num2str(sen*100,'%2.1f'),'%');
        spctxt.String = strcat(num2str(spc*100,'%2.1f'),'%');
        
        back.Enable = 'on';
        back2.Enable = 'on';
        selectimg.Enable = 'on';
        train.Enable = 'on';
        classify.Enable = 'on';
        classify2.Enable = 'on';
    end

    % Callback function for back button
    function backbutton_Callback(~, ~)
        if pre_trained_ch == 1
            hp3.Visible = 'off';
        else hp.Visible = 'off';
        end
        selectimg.Enable = 'on';
        hp2.Visible = 'on';
        net = [];
    end

    % Helper function for extracting features for classifying an image
    function feat = extractFeatures
        % Disable buttons
        back.Enable = 'off';
        back2.Enable = 'off';
        selectimg.Enable = 'off';
        train.Enable = 'off';
        classify.Enable = 'off';
        classify2.Enable = 'off';
        
        predtxt.String = 'Extracting features...';
        pause(0.5)
        
        img = imread(fname);
        
        % Extract statistical features
        feat=featExtract(im2uint8(img));
        img = imresize(img, [447, 672]);
        [radii, centers, od2eye]=opticdisc(img);
        
        % Extract disease specific features
        % 1. AVR
        if numel(radii) == 0
           feat(15) = 0;
        else
           radii = radii(1);
           centers = centers(1, :);
           [feat(15), ~, ~] = avr(img, radii, centers);
        end
        
        % 2. Blood vessel pixel density
        mask = im2bw(img(:,:,1), 0.03);
        bv = bloodvessel(img, mask);
        feat(16) = numel(find(bv == 1))/numel(find(mask == 1));
        
        % 3. Exudate pixel density
        feat(17) = exudate(img);
        
        % 4. od2eye ratio
        feat(18) = od2eye;
        
        % Risk of macular oedema
        risk = ...
           inputdlg('Enter risk of macular edema (0,1,2)');
        risk = str2num(cell2mat(risk));
        if risk == 0 || risk == 1 || risk == 2
           feat(19) = risk;
        else 
           msgbox('Incorrect value, setting risk to 0',...
              'Error','error');
           feat(19) = 0;
        end
        
        % Enable buttons again
        back.Enable = 'on';
        back2.Enable = 'on';
        selectimg.Enable = 'on';
        train.Enable = 'on';
        classify.Enable = 'on';
        classify2.Enable = 'on';
    end

    % Callback function for classify button
    function classifybutton_Callback(~, ~)
        if pre_trained_ch == 0 && ~isa(net, 'network')
            msgbox('Please train the classifier first.',...
                'No classifier','error');
        else
            if size(fname, 2) > 0
                % Extract features and predict grade
                feat = real(extractFeatures);
                [~,pred] = max(net(feat));
                predtxt.String = strcat('Predicted Grade: ',num2str(pred));
                
            else
               msgbox('No input image selected.',...
                'File not selected','error'); 
            end
        end
    end

    % Function for the radio button group
    function bselection(~, ~)
       % Toggle selection
       pre_trained_ch = 1 - pre_trained_ch;
    end

    % Callback function for the proceed button
    function proceedbutton_Callback(~, ~)
       hp2.Visible = 'off';
       inst2.Visible = 'off';
       selectimg.Enable = 'on';
       if pre_trained_ch == 1
           % If pre-trained neural net is selected
           hp3.Visible = 'on';
           net = trained_net;
       else
           % If train new classifier is selected
           hp.Visible = 'on';
       end
    end
    
    function pop_up_Callback(source, ~)
      val = get(source,'Value');
      % Set epoch to user choice 
      if val == 1
          epoch = 10;
      elseif val == 2
          epoch = 100;
      else epoch = 1000;
      end
    end
end