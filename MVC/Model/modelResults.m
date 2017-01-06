classdef modelResults < handle
    %modelResults   Model of the results-MVC (Model-View-Controller). Runs
    %all nessesary calculations. Is connected and gets controlled by the
    %correspondening Controller.
    %The main tasks are:
    %   - calculate all area features.
    %   - calculate all fiber features.
    %   - transform Stats tabel to numerical structs
    %   - specify all fiber objects with the given parameters.
    %   - preparing the data to save.
    %   - save data.
    %
    %
    %======================================================================
    %
    % AUTHOR:           - Sebastian Friedrich,
    %                     Trier University of Applied Sciences, Germany
    %
    % SUPERVISOR:       - Prof. Dr.-Ing. K.P. Koch
    %                     Trier University of Applied Sciences, Germany
    %
    %                   - Mr Justin Perkins, BVetMed MS CertES Dip ECVS MRCVS
    %                     The Royal Veterinary College, Hertfordshire United Kingdom
    %
    % FIRST VERSION:    30.12.2016 (V1.0)
    %
    % REVISION:         none
    %
    %======================================================================
    %
    
    properties
       
        controllerResultsHandle; %hande to controllerResults instance.
        
    end
    
    properties
        FileNamesRGB; %Filename of the selected RGB image.
        PathNames; %Directory path of the selected RGB image.
        PicRGB; %RGB image.
        handlePicRGB; %handle to RGB image.
        PicPRGBPlanes; %RGB image created from the color plane images.
        
        SaveFiberTable; %Indicates whether the fiber type table should be saved.
        SaveStatisticTable; %Indicates whether the statistics table should be saved.
        SavePlots; %Indicates whether the statistics plots should be saved.
        SavePicProcessed; %Indicates whether the processed image should be saved.
        SavePlanePicture; %Indicates whether the color-plane image should be saved.
        SavePath; % Save Path, same as the selected RGB image path.
        
        LabelMat; %Label array of all fiber objects.
        
        %Analyze parameters
        AnalyzeMode; %Indicates the selected analyze mode.
        AreaActive; %Indicates if Area parameter is used for classification.
        MinAreaPixel; %Minimal allowed Area. Is used for classification. Smaller Objects will be removed from binary mask.
        MaxAreaPixel; %Maximal allowed Area. Is used for classification. Larger Objects will be classified as Type 0.
        AspectRatioActive; %Indicates if AspectRatio parameter is used for classification.
        MinAspectRatio; %Minimal allowed AspectRatio. Is used for classification. Objects with smaller AspectRatio will be classified as Type 0.
        MaxAspectRatio; %Minimal allowed AspectRatio. Is used for classification. Objects with larger AspectRatio will be classified as Type 0.
        RoundnessActive; %Indicates if Roundness parameter is used for classification.
        MinRoundness; %Minimal allowed Roundness. Is used for classification. Objects with smaller Roundness will be classified as Type 0.
        ColorDistanceActive; %Indicates if ColorDistance parameter is used for classification.
        MinColorDistance; %Minimal allowed ColorDistance. Is used for classification. Objects with smaller ColorDistance will be classified as Type 3.
        ColorValueActive; %Indicates if ColorValue parameter is used for classification.
        ColorValue; %Minimal allowed ColorValue. Is used for classification. Objects with smaller ColorValue will be classified as Type 0.
        
        NoOfObjects; %Number of objects.
        NoTyp1; %Number of Type 1 fibers.
        NoTyp2; %Number of Type 2 fibers.
        NoTyp3; %Number of Type 3 fibers.
        NoTyp0; %Number of Type 0 fibers.
        
        AreaPic; % Total area of the RGB image.
        AreaType1; % Total area of all type 1 fibers.
        AreaType2; % Total area of all type 2 fibers.
        AreaType3; % Total area of all type 3 fibers.
        AreaType0; % Total area of all type 0 fibers.
        AreaFibers; % Total area of all fiber objects.
        AreaNoneObj % Total area that contains no objects.
        
        AreaType1PC; % Area of all type 1 fibers in percent.
        AreaType2PC; % Aarea of all type 2 fibers in percent.
        AreaType3PC; % Area of all type 3 fibers in percent.
        AreaType0PC; % Area of all type 0 fibers in percent.
        AreaFibersPC; % Area of all fiber objects in percent.
        AreaNoneObjPC; % Area that contains no objects in percent.
        
        AreaMinMax; %Vector, contains the [min max] area in pixel of all objects.
        AreaMinMaxObj; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of all objects.
        AreaMinMaxT1; %Vector, contains the [min max] area in pixel of Type 1 fibers.
        AreaMinMaxObjT1; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 1 fibers.
        AreaMinMaxT2; %Vector, contains the [min max] area in pixel of Type 2 fibers.
        AreaMinMaxObjT2; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 2 fibers.
        AreaMinMaxT3; %Vector, contains the [min max] area in pixel of Type 3 fibers.
        AreaMinMaxObjT3; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 3 fibers.
        AreaMinMaxT0; %Vector, contains the [min max] area in pixel of Type 0 fibers.
        AreaMinMaxObjT0; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 0 fibers.
        
        Stats; % Data struct of all fiber objets
        
        StatsMatData; % Contains the numerical data of all fiber objets.
        % [LabelNO Area XPos YPos MinorAxis MajorAxis Perimeter Roundness ...
        %  AspectRatio meanRed meanGreen meanBlue meanFarRed meanColorValue ...
        %  meanColorHue RationBlueRed DistBlueRed FiberType]
        StatsMatDataT1; % Contains the numerical data of all type 1 fiber objets.
        StatsMatDataT2; % Contains the numerical data of all type 2 fiber objets.
        StatsMatDataT3; % Contains the numerical data of all type 3 fiber objets.
        StatsMatDataT0; % Contains the numerical data of all type 0 fiber objets.
        
        StatisticMat; % Contains the statistc data af the ruslts.
        
        
    end
    
    properties(SetObservable)
        
        InfoMessage;
        
    end
    
    methods
        
        function obj = modelResults()
            % Constuctor of the modelResults class.
            %
            %   obj = modelResults();
            %
            %   ARGUMENTS:
            %
            %       - Input
            %
            %       - Output
            %           obj:    Handle to modelResults object.
            %
             
        end
        
        function startResultMode(obj)
            % Called by the controller when the program change in the
            % rsults stage. Calls all culculation functions and GUI update
            % functions.
            %
            %   startResultMode(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            
            obj.InfoMessage = '- updating GUI';
            
            obj.transformDataStructToMatrix();
            
            obj.calculateAreaFeatures();
            
            obj.calculateFiberFeatures();
            
            obj.createMatStatisticTable();
            
            obj.controllerResultsHandle.showAxesDataInGUI();
            
            obj.controllerResultsHandle.showInfoInTableGUI();
            
            obj.controllerResultsHandle.showPicProcessedGUI();
            
            obj.InfoMessage = '- updating GUI complete';
        end
        
        function transformDataStructToMatrix(obj)
            % Ttransforms the Stats table in numerical data array.
            %
            %   transformDataStructToMatrix(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            obj.InfoMessage = '   - Transform data to Matrix';
            
            LabelNo = [1:1:length(obj.Stats)]';
            StatsArea = [obj.Stats.Area]';
            StatsAspectRatio = [obj.Stats.AspectRatio]';
            StatsRoundness = [obj.Stats.Roundness]';
            StatsColorRed = [obj.Stats.ColorRed]';
            StatsColorFarRed = [obj.Stats.ColorFarRed]';
            StatsColorBlue = [obj.Stats.ColorBlue]';
            StatsColorGreen = [obj.Stats.ColorGreen]';
            StatsColorHue = [obj.Stats.ColorHue]';
            StatsColorValue = [obj.Stats.ColorValue]';
            StatsColorRatioBlueRed = [obj.Stats.ColorRatioBlueRed]';
            StatsColorDistBlueRed = [obj.Stats.ColorDistBlueRed]';
            StatsFiberType = [obj.Stats.FiberType]';
            StatsMinorAxis = [obj.Stats.MinorAxisLength]';
            StatsMajorAxis = [obj.Stats.MajorAxisLength]';
            StatsPerimeter = [obj.Stats.Perimeter]';
            
            for i=1:1:length(obj.Stats)
                StatsFCPX(i,1) = round(obj.Stats(i).Centroid(1));
                StatsFCPY(i,1) = round(obj.Stats(i).Centroid(2));
            end
            
            obj.StatsMatData = cat(2,LabelNo,StatsArea,StatsFCPX,StatsFCPY,...
                StatsMinorAxis,StatsMajorAxis,StatsPerimeter,...
                StatsRoundness,StatsAspectRatio,...
                StatsColorRed,StatsColorGreen,StatsColorBlue,StatsColorFarRed,...
                StatsColorValue,StatsColorHue,...
                StatsColorRatioBlueRed,StatsColorDistBlueRed,StatsFiberType);
            
            % Create DataMat only for Type 1 Fiber objects
            ind = find(obj.StatsMatData(:,18)==1);
            obj.StatsMatDataT1 = obj.StatsMatData(ind,:);
            
            % Create DataMat only for Type 2 Fiber objects
            ind = find(obj.StatsMatData(:,18)==2);
            obj.StatsMatDataT2 = obj.StatsMatData(ind,:);
            
            % Create DataMat only for Type 3 Fiber objects
            ind = find(obj.StatsMatData(:,18)==3);
            obj.StatsMatDataT3 = obj.StatsMatData(ind,:);
            
            % Create DataMat only for Type 0 Fiber objects
            ind = find(obj.StatsMatData(:,18)==0);
            obj.StatsMatDataT0 = obj.StatsMatData(ind,:);
            
            
        end
        
        function calculateAreaFeatures(obj)
            % Claculate all area features.
            %
            %   calculateAreaFeatures(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            
            obj.InfoMessage = '   - Calculate fiber type areas';
            obj.AreaPic = size(obj.PicRGB,1) * size(obj.PicRGB,2);
            obj.AreaType1 = 0;
            obj.AreaType2 = 0;
            obj.AreaType3 = 0;
            obj.AreaType0 = 0;
            obj.AreaFibers = 0;
            
            obj.NoOfObjects = length(obj.Stats);
            
            for i=1:1:obj.NoOfObjects;
                
                %Calculate total area of exh Fiber type
                if obj.Stats(i).FiberType == 1
                    % Blue Fiber
                    
                    % Total area of all type 1 fibers
                    obj.AreaType1 = obj.AreaType1 + obj.Stats(i).Area;
                    
                elseif obj.Stats(i).FiberType == 2
                    % Red Fiber
                    
                    % Total area of all type 2 fibers
                    obj.AreaType2 = obj.AreaType2 + obj.Stats(i).Area;
                    
                elseif obj.Stats(i).FiberType == 3
                    % between Red and Blue
                    
                    % Total area of all type 3 fibers
                    obj.AreaType3 = obj.AreaType3 + obj.Stats(i).Area;
                    
                elseif obj.Stats(i).FiberType == 0
                    % No Fiber
                    
                    % Total area of all type 0 fibers
                    obj.AreaType0 = obj.AreaType0 + obj.Stats(i).Area;
                    
                else
                    % Error Code
                end
                
            end
            
            % Total area of all fiber objects including Type 0
            obj.AreaFibers = obj.AreaType1+obj.AreaType2+obj.AreaType3+obj.AreaType0;
            % Total area that consots no Objects
            obj.AreaNoneObj = obj.AreaPic - obj.AreaFibers;
            
            % Calculate area in percent of Fibertypes related to the original image
            obj.AreaType1PC = obj.AreaType1/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType1PC) ' % of the image consists of Type 1 fibers'];
            
            obj.AreaType2PC = obj.AreaType2/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType2PC) ' % of the image consists of Type 2 fibers'];
            
            obj.AreaType3PC = obj.AreaType3/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType3PC) ' % of the image consists of Type 3 fibers'];
            
            obj.AreaType0PC = obj.AreaType0/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType0PC) ' % of the image consists of Type 0 fibers'];
            
            obj.AreaNoneObjPC = 100 - obj.AreaType1PC - obj.AreaType2PC - obj.AreaType3PC - obj.AreaType0PC;
            obj.InfoMessage = ['      - ' num2str(obj.AreaNoneObjPC) '% of the image consists no Objects'];
            pause(0.01);
            
            % Find object with the smallest area
            obj.AreaMinMax(1) = min([obj.Stats.Area]);
            obj.AreaMinMaxObj(1) = find([obj.Stats.Area]==obj.AreaMinMax(1),1);
            obj.InfoMessage = ['      - Fiber ' num2str(obj.AreaMinMaxObj(1)) ' has the smallest area with ' num2str(obj.AreaMinMax(1)) ' pixels'];
            
            % Find object with the largest area
            obj.AreaMinMax(2) = max([obj.Stats.Area]);
            obj.AreaMinMaxObj(2) = find([obj.Stats.Area]==obj.AreaMinMax(2),1);
            obj.InfoMessage = ['      - Fiber ' num2str(obj.AreaMinMaxObj(2)) ' has the largest area with ' num2str(obj.AreaMinMax(2)) ' pixels'];
           
            % Find samlest and largest Fiber of each Type
            
            if ~isempty(obj.StatsMatDataT1)
                obj.AreaMinMaxT1(1) = min(obj.StatsMatDataT1(:,2));
                obj.AreaMinMaxObjT1(1) = obj.StatsMatDataT1( find(obj.StatsMatDataT1(:,2)==obj.AreaMinMaxT1(1),1) ,1);
                obj.AreaMinMaxT1(2) = max(obj.StatsMatDataT1(:,2));
                obj.AreaMinMaxObjT1(2) = obj.StatsMatDataT1( find(obj.StatsMatDataT1(:,2)==obj.AreaMinMaxT1(2),1) ,1);
            else
                obj.AreaMinMaxT1(1) = 0;
                obj.AreaMinMaxObjT1(1) = 0;
                obj.AreaMinMaxT1(2) = 0;
                obj.AreaMinMaxObjT1(2) = 0;
            end
            
            if ~isempty(obj.StatsMatDataT2)
                obj.AreaMinMaxT2(1) = min(obj.StatsMatDataT2(:,2));
                obj.AreaMinMaxObjT2(1) = obj.StatsMatDataT2( find(obj.StatsMatDataT2(:,2)==obj.AreaMinMaxT2(1),1) ,1);
                obj.AreaMinMaxT2(2) = max(obj.StatsMatDataT2(:,2));
                obj.AreaMinMaxObjT2(2) = obj.StatsMatDataT2( find(obj.StatsMatDataT2(:,2)==obj.AreaMinMaxT2(2),1) ,1);
            else
                obj.AreaMinMaxT2(1) = 0;
                obj.AreaMinMaxObjT2(1) = 0;
                obj.AreaMinMaxT2(2) = 0;
                obj.AreaMinMaxObjT2(2) = 0;
            end
            
            if ~isempty(obj.StatsMatDataT3)
                obj.AreaMinMaxT3(1) = min(obj.StatsMatDataT3(:,2));
                obj.AreaMinMaxObjT3(1) = obj.StatsMatDataT3( find(obj.StatsMatDataT3(:,2)==obj.AreaMinMaxT3(1),1) ,1);
                obj.AreaMinMaxT3(2) = max(obj.StatsMatDataT3(:,2));
                obj.AreaMinMaxObjT3(2) = obj.StatsMatDataT3( find(obj.StatsMatDataT3(:,2)==obj.AreaMinMaxT3(2),1) ,1);
            else
                obj.AreaMinMaxT3(1) = 0;
                obj.AreaMinMaxObjT3(1) = 0;
                obj.AreaMinMaxT3(2) = 0;
                obj.AreaMinMaxObjT3(2) = 0;
            end
            
            if ~isempty(obj.StatsMatDataT0)
                obj.AreaMinMaxT0(1) = min(obj.StatsMatDataT0(:,2));
                obj.AreaMinMaxObjT0(1) = obj.StatsMatDataT0( find(obj.StatsMatDataT0(:,2)==obj.AreaMinMaxT0(1),1) ,1);
                obj.AreaMinMaxT0(2) = max(obj.StatsMatDataT0(:,2));
                obj.AreaMinMaxObjT0(2) = obj.StatsMatDataT0( find(obj.StatsMatDataT0(:,2)==obj.AreaMinMaxT0(2),1) ,1);
            else
                obj.AreaMinMaxT0(1) = 0;
                obj.AreaMinMaxObjT0(1) = 0;
                obj.AreaMinMaxT0(2) = 0;
                obj.AreaMinMaxObjT0(2) = 0;
            end
            
        end
        
        function calculateFiberFeatures(obj)
            % Claculate all fiber features.
            %
            %   calculateFiberFeatures(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            
            obj.InfoMessage = '   - Calculate fiber type numbers';
            % Number of Fiber Objects
            obj.NoTyp1 = size(obj.StatsMatDataT1,1); % Type 1
            obj.NoTyp2 = size(obj.StatsMatDataT2,1); % Type 2
            obj.NoTyp3 = size(obj.StatsMatDataT3,1); % Type 3
            obj.NoTyp0 = size(obj.StatsMatDataT0,1); % Type 0
            
            
        end
        
        function createMatStatisticTable(obj)
            % Create table that is shown in the statistic tab in the GUI.
            %
            %   createMatStatisticTable(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            
            obj.StatisticMat = {}; 
            
            obj.StatisticMat = {'Analyze Mode','Para min area','Para max area',...
                'Para min Asp.Ratio','Para max Asp.Ratio',...
                'Para min Roundn.','Para min Colordist.',...
                'Para min ColorVal.',...
                'Number Objects',...
                'Number Type 1','Number Type 2','Number Type 3','Number Type 0',...
                'Area Type 1','Area Type 2','Area Type 3','Area Type 0',...
                'Area Type 1 in %','Area Type 2 in %','Area Type 3 in %','Area Type 0 in %',...
                'Smallest Area','Smalest Fiber','Largest Area','Largest Fiber',...
                'Smallest Area T1','Smalest Fiber T1','Largest Area T1','Largest Fiber T1',...
                'Smallest Area T2','Smalest Fiber T2','Largest Area T2','Largest Fiber T2',...
                'Smallest Area T3','Smalest Fiber T3','Largest Area T3','Largest Fiber T3'}';
            
            switch obj.AnalyzeMode
                case 1
                    obj.StatisticMat{1,2} =  'Colordistance';
                case 2
                    obj.StatisticMat{1,2} =  'Cluster 2 Types';
                case 3
                    obj.StatisticMat{1,2} =  'Cluster 3 Types';
            end

            if obj.AreaActive
                obj.StatisticMat{2,2} =  obj.MinAreaPixel;
                obj.StatisticMat{3,2} =  obj.MaxAreaPixel;
            else
                obj.StatisticMat{2,2} =  'not active';
                obj.StatisticMat{3,2} =  'not active';
            end
            
            if obj.AspectRatioActive
                obj.StatisticMat{4,2} =  obj.MinAspectRatio;
                obj.StatisticMat{5,2} =  obj.MaxAspectRatio;
            else
                obj.StatisticMat{4,2} =  'not active';
                obj.StatisticMat{5,2} =  'not active';
            end
            
            if obj.RoundnessActive
                obj.StatisticMat{6,2} =  obj.MinRoundness;
            else
                obj.StatisticMat{6,2} =  'not active';
            end
            
            if obj.ColorDistanceActive
                obj.StatisticMat{7,2} =  obj.MinColorDistance;
            else
                obj.StatisticMat{7,2} =  'not active';
            end
            
            if obj.ColorValueActive
                obj.StatisticMat{8,2} =  obj.ColorValue;
            else
                obj.StatisticMat{8,2} =  'not active';
            end
            
            obj.StatisticMat{9,2} =  obj.NoOfObjects;
            obj.StatisticMat{10,2} =  obj.NoTyp1;
            obj.StatisticMat{11,2} =  obj.NoTyp2;
            obj.StatisticMat{12,2} =  obj.NoTyp3;
            obj.StatisticMat{13,2} =  obj.NoTyp0;
            
            obj.StatisticMat{14,2} =  obj.AreaType1;
            obj.StatisticMat{15,2} =  obj.AreaType2;
            obj.StatisticMat{16,2} =  obj.AreaType3;
            obj.StatisticMat{17,2} =  obj.AreaType0;
            
            obj.StatisticMat{18,2} =  obj.AreaType1PC;
            obj.StatisticMat{19,2} =  obj.AreaType2PC;
            obj.StatisticMat{20,2} =  obj.AreaType3PC;
            obj.StatisticMat{21,2} =  obj.AreaType0PC;
            
            obj.StatisticMat{22,2} =  obj.AreaMinMax(1);
            obj.StatisticMat{23,2} =  obj.AreaMinMaxObj(1);
            obj.StatisticMat{24,2} =  obj.AreaMinMax(2);
            obj.StatisticMat{25,2} =  obj.AreaMinMaxObj(2);
            
            obj.StatisticMat{26,2} =  obj.AreaMinMaxT1(1);
            obj.StatisticMat{27,2} =  obj.AreaMinMaxObjT1(1);
            obj.StatisticMat{28,2} =  obj.AreaMinMaxT1(2);
            obj.StatisticMat{29,2} =  obj.AreaMinMaxObjT1(2);
            
            obj.StatisticMat{30,2} =  obj.AreaMinMaxT2(1);
            obj.StatisticMat{31,2} =  obj.AreaMinMaxObjT2(1);
            obj.StatisticMat{32,2} =  obj.AreaMinMaxT2(2);
            obj.StatisticMat{33,2} =  obj.AreaMinMaxObjT2(2);
            
            obj.StatisticMat{34,2} =  obj.AreaMinMaxT3(1);
            obj.StatisticMat{35,2} =  obj.AreaMinMaxObjT3(1);
            obj.StatisticMat{36,2} =  obj.AreaMinMaxT3(2);
            obj.StatisticMat{37,2} =  obj.AreaMinMaxObjT3(2);
            
        end
        
        function saveResults(obj)
            % Prepares all data for saving. Creates cell array depending on
            % the save parameters that will be saved as excel sheet. Save
            % all axes depending on the save parameters.
            %
            %   saveResults(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            
            obj.InfoMessage = ' ';
            obj.InfoMessage = '   - Saving data in the same dir than the RGB image was selected';
            
            %Cell arrays for saving data in excel sheet
            CellStatisticTable = {}; 
            CellFiberTable = {};
            
            %Current date and time
            time = datestr(now,'_yyyy-mm-dd_HHMM');
            
            % Dlete file extension .tif before save
            fileNameRGB = obj.FileNamesRGB;
            LFN = length(obj.FileNamesRGB);
            fileNameRGB(LFN)='';
            fileNameRGB(LFN-1)='';
            fileNameRGB(LFN-2)='';
            fileNameRGB(LFN-3)='';
            
           
            % Save dir is the same as the dir from the selected Pic
            SaveDir = [obj.PathNames obj.FileNamesRGB '_RESULTS']; 
            obj.InfoMessage = ['   -' obj.PathNames obj.FileNamesRGB '_RESULTS']; 
            
            % Check if reslut folder already exist.
            if exist( SaveDir ,'dir') == 7
                % Reslut folder already exist.
                obj.InfoMessage = '      - resluts folder allready excist';
                obj.InfoMessage = '      - add new results files to folder:';
                obj.InfoMessage = ['      - ' SaveDir];
            else
                % create new folder to save results
                mkdir(SaveDir);
                obj.InfoMessage = '      - create resluts folder';
            end
            obj.SavePath = SaveDir;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % save image processed with boudaries
            if obj.SavePicProcessed
                obj.InfoMessage = '      - saving image processed with boundaries';
                
                % save picture as tif file
                f = figure('Units','normalized','Visible','off','ToolBar','none','MenuBar', 'none','Color','w');
                h = copyobj(obj.controllerResultsHandle.viewResultsHandle.hAPProcessed,f);
                SizeFig = size(obj.PicRGB)/max(size(obj.PicRGB));
                set(f,'Position',[0 0 SizeFig(1) SizeFig(2)])
                set(h,'Units','normalized');
                h.Position = [0 0 1 1];
                h.DataAspectRatioMode = 'auto';
                
                frame = getframe(h);
                frame=frame.cdata;
                picName = [fileNameRGB '_image_processed' time '.tif'];
                oldPath = pwd;
                cd(SaveDir)
                imwrite(frame,picName)
                cd(oldPath)
                
                close(f);
                obj.InfoMessage = '         - image has been saved as .tif';
                
                % save picture as vector graphics
                fileName = [fileNameRGB '_image_processed' time '.pdf'];
                fullFileName = fullfile(SaveDir,fileName);
                saveTightFigureOrAxes(obj.controllerResultsHandle.viewResultsHandle.hAPProcessed,fullFileName);
                obj.InfoMessage = '         - image has been saved as .pdf vector grafic'; 
            end
            
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % save color plane image as tif file
            if obj.SavePlanePicture
                obj.InfoMessage = '      - saving color plane image';
                
                fileName = [fileNameRGB '_image_colorPlane' time '.tif'];
                
                oldPath = pwd;
                cd(SaveDir)
                imwrite(obj.PicPRGBPlanes,fileName)
                cd(oldPath)
                
                obj.InfoMessage = '         - image has been saved as .tif';
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % save axes StatisticsTab
            if obj.SavePlots
               obj.InfoMessage = '      - saving axes with statistics plots';

               obj.InfoMessage = '         - saving area plot as .pdf'; 
               fileName = [fileNameRGB '_processed_AreaPlot' time '.pdf'];
               fullFileName = fullfile(SaveDir,fileName);
               saveTightFigureOrAxes(obj.controllerResultsHandle.viewResultsHandle.hAArea,fullFileName);
               
               obj.InfoMessage = '         - saving number of Fiber-Types as .pdf'; 
               fileName = [fileNameRGB '_processed_NumberPlot' time '.pdf'];
               fullFileName = fullfile(SaveDir,fileName);
               saveTightFigureOrAxes(obj.controllerResultsHandle.viewResultsHandle.hACount,fullFileName);
               
               obj.InfoMessage = '         - saving Scatter plot Classification as .pdf'; 
               fileName = [fileNameRGB '_processed_ScatterClassificationPlot' time '.pdf'];
               fullFileName = fullfile(SaveDir,fileName);
               saveTightFigureOrAxes(obj.controllerResultsHandle.viewResultsHandle.hAScatter,fullFileName);
               
               obj.InfoMessage = '         - saving Scatter plot All-Objects as .pdf';
               fileName = [fileNameRGB '_processed_ScatterAllPlot' time '.pdf'];
               fullFileName = fullfile(SaveDir,fileName);
               saveTightFigureOrAxes(obj.controllerResultsHandle.viewResultsHandle.hAScatterAll,fullFileName);
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % create Cell Array with Fiber-Type Table
            if obj.SaveFiberTable
                obj.InfoMessage = '      - creating Fiber-Type struct';
                
                HeaderTable = {'Number' 'Area_(pixel)' 'FCP_x' 'FCP_y' ...
                    'MinorAxis' 'MajorAxis' 'Perimeter_(pixel)'  'Roundness' ...
                    'AspectRatio' 'meanRed' 'meanGreen' 'meanBlue' 'meanFaraRed',...
                    'ColorValue (HSV)' 'colorHue (HSV)' 'RatioBlueRed' 'DistanceBlueRed' 'Type'};
                for i=1:1:length(HeaderTable)
                    newFile{2,i} = HeaderTable{i};
                end
                CellFiberTable = mat2cell(obj.StatsMatData,ones(1,size(obj.StatsMatData,1)),ones(1,size(obj.StatsMatData,2)));
                
                CellFiberTable = cat(1,HeaderTable,CellFiberTable);
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % create Cell Array with Fiber-Statistics Table
            if obj.SaveStatisticTable
                obj.InfoMessage = '      - creating Fiber-Statistic struct';
                
                CellStatisticTable = obj.StatisticMat;  
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % create DataFile for .xlsx from CellArrays
            
            if isempty(CellStatisticTable) && ~isempty(CellFiberTable)
                
                DataFile = CellFiberTable;
                
            elseif isempty(CellFiberTable) && ~isempty(CellStatisticTable)
                
                DataFile = CellStatisticTable;
                
            elseif ~isempty(CellFiberTable) && ~isempty(CellStatisticTable)
                % Both Cells will be combined in one excel sheet
                
                % expand both Cell arrays to the same dim 
                dimStatisticCell = size(CellStatisticTable);
                dimFiberCell = size(CellFiberTable);
                
                if dimFiberCell(1) > dimStatisticCell(1)
                    % CellFiber has bigger length
                    % expand CellStatistic to the smae length as
                    % CallFiber
                CellStatisticTable{dimFiberCell(1),3} = {};
                elseif dimFiberCell(1) < dimStatisticCell(1)
                    % CellFiber has smaller length
                    % expand CellFiber to the smae length as
                    % CellStatistic
                    CellFiberTable{dimStatisticCell(1),dimStatisticCell(2)} = {};
                    obj.InfoMessage = '      - concatenate arrays structs';
                end
                
                DataFile = cat(2,CellStatisticTable,CellFiberTable);
                
            else
                DataFile = {};
            end
                
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Save DataFile as xls file
            if ~isempty(DataFile)
                obj.InfoMessage = '      - start creating .xlsx file';
                
                if ismac
                    % OS is macintosh. xlswrite is not supported. Use
                    % undocumented function from the file exchange Matlab 
                    % Forum for creating .xlsx files on a macintosh OS.
                    
                    obj.InfoMessage = '         - UNIX-Systems (macOS) dont support xlswrite() MatLab function';
                    obj.InfoMessage = '         - trying to create excel sheet with undocumented function...';
                    
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/poi-3.8-20120326.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/poi-ooxml-3.8-20120326.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/poi-ooxml-schemas-3.8-20120326.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/xmlbeans-2.3.0.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/dom4j-1.6.1.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/stax-api-1.0.1.jar'];
                    javaaddpath(path);
                    
                    fileName = [fileNameRGB '_results' time '.xlsx'];
                    sheetName = 'Fiber types';
                    startRange = 'B2';
                    
                    oldPath = pwd;
                    cd(SaveDir)
                    
                    % undocumented function from the file exchange Matlab Forum
                    % for creating .xlsx files on a macintosh OS
                    status = xlwrite(fileName, DataFile, sheetName, startRange);
                    
                    cd(oldPath)
                    
                    if status
                        obj.InfoMessage = '         - .xlxs file has been created';
                    else
                        obj.InfoMessage = '         - .xlxs file could not be created';
                        obj.InfoMessage = '         - creating .txt file instead...';
                        
                        oldPath = pwd;
                        cd(SaveDir)
                        fid=fopen(fileName,'a+');
                        % undocumented function from the file exchange Matlab Forum
                        % for creating .txt files.
                        cell2file(fid,DataFile,'EndOfLine','\r\n');
                        fclose(fid);
                        cd(oldPath)
                        obj.InfoMessage = '         - .txt file has been created';
                    end
                    
                elseif ispc
                end
                
                
            end
            
            obj.InfoMessage = '   - Saving data complete';
        end
        
        function showPicProcessedGUI(obj,axesPicAnalyze,axesResults)
            % Copys the boundarie objects from the axes in
            % the analyze GUI and paste them into the results GUI.
            %
            %   showPicProcessedGUI(obj,axesPicAnalyze,axesResults);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:            Handle to modelResults object.
            %           axesPicAnalyze: Handle to axes with image in
            %               analyze GUI.
            %           axesResults:    Handle to axes in result GUI.
            %
            
            %make axes results the current axes
            axes(axesResults);
            
            %sjow RGB image in GUI
            imshow(ones(size(obj.PicRGB)));
            obj.InfoMessage = '      - load image processed into GUI...';
            
            %copy boundaries from analyze to result GUI.
            copyobj(axesPicAnalyze.Children ,axesResults);
            axes(axesResults);
            hold on
            obj.InfoMessage = '         - show labels...';
            
            %plot labels in the image
            for k = 1:size(obj.Stats,1)
                hold on
                c = obj.Stats(k).Centroid;
                text(c(1), c(2), sprintf('%d', k),'Color','y', ...
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment', 'middle');
            end
            hold off
            
            
        end
        
        function delete(obj)
            %deconstructor
        end
        
    end
    
end

