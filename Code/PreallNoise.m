datafile='PreallocateNoise';
datafile_full=sprintf('%s_full',datafile);

height = 768;
width = 1024;

rect=[0 0 width height];     % test comps

% Preallocating the noise filter for each trial
noiseMatrix=[];
for i=1:height
    for j=1:width
        n=randi(2);
        if n==1
            noiseMatrix(i,j)=255;
        else
            noiseMatrix(i,j)=0;
        end
    end
end
destRectNoise = [0,0,rect(3),rect(4)];

save(datafile,'noiseMatrix','destRectNoise');

save(datafile_full);