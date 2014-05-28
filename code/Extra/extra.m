%% prepare the directories which we will use for training data and test data
% by selecting some proportion of images to use for the test data and
% separating them.

indirs = {'data/TrainingImages/FACES', 'data/TrainingImages/NFACES'};
outdirs = {'data/ExtraData/Test/FACES', 'data/ExtraData/Test/NFACES'};
testprop = 0.2; % the proportion of the images in each directory to use for testing

for i = 1:size(indirs,2)
    indir = indirs{i};
    outdir = outdirs{i};
    
    face_fnames = dir(indir);
    nlist = 3:length(face_fnames); % numbers from 3 to the length of the directory
    randlist = randperm(length(nlist)); % permute so we can get random images from the top of the list
    nims = testprop * length(nlist); % the number of images we want to put in the test set
    fnums = nlist(randlist(1:nims)); % extract the first n random values
    
    for f=1:length(fnums)
        movefile(strcat(indir, '/', face_fnames(fnums(f)).name), strcat(outdir, '/', face_fnames(fnums(f)).name));
    end
end

%% randomise the file list for the training images that we are going to use

indirs = {'data/ExtraData/Training/FACES', 'data/ExtraData/Training/NFACES'};

face_fnames = dir(indirs{1});
nlist = 3:length(face_fnames); % numbers from 3 to the length of the directory
facelist = randperm(length(nlist)); % permute so we can get random images from the top of the list

face_fnames = dir(indirs{2});
nlist = 3:length(face_fnames); % numbers from 3 to the length of the directory
nonfacelist = randperm(length(nlist)); % permute so we can get random images from the top of the list

save('data/ExtraData/randfilelist.mat', 'facelist', 'nonfacelist');