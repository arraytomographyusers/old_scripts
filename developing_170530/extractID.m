function id = extractID(name,channels)

id = [];
for i=1:length(channels)
    position = strfind(name, strcat('_',channels{i}));
    if not(isempty( position))
        id = name(1:position);  
    end
end