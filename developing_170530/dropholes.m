% this function allows to align all sequences with the same name that are
% into the main folder from the sequence 'ref'

function dropholes(topLevelFolder,channel)

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
    
	% Add on TIF files.
	filePattern = sprintf('%s/*.tif', thisFolder);
	baseFileNames = dir(filePattern);
    numberOfImageFiles = length(baseFileNames);
    mkdir(topLevelFolder,'masks');
	% Now we have a list of all files in this folder.   
%     waitbar(k/numberOfFolders,h,sprintf('Aligning images of %s ROI...',ROI))
	if (numberOfImageFiles >= 1)
%         fprintf('\n     Segmenting images in folder %s\n', thisFolder);
        
		% Go through selected image files
        for f = 1 : numberOfImageFiles
            if (strfind(baseFileNames(f).name,channel)>0)
                fullFileName = fullfile(thisFolder, baseFileNames(f).name);
                split = strsplit(baseFileNames(f).name,channel);
                id = split{1};
                
                fprintf('%s\n', baseFileNames(f).name)
                I = read_stackTiff(fullFileName);
                
                mask=segment_epi(I);
                [f,c,p]=size(I);
                
                outputFileName = strcat(topLevelFolder,'\masks\',id,'mask.tif');
                for i=1:p
                       imwrite(logical(mask(:,:,i)),outputFileName, 'WriteMode', 'append',  'Compression','none');
                end
            end
        end
        
	else
% 		fprintf('     Folder %s has no image files in it.\n', thisFolder);
    end
%     fprintf('\n     Folder %s doner!\n', thisFolder);
end
    
