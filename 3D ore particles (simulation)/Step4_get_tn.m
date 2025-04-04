% Step 4: Filter out points outside the ore particle.

verts = Sample13Dshapenew3; % Sample13Dshapenew3 is the exported edge points from Samcad X using Step 3 script.
width = 0.08; % the width and height of the bounding box of the ore particle
height = 0.07;
gap = 0.001;
n = width/gap;
h = height/gap;

tri = delaunayn(verts);
rmm = zeros(((n+1)^2)*(h+1), 3);
for i = 0:n
    for j = 0:n
        for r = 0:h
            rmm(i*(n+1)*(h+1)+j*(h+1)+r+1,:) = [ (i-n/2) * gap, (j-n/2) * gap, r*gap];
        end
    end
end
tn = tsearchn(verts, tri, rmm); % Return NaN for all points outside the ore particle.