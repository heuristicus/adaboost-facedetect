function [theta, p, err] = LearnWeakClassifier(ws, fs, ys)

ONES=ones(size(ys));
muFace=((ws.*fs)'*ys)/(ws'*ys);
muNonFace=((ws.*fs)'*(ONES-ys))/(ws'*(ONES-ys));
theta=0.5*(muFace+muNonFace);

gPos=fs<theta;
gNeg=-fs<-theta;

errorPos=ws'*abs(ys-gPos);
errorNeg=ws'*abs(ys-gNeg);

if errorPos<errorNeg
    err=errorPos;
    p=1;
else
    err=errorNeg;
    p=-1;
end

end

