% Step 6: Display the 3D microwave image of the ore particle model.

colorscale = 8*10^(-13);
fileID = fopen('S1goldhemisphericalnew3/intensity.txt','w+');

global_max = max(result,[],'all');
fprintf(fileID,'max intensity value in the whole model is %d.\n',global_max);
X = 0:gap:width;
Y = X;
for cur_height = 0:gap:height
    cross_section = result(:,:, int32(cur_height/gap)+1);
    surf(X,Y,cross_section);
    fprintf(fileID,'max intensity value at %f m is %d.\n',cur_height, max(cross_section,[],'all'));
    title(['cross section at ',num2str(cur_height),' m']);
    xlabel('m')
    ylabel('m')
    axis equal
    caxis([0 colorscale])
    colorbar
    shading interp 
    view(2);
    saveas(gcf, sprintf('S1goldhemisphericalnew3/%fm.png', cur_height))
    %figure;
end
fclose(fileID);

X = 0:gap:width;
Y = 0:gap:height;
surf(X,Y,permute(result(45+1,:,:),[3 2 1]));
title('longitudinal section 1');
xlabel('m')
ylabel('m')
axis equal
caxis([0 colorscale])
colorbar
shading interp 
view(2);
saveas(gcf, sprintf('S1goldhemisphericalnew3/front.png'))

surf(X,Y,permute(result(:,44+1,:),[3 1 2]));
title('longitudinal section 2');
xlabel('m')
ylabel('m')
axis equal
caxis([0 colorscale])
colorbar
shading interp 
view(2);
saveas(gcf, sprintf('S1goldhemisphericalnew3/left.png'))
figure;