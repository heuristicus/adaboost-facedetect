function thresh = ComputeROC(Cparams, Fdata, NFdata, tpr_req, thresh_step, testscores)
%COMPUTEROC Computes the ROC curves and the threshold required to get the
%requested rate of true positives. The testscores string defines where to
%find the scores on the remainder of the training images. If this does not
%exist, then it will be created.

if (~exist(testscores, 'file'))
    facelist = dir(Fdata.dirname);
    nonfacelist = dir(NFdata.dirname);
    
    facetraining = Fdata.fnums;
    nftraining = NFdata.fnums;
    
    facetest = setdiff(3:numel(facelist), facetraining);
    nftest = setdiff(3:numel(nonfacelist), nftraining);
    
%     facetest = setdiff(1:numel(facelist), facetraining);
%     nftest = setdiff(1:numel(nonfacelist), nftraining);
    
    ftestnames = facelist(facetest);
    nftestnames = nonfacelist(nftest);
    
    score = zeros(numel(nftestnames) + numel(ftestnames), 1);
    labels = [ones(numel(ftestnames), 1); zeros(numel(nftestnames), 1)];
    
    lastind = 0;
    for i=1:numel(ftestnames)
        [~, ii_im] = LoadIm(ftestnames(i).name);
        score(i) = ApplyDetector(Cparams, ii_im);
        lastind = i;
    end
    
    for i=1:numel(nftestnames);
        [~, ii_im] = LoadIm(nftestnames(i).name);
        score(lastind + i) = ApplyDetector(Cparams, ii_im);
    end
    
    save(testscores, 'score', 'labels')
end

threshold = 0;
thresholds = [];
tpr = [];
fpr = [];
lasttpr = 1;
while lasttpr > 0
    load(testscores)
    classification = score > threshold;
    truepos = sum((classification == 1) & (labels == 1));
    trueneg = sum((classification == 0) & (labels == 0));
    falsepos = sum((classification == 1) & (labels == 0));
    falseneg = sum((classification == 0) & (labels == 1));

    threshold = threshold + thresh_step;
    thresholds = [thresholds threshold];
    tpr = [tpr truepos/(truepos + falseneg)];
    fpr = [fpr falsepos/(trueneg + falsepos)];
    lasttpr = tpr(end);
end

ind = find(tpr>tpr_req,1,'last');
thresh = thresholds(ind);

figure
plot(fpr, tpr)
xlabel('fpr')
ylabel('tpr')
figure
plot(thresholds,tpr)
xlabel('thresholds')
ylabel('tpr')
figure
plot(thresholds,fpr)
xlabel('thresholds')
ylabel('fpr')
end