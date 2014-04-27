function all_ftypes = EnumAllFeatures(W, H)

hlim = [floor(H/2)-2, H-2, H-2, floor(H/2)-2];
wlim = [W-2, floor(W/2)-2, floor(W/3)-2, floor(W/2)-2]; 
ylimf = {@(h)(H-2*h), @(h)(H-h), @(h)(H-h), @(h)(H-2*h)};
xlimf = {@(w)(W-w), @(w)(W-2*w), @(w)(W-3*w), @(w)(W-2*w)};
all_ftypes = zeros(50000, 5);
count = 0;
for i=1:4
   for h=1:hlim(i)
       for w=1:wlim(i)
           ylim = ylimf{i}(h);
           xlim = xlimf{i}(w);
           for x=2:xlim
               for y=2:ylim
                   count = count + 1;
                   all_ftypes(count, :) = [i x y w h];
               end
           end
       end
   end   
end

all_ftypes = all_ftypes(1:count, :);

end