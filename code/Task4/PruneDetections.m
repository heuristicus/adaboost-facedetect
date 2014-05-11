function pdets = PruneDetections(dets, ol_thresh)
%PRUNEDETECTIONS Given a set of rectangles defining the bounding boxes of
%faces, prunes out those boxes which overlap each other by more than
%ol_thresh. Significantly overlapping boxes are combined such that they are
%the end result is the average of the overlapping boxes.

% create a matrix of the areas such that the columns are repeated
areas = dets(:,3) .* dets(:,4);
arearep = repmat(areas, 1, size(dets,1));
% get the sum of each rectangle area with each other one
areasum = arearep' + arearep;
% get the overlap of the rectangles with themselves
orarea = rectint(dets,dets);
% The total area of two rectangles combined into a single shape is the sum
% of their areas minus the overlapping area
unionarea = areasum - orarea;
% the proportion of the total area which is overlap
areaprop = orarea ./ unionarea;

% Get the connected components. These are those sets of rectangles which
% have mutual overlap of more than the given threshold.
[ncomps, comps] = graphconncomp(sparse(areaprop>ol_thresh));

% pruned rectangles
pdets = zeros(ncomps, 4);

for i=1:ncomps
    % cvec contains ones for each rectangle in the given connected
    % component
    cvec = comps == i;
    % Each of the resulting rectangles is the average of the rectangles in
    % the connected component.
    pdets(i,:) = sum(dets(cvec, :), 1)/sum(cvec);
end


% well, that's rather annoying. Perhaps one should read the instructions
% first
% % we will store the percentage overlap between detections in a matrix. It
% % will be upper triangular
% overlap = zeros(size(dets), 1);
% % compare each detection against all others. The outer loop examines all
% % detections apart from the last, while the inner one goes from the current
% % detection index right to the end. This means that we do not compare
% % things more than necessary. That is, if we have already checked i,j then
% % there is no point in checking j,i.
% for i=1:size(dets,1)-1
%     fprintf('---------------------------------------------\n')
%     fprintf('box1 is %d\n', i)
%     % define the four corners of the square that encompasses the face which
%     % has been detected. 
%     x1 = dets(i,1);
%     y1 = dets(i,2);
%     w1 = dets(i,3);
%     h1 = dets(i,4);
%     for j=i+1:size(dets,1)
%         fprintf('box2 is %d\n', j)
%         % define the four corners of one of the other detected faces
%         x2 = dets(j,1);
%         y2 = dets(j,2);
%         w2 = dets(j,3);
%         h2 = dets(j,4);
%         % compare the positions of the corners in order to see whether an
%         % overlap occurs. tl = top left, tr = top right, bl = bottom left,
%         % br = bottom right
%         % bottom right of box 1 overlaps with top left of box 2
%         % tl2 below right of tl1, and tl2 above left of br1
%         if (((x2 >= x1) && (y2 >= y1)) && ((x2 < x1 + w1) && (y2 < y1 + h1)))
%             fprintf('1: br1 overlaps tl2\n')
%             olw = x1 + w1 - x2;
%             olh = y1 + h1 - y2;
%             overlapping = 1;
%         % top right of box 1 overlaps with bottom left of box 2
%         % tl2 above right of tl1, and bl2 below left of tr1
%         elseif (((x2 >= x1) && (y2 <= y1)) && ((x2 < x1 + w1) && (y2 + h2 > y1)))
%             fprintf('2: tr1 overlaps bl2\n')
%             olw = x1 + w1 - x2;
%             olh = y2 + h2 - y1;
%             overlapping = 1;
%         % bottom left of box 1 overlaps with top right of box 2
%         % tl2 below left of tl1, and tr2 above right of bl1
%         elseif (((x2 <= x1) && (y2 >= y1)) && ((x2 + w2 > x1) && (y2 < y1 + h1)))
%             fprintf('3: bl1 overlaps tr2\n')
%             olw = x2 + w2 - x1;
%             olh = y1 + h1 - y2;
%             overlapping = 1;
%         % top left of box 1 overlaps with bottom right of box 2
%         % tl2 above left of tl1, and br2 below right of tl1
%         elseif (((x2 <= x1) && (y2 <= y1)) && ((x2 + w2 > x1) && (y2 + h2 > y1)))
%             fprintf('4: tl1 overlaps br2\n')
%             olw = x2 + w2 - x1;
%             olh = y2 + h2 - y1;
%             overlapping = 1;
%         end
%         if (overlapping)
%             olarea = olw * olh; % overlapping area
%             totalarea = w1 * h1 + w2 * h2 - olarea; % non-overlapping area
%             areaprop = olarea/totalarea; % proportion of the total area which is overlapping
%             % save the overlap proportion for this pair of boxes
%             overlap(i, j) = areaprop;
%             fprintf('Overlap width %d, height %d, area %d, total area %d, proportion %f.\n', olw, olh, olarea, totalarea, areaprop);
%             overlapping = 0;
%         end
%     end
% end
% 
% overlap
% [X, Y] = find(overlap > ol_thresh)

end