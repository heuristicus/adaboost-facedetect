function A = ComputeBoxSum(ii_im, x, y, w, h)
A = ii_im(y+h-1,x+w-1)-ii_im(y+h-1,x)-ii_im(y,x+w-1)+ii_im(y,x);
% A = ii_im(y+h,x+w)-ii_im(y+h,x)-ii_im(y,x+w)+ii_im(y,x);
if x == 1 && y == 1
    A = ii_im(1,1);
elseif x == 1
    A = ii_im(y+h-1,x+w-1) - ii_im(y-1,x+w-1);
elseif y == 1
    A = ii_im(y+h-1,x+w-1) - ii_im(y+h-1,x-1);
else
    A = ii_im(y+h-1,x+w-1)-ii_im(y+h-1,x-1)-ii_im(y-1,x+w-1)+ii_im(y-1,x-1);
end
end