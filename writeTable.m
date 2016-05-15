function writeTable(fid, inputs, prec)
[numRows, numCols] = size(inputs);

% set format
dataFormat = ['%0.' num2str(prec) 'f'];
rowFormat = [repmat('%s\t& ', [1, numCols-1]), '%s \\\\ \n'];

% write header
writeHeader(fid, numCols);

% write body
for r = 1: numRows
    colBuffer = {};
    allStr = true;
    for c = 1: numCols
        elem = inputs{r, c};
        if isnan(elem)
            str = ' ';
            allStr = allStr & true;
        elseif ischar(elem)
            str = elem;
            % check underline
            if ~isempty(strfind(str, '_'))
                str = strrep(str, '_', '\_');
            end
            allStr = allStr & true;
        elseif isnumeric(elem)
            str = sprintf(dataFormat, elem);
            allStr = false;
        else
            error('unknown data type');
        end
        colBuffer{c} = str;        
    end
    % print this line
    fprintf(fid, rowFormat, colBuffer{:});
    % apply middle rule if needed
    if allStr && r == 1
        fprintf(fid, '\\midrule \n');
    end
end

% write tail
writeTail(fid);


function writeHeader(fid, numCols)
fprintf(fid, ['%% Requires the booktabs package, cut the following ',...
    'line to the beginning of your tex file, and uncomment\n']);
fprintf(fid, '%%\\usepackage{booktabs}\n');
fprintf(fid, '\\begin{table}[htbp]\n');
fprintf(fid, '\\centering\n');
tabFormat = ['l', repmat('c', [1, numCols-1])];
fprintf(fid, '\\begin{tabular}{@{} %s @{}}\n', tabFormat);
fprintf(fid, '\\toprule\n');


function writeTail(fid)
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}\n');
fprintf(fid, '\\caption{CHANGE TO YOUR OWN CAPTION.}\n');
fprintf(fid, '\\label{tab:config}\n');
fprintf(fid, '\\end{table}\n');