function DisplayDetections(im, dets)
%DISPLAYDETECTIONS Display rectangles for the coordinates in dets
figure;
imagesc(im)
axis equal
hold on

for i=1:size(dets,1)
    rectangle('Position', dets(i,:),'EdgeColor','r')
end
hold off
end

