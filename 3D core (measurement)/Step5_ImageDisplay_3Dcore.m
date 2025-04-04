% Step 5: Display 2D cross-sectional images of a core sample.

colorscale = 0.2;
image_height_gap = 0.001;
image_height_base = 0;
fileID = fopen('realcore2723011601time_2_filterapplied/intensity.txt','w+');

global_max = max(result,[],'all');
fprintf(fileID,'max intensity value in the whole model is %d.\n',global_max);
X = 0:voxel:(2*radius);
Y = X;
for cur_height = 0:image_height_gap:height
    cross_section = result(:,:, int32(cur_height/voxel)+1);
    surf(X,Y,cross_section);
    fprintf(fileID,'max intensity value at %f m is %d.\n',cur_height, max(cross_section,[],'all'));
    title(['cross section at ',num2str(cur_height),' m']);
    xlabel('m')
    ylabel('m')
    caxis([0 colorscale])
    colorbar
    shading interp 
    view(2);
    saveas(gcf, sprintf('realcore2723011601time_2_filterapplied/%fm.png', cur_height))
end
fclose(fileID);