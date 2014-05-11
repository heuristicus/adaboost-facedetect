function dets = ScanImageFixedSize(Cparams, im, W, H)
if size(im,3)==3
    im = rgb2gray(im);
end
im=double(im);

scores=zeros(size(im,1)+1-H,(size(im,2)+1-W));

for y=1:size(im,1)+1-H
    for x=1:(size(im,2)+1-W)
        subWindow=im(y:y+H-1,x:x+W-1);
        muSW=mean(subWindow(:));
        stdSW=std(subWindow(:));
        nSubW=(subWindow-muSW)/stdSW;
        ii_imNSW=cumsum(cumsum(nSubW,1),2);
        scores(y,x) = ApplyDetectorSubwindow( Cparams, ii_imNSW, stdSW, muSW );
%         subWindowIm=ii_im(y:y+H-1,x:x+W-1);
%         sumSW=ComputeBoxSum(ii_im,x,y,W,H);
%         muSW=sumSW/(W*H);
%         sumSqSW=ComputeBoxSum(ii_squareIm,x,y,W,H);
%         varSW=(1/((W*H)-1))*(sumSqSW-((W*H)*muSW^2));
%         stdSW=sqrt(varSW);
%         scores(y,x) = ApplyDetectorSubwindow( Cparams, subWindowIm, stdSW, muSW );
%         subWindow=im(y:y+H-1,x:x+W-1);
%         ii_imSW=cumsum(cumsum(subWindow,1),2);
%         sumSW=ComputeBoxSum(ii_imSW,1,1,W,H);
%         muSW=sumSW/(W*H);
%         squareSW=subWindow.*subWindow;
%         ii_imSqSw=cumsum(cumsum(squareSW,1),2);
%         sumSqSW=ComputeBoxSum(ii_imSqSw,1,1,W,H);
%         
%         varSW=(1/((W*H)-1))*(sumSqSW-((W*H)*muSW^2));
%         stdSW=sqrt(varSW);
%         manStdSW=std(subWindow(:));
%         scores(y,x) = ApplyDetectorSubwindow( Cparams, ii_imSW, stdSW,muSW );
    end
end
thresh=Cparams.thresh;


classification = scores > thresh;
[Yind Xind]= find(classification);
dets=[Xind Yind ones(size(Xind,1),1)*W ones(size(Xind,1),1)*H];

end