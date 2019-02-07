% this function allows to align all sequences with the same name that are
% into the main folder from the sequence 'ref'

function createstack(topLevelFolder,channels)

% Start with a folder and get a list of all subfolders.
% Finds and prints names of all PNG, JPG, and TIF images in 
% that folder and all of its subfolders.
clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
warning('off','all')

if topLevelFolder == 0
    message = sprintf('Sorry, but you have to choice a directory... Lets try again! :)');
    uiwait(warndlg(message));
	return;
end


% Get list of all subfolders.
allSubFolders = genpath(topLevelFolder);
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};

while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames);

% Process all image files in those folders.
% h=waitbar(0,'Processing images...');

for k = 1 : numberOfFolders
    
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
    
    parts = strsplit(thisFolder, '\');
    ROI = parts{end};
    
	% Add on TIF files.
	filePattern = sprintf('%s/*.tif', thisFolder);
	baseFileNames = dir(filePattern);
    numberOfImageFiles = length(baseFileNames);

	% Now we have a list of all files in this folder.   
%     waitbar(k/numberOfFolders,h,sprintf('Aligning images of %s ROI...',ROI))
	if (numberOfImageFiles >= 1)
        fprintf('\n     Stacking images in folder %s\n', thisFolder);
        mkdir(thisFolder,'\stack\');
        
		% Go through all those image files.
        for f = 1 : numberOfImageFiles
   			fullFileName = fullfile(thisFolder, baseFileNames(f).name);
                       
            image = read_stackTiff(fullFileName);
            [x,y,z]=size(image);
            
            for ii = 1:length(channels)
                chan(ii).name = channels{ii};
                chan(ii).im(:,:,f) = image(:,:,ii);    
            end
        end
        for ii=1:length(channels)
            for i=1:numberOfImageFiles
                imwrite(chan(ii).im(:,:,i),strcat(thisFolder,'\stack\',ROI,'_',chan(ii).name,'.tif'),'WriteMode', 'append',  'Compression','none');    
            end  
        end
	else
		fprintf('     Folder %s has no image files in it.\n', thisFolder);
    end
    fprintf('\n     Folder %s doner!\n', thisFolder);
end
    
