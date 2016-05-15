function xlsxToLatex(xlsxPath, texPath, prec)
% convert excel to latex format
% input:
%     xlsxPath: path of the xlsx file
%     texPath: path of the generated tex file, if not specified, print it
%              to screen
%     prec: precsion of the digits

fid = 1;
if nargin >= 2 && ~isempty(texPath)
    fid = fopen(texPath, 'w');
else
    clc;
end

if nargin < 3
    prec = 2;
end

% read xlsx 
[~, ~, raw] = xlsread(xlsxPath);

% process raw to find each individual table
nanMap = cellfun(@(x) all(isnan(x)), raw);
try
    stats = regionprops(~nanMap, 'PixelList');
    for i = 1: length(stats)
        tab = pixelListToTable(stats(i).PixelList, raw);
        % write to tex
        writeTable(fid, tab, prec);
        fprintf(fid, '\n');
    end
catch
    warning('image processing toolbox not installed, only support single table');
    % write to tex
    writeTable(fid, raw, prec);
end

if fid ~= 1
    fclose(fid);
end

function tab = pixelListToTable(pixelList, raw)
cols = pixelList(:, 1);
rows = pixelList(:, 2);
minCol = min(cols); maxCol = max(cols);
minRow = min(rows); maxRow = max(rows);
numCols = maxCol - minCol + 1;
numRows = maxRow - minRow + 1;
tab = num2cell(nan(numRows, numCols));
for i = 1: length(rows)
    r = rows(i); c = cols(i);
    newR = r - minRow + 1;        
    newC = c - minCol + 1;
    tab(newR, newC) = raw(r, c);
%     fprintf('%d, %d\n', r, c);
end