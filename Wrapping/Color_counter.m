%% Pixel counter

fds = fileDatastore('*.tif', 'ReadFcn', @importdata);

fullFileNames = fds.Files;

numFiles = length(fullFileNames);

for k = 1
    [filepath,name,ext] = fileparts(fullFileNames{k});
    image = imread(fullFileNames{k});
    %grey = uint82gray(image);
    %grey = image(:,:,1)+image(:,:,2)+image(:,:,3);
    bimage = imbinarize(1-imbinarize(grey));
    pixels = sum(sum(bimage));
    total = size(bimage);
    %filnum = split(name,"F");
    %filnum = split(filnum{2},".");
    %filenum = str2double(filnum{1});
    s(k).pixels = pixels;
    s(k).size = total;
    s(k).name = name;
    %s(k).filecount = filenum;
    
end

%%

index=1;
k=1;
pixeltotal = s(1).pixels;
count = 1;
total = s(1).size;
total = total(1)*total(2);

for n = 2:numFiles
    tf = strcmp(s(n).name(1:11), s(n-1).name(1:11));
    if tf==1
        pixeltotal = pixeltotal+s(n).pixels;
        count = count+1;
    else
        pixeltotal = s(n).pixels;
        count =1;
        index = index+1;
    end
    pixelcount(index).pixels = pixeltotal;
    pixelcount(index).count = count;
    pixelcount(index).name = s(n).name(1:11);
    pixelcount(index).avg = pixeltotal/count;
    pixelcount(index).per = pixelcount(index).avg/total;
    pixelcount(index).time = str2double(s(n).name(1));

end

%%

percents = [pixelcount.per];
time = [pixelcount.time];

plot(time,percents,'o')


%%
time = [0,2,4,5,6];
avgper = [0.1622386, 0.2141086, 0.2950182, 0.2714114, 0.250353];
sd = [0.045128, 0.05718, 0.037864, 0.023954, 0.044089];

errorbar(time, avgper, sd, 'o');