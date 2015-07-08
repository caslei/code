% tags_to_list: transforms tags struct from dmread.m function to a list of
% tag_names and tag_values. The output may be written to a separate file
% using the metadata_file_path parameter or to the console using the print
% parameter. 
% Author: Joris Roels

function [tag_names, tag_values] = tags_to_list(tags, metadata_file_path, print)

if nargin < 1
    error('At least one tags struct input required!');
end
if nargin < 2
    write = 0;
    print = 0;
else
    write = 1;
    if nargin < 3
        print = 0;
    end
end


tag_fields = fieldnames(tags);
index = 1;
tag_names = cell(1);
tag_values = cell(1);

for i=1:numel(tag_fields)
    tag_field = char(tag_fields(i));
    % disp(tag_field);
    sub_tags = getfield(tags, tag_field);
    sub_tag_fields = fieldnames(sub_tags);
    for j=1:numel(sub_tag_fields)
        sub_tag_field = char(sub_tag_fields(j));
        % disp(['    ' sub_tag_field]);
        if ~strcmp(sub_tag_field, 'Value')
            sub_sub_tags = getfield(sub_tags, sub_tag_field);
            sub_sub_tag_fields = fieldnames(sub_sub_tags);
            for k=1:numel(sub_sub_tag_fields)
                sub_sub_tag_field = char(sub_sub_tag_fields(k));
                % disp(['        ' sub_sub_tag_field]);
                if ~strcmp(sub_sub_tag_field, 'Value')
                    sub_sub_sub_tags = getfield(sub_sub_tags, sub_sub_tag_field);
                    sub_sub_sub_tag_fields = fieldnames(sub_sub_sub_tags);
                    for l=1:numel(sub_sub_sub_tag_fields)
                        sub_sub_sub_tag_field = char(sub_sub_sub_tag_fields(l));
                        % disp(['            ' sub_sub_sub_tag_field]);
                        if ~strcmp(sub_sub_sub_tag_field, 'Value')
                            sub_sub_sub_sub_tags = getfield(sub_sub_sub_tags, sub_sub_sub_tag_field);
                            sub_sub_sub_sub_tag_fields = fieldnames(sub_sub_sub_sub_tags);
                            for m=1:numel(sub_sub_sub_sub_tag_fields)
                                sub_sub_sub_sub_tag_field = char(sub_sub_sub_sub_tag_fields(m));
                                % disp(['                ' sub_sub_sub_sub_tag_field]);
                                if ~strcmp(sub_sub_sub_sub_tag_field, 'Value')
                                    sub_sub_sub_sub_sub_tags = getfield(sub_sub_sub_sub_tags, sub_sub_sub_sub_tag_field);
                                    sub_sub_sub_sub_sub_tag_fields = fieldnames(sub_sub_sub_sub_sub_tags);
                                    for n=1:numel(sub_sub_sub_sub_sub_tag_fields)
                                        sub_sub_sub_sub_sub_tag_field = char(sub_sub_sub_sub_sub_tag_fields(n));
                                        % disp(['                    ' sub_sub_sub_sub_sub_tag_field]);
                                        if ~strcmp(sub_sub_sub_sub_sub_tag_field, 'Value')
                                            sub_sub_sub_sub_sub_sub_tags = getfield(sub_sub_sub_sub_sub_tags, sub_sub_sub_sub_sub_tag_field);
                                            sub_sub_sub_sub_sub_sub_tag_fields = fieldnames(sub_sub_sub_sub_sub_sub_tags);
                                            for o=1:numel(sub_sub_sub_sub_sub_sub_tag_fields)
                                                sub_sub_sub_sub_sub_sub_tag_field = char(sub_sub_sub_sub_sub_sub_tag_fields(o));
                                                % disp(['                        ' sub_sub_sub_sub_sub_sub_tag_field]);
                                                if ~strcmp(sub_sub_sub_sub_sub_sub_tag_field, 'Value')
                                                    sub_sub_sub_sub_sub_sub_sub_tags = getfield(sub_sub_sub_sub_sub_sub_tags, sub_sub_sub_sub_sub_sub_tag_field);
                                                    sub_sub_sub_sub_sub_sub_sub_tag_fields = fieldnames(sub_sub_sub_sub_sub_sub_sub_tags);
                                                    for p=1:numel(sub_sub_sub_sub_sub_sub_sub_tag_fields)
                                                        sub_sub_sub_sub_sub_sub_sub_tag_field = char(sub_sub_sub_sub_sub_sub_sub_tag_fields(p));
                                                        tag_names{index} = strcat(tag_field, '.', sub_tag_field, '.', sub_sub_tag_field, '.', sub_sub_sub_tag_field, '.', sub_sub_sub_sub_tag_field, '.', sub_sub_sub_sub_sub_tag_field, '.', sub_sub_sub_sub_sub_sub_tag_field);
                                                        tag_values{index} = getfield(sub_sub_sub_sub_sub_sub_sub_tags,'Value');
                                                        index = index+1;
                                                        % disp(['                            ' sub_sub_sub_sub_sub_sub_sub_tag_field]);
                                                        % disp(tag_names{index-1});
                                                    end
                                                else
                                                    if numel(sub_sub_sub_sub_sub_tag_field)<7 || ~(strcmp(sub_sub_sub_sub_sub_tag_field(1:7),'Unnamed'))
                                                        tag_names{index} = strcat(tag_field, '.', sub_tag_field, '.', sub_sub_tag_field, '.', sub_sub_sub_tag_field, '.', sub_sub_sub_sub_tag_field, '.', sub_sub_sub_sub_sub_tag_field);
                                                        tag_values{index} = getfield(sub_sub_sub_sub_sub_sub_tags,'Value');
                                                        index = index+1;
                                                        % disp(tag_names{index-1});
                                                    end
                                                end
                                            end
                                        else
                                            tag_names{index} = strcat(tag_field, '.', sub_tag_field, '.', sub_sub_tag_field, '.', sub_sub_sub_tag_field, '.', sub_sub_sub_sub_tag_field);
                                            tag_values{index} = getfield(sub_sub_sub_sub_sub_tags,'Value');
                                            index = index+1;
                                        end
                                    end
                                else
                                    tag_names{index} = strcat(tag_field, '.', sub_tag_field, '.', sub_sub_tag_field, '.', sub_sub_sub_tag_field);
                                    tag_values{index} = getfield(sub_sub_sub_sub_tags,'Value');
                                    index = index+1;
                                end
                            end
                        else
                            tag_names{index} = strcat(tag_field, '.', sub_tag_field, '.', sub_sub_tag_field);
                            tag_values{index} = getfield(sub_sub_sub_tags,'Value');
                            index = index+1;
                        end
                    end
                else
                    tag_names{index} = strcat(tag_field, '.', sub_tag_field);
                    tag_values{index} = getfield(sub_sub_tags,'Value');
                    index = index+1;
                end
            end
        else 
            tag_names{index} = strcat(tag_field);
            tag_values{index} = getfield(sub_tags,'Value');
            index = index+1;
        end
    end
end

if write
    fileID = fopen(metadata_file_path,'w');
end
for i=1:numel(tag_names)
    if ~strcmp(tag_names{i}(max(end-13,1):end),'ImageData.Data')
        if (numel(tag_values{i})>1) && iscell(tag_values{i})
            % disp('CASE 1');
            tag_value = '';
            for j=1:numel(tag_values{i})
                value = tag_values{i}{j};
                if numel(value)>1 && ~ischar(value)
                    temp_value='[';
                    for k=1:numel(value)
                        temp_value = strcat(temp_value,num2str(value(k)),',');
                    end
                    tag_value = strcat(tag_value,temp_value(1:end-1),'],');
                else
                    tag_value = strcat(tag_value,num2str(value),',');
                end
            end
            tag_value = tag_value(1:end-1);
        else if numel(tag_values{i})>1
                % disp('CASE 2');
                for j=1:numel(tag_values{i})
                    value = tag_values{i}(j);
                    if value==0
                        value = '0';
                    end
                    tag_value = strcat(tag_value,num2str(value),',');
                end
                tag_value = tag_value(1:end-1);
            else
                % disp('CASE 3');
                tag_value = num2str(tag_values{i});
            end
        end
        if print
            disp(['Printing ... ' strcat(tag_names{i},'=',tag_value,'\n')]);
        end
        if write
            fprintf(fileID, strcat(tag_names{i},'=',tag_value,'\n'));
        end
    end
end
if write
    fclose(fileID);
end

end

