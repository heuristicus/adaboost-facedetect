%% prepare the directories which we will use for training data and test data
% by selecting some proportion of images to use for the test data and
% separating them.

indirs = {'data/TrainingImages/FACES', 'data/TrainingImages/NFACES'};
outdirs = {'data/ExtraData/Test/FACES', 'data/ExtraData/Test/NFACES'};
outfiles = {'data/ExtraData/testfacenums.mat', 'data/ExtraData/testnonfnums.mat'}
testprop = 0.2; % the proportion of the images in each directory to use for testing

for i = 1:size(indirs,2)
    indir = indirs{i};
    outdir = outdirs{i};
    
    face_fnames = dir(indir);
    nlist = 3:length(face_fnames); % numbers from 3 to the length of the directory
    randlist = randperm(length(nlist)); % permute so we can get random images from the top of the list
    nims = testprop * length(nlist); % the number of images we want to put in the test set
    fnums = nlist(randlist(1:nims)); % extract the first n random values
    
    save(outfiles{i}, 'fnums');
    
    for f=1:length(fnums)
        movefile(strcat(indir, '/', face_fnames(fnums(f)).name), strcat(outdir, '/', face_fnames(fnums(f)).name));
    end
end

%% randomise the file list for the training images that we are going to use

dirname = 'data/ExtraData/Training/FACES';
face_fnames = dir(dirname);
nlist = 3:length(face_fnames); % numbers from 3 to the length of the directory
fnums = randperm(length(nlist)); % permute so we can get random images from the top of the list
ii_ims = LoadImages(dirname, length(fnums),1);

save('data/ExtraData/Fdata.mat', 'dirname', 'fnums', 'ii_ims')

dirname = 'data/ExtraData/Training/NFACES';
face_fnames = dir(dirname);
nlist = 3:length(face_fnames); % numbers from 3 to the length of the directory
fnums = randperm(length(nlist)); % permute so we can get random images from the top of the list
ii_ims = LoadImages(dirname, length(fnums),1);

save('data/ExtraData/NFdata.mat', 'dirname', 'fnums', 'ii_ims')

%% train the strong classifier on some proportion of the test data and save
% the results

Fdata = load('data/ExtraData/Fdata.mat');
NFdata = load('data/ExtraData/NFdata.mat');
FTdata = load('data/FeaturesToUse.mat'); % same features as before

FTdata.fmat = sparse(FTdata.fmat);

props = [.1 .2 .3 .4 .5 .6 .7 .8 .9 1];
nweakclassifiers = 10;
params = cell(1,length(props));

for i=1:length(props)
    fprintf('Training strong classifier on %d percent of the training data.\n', props(i)*100);
    % modify the internal contents of fdata to match the current proportion
    ntrainimsface = floor(props(i)*length(Fdata.fnums));
    fnums = Fdata.fnums(1:ntrainimsface);
    ii_ims = Fdata.ii_ims(1:ntrainimsface, :);
    modFdata.fnums = fnums;
    modFdata.ii_ims = ii_ims;
    
    % modify nfdata
    ntrainimsnonface = floor(props(i)*length(NFdata.fnums));
    fnums = NFdata.fnums(1:ntrainimsnonface);
    ii_ims = NFdata.ii_ims(1:ntrainimsnonface,:);
    modNFdata.fnums = fnums;
    modNFdata.ii_ims = ii_ims;

    params{i} = BoostingAlg(modFdata, modNFdata, FTdata, nweakclassifiers);
end

save('data/ExtraData/paramsorig.mat', 'cparams', 'props');

%% find the thresholds for each of the trained strong classifiers

params = load('data/ExtraData/paramsorig.mat');
Fdata = load('data/ExtraData/Fdata.mat');
NFdata = load('data/ExtraData/NFdata.mat');

colours = hsv(length(params.params));
names = cell(1,length(params.params));
figure
hold on
for i=1:length(params.params)
%     strcat('data/ExtraData/testdata', num2str(params.props(i)))
    [thresh, tpr, fpr, acc, thresholds] = ComputeROC(params.params{i}, Fdata, NFdata, 0.7, ...
                                    0.01, strcat('data/ExtraData/testdata', ...
                                    num2str(params.props(i)), '.mat'), ...
                                    'data/ExtraData/Test');
    params.params{i}.thresh = thresh;
    names{i} = num2str(params.props(i));
    plot(fpr, tpr, 'color', colours(i,:));
%     plot(thresholds, acc, 'color', colours(i,:));
end
legend(names)
xlabel('fpr')
ylabel('tpr')


save('data/ExtraData/paramsthresh.mat', 'params');