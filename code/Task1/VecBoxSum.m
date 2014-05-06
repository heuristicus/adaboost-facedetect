function [b_vec] = VecBoxSum(x, y, w, h, W, H)
%VECBOXSUM Returns a vector of length W*H which contains elements such that
%when multiplied by the integral image converted into a vector, the result
%is the sum of the box defined by x y w h. Matrices are converted to
%vectors in column-major order.

b_vec = zeros(W*H,1);

if x == 1 && y == 1
    % if starting at the origin, only need to use a single value, at the
    % point (y+h,x+w) on the image, and thus can be converted into a vector
    % index by multiplying the width and height since the 
    b_vec(w*h + 2) = 1;
elseif x == 1
    colInd = w*H; % index of the last element in the column of interest
    % get the required indices by subtracting from the colInd.
    b_vec(colInd - (H - (y - 1 + h))) = 1;
    b_vec(colInd - (H - (y - 1))) = -1;
elseif y == 1
    % first, find the last index of the column prior to the one that the
    % index of interest is in, and then add the height to get it.
    b_vec((x + w - 2) * H + h) = 1;
    b_vec((x - 2)* H + h) = -1;
else
    % same idea as for when x=1, but take into account the x as well. Use
    % column computations to find the desired indices
    rcolInd = ((x+w-1)*H);
    b_vec(rcolInd - (H - (y - 1 + h))) = 1;
    b_vec(rcolInd - (H - (y - 1))) = -1;
    lcolInd = ((x-1)*H);
    b_vec(lcolInd - (H - (y - 1 + h))) = -1;
    b_vec(lcolInd - (H - (y - 1))) = 1;
end


% alternative computation method - do things on a matrix and then convert
% it to a vector
% bmat = zeros(H,W);
% if x == 1 && y == 1
%     bmat(y+h-1,x+w-1) = 1;
% elseif x == 1
%     bmat(y+h-1,x+w-1) = 1;
%     bmat(y-1,x+w-1) = -1;
% elseif y == 1
%     bmat(y+h-1,x+w-1) = 1;
%     bmat(y+h-1,x-1) = -1;
% else
%     bmat(y+h-1,x+w-1) = 1;
%     bmat(y-1,x-1)  = 1;
%     bmat(y+h-1,x-1) = -1;
%     bmat(y-1,x+w-1) = -1;
% end
% 
% b_vec = bmat(:);

end

