%flag = 0;
[m,n,o]=size(fundus);
sq=3;

for i=sq:(m-sq)
    for j=sq:(n-sq)
        if fundus (i,j,1)> 0 && fundus (i,j,2)> 0 && fundus (i,j,2)> 0

            grid_maxR=0;
            grid_minR=0;
            grid_sumR=int16(0);

            grid_maxG=0;
            grid_minG=0;
            grid_sumG=int16(0);

            grid_maxB=0;
            grid_minB=0;
            grid_sumB=int16(0);

            for x=(i-sq+1):(i+sq-1)
                for y=(j-sq+1):(j+sq-1)

                    if grid_maxR < fundus (x,y,1)
                        grid_maxR = fundus (x,y,1);
                    end

                    if grid_minR > fundus (x,y,1)
                        grid_minR = fundus (x,y,1);
                    end

                    grid_sumR = grid_sumR + int16(fundus (x,y,1));

                    if grid_maxG < fundus (x,y,2)
                        grid_maxG = fundus (x,y,2);
                    end

                    if grid_minG > fundus (x,y,2)
                        grid_minG = fundus (x,y,2);
                    end

                    grid_sumG = grid_sumG + int16(fundus (x,y,2));

                    if grid_maxB < fundus (x,y,3)
                        grid_maxB = fundus (x,y,3);
                    end

                    if grid_minB > fundus (x,y,3)
                        grid_minB = fundus (x,y,3);
                    end

                    grid_sumB = grid_sumB + int16(fundus (x,y,3));
                end
            end

            grid_avgR = grid_sumR/25;
            grid_avgG = grid_sumG/25;
            grid_avgB = grid_sumB/25;

            if grid_avgR > 160 && grid_avgR < 190
                if grid_avgG > 18 && grid_avgG < 35
                    if grid_avgB > 8 && grid_avgB < 13
                        temp (i,j,1) = 0;
                        temp (i,j,2) = 0;
                        temp (i,j,3) = 0;
                    end
                end
            end
        end         
    end
end

% for i=1:m
%     for j=1:n
%         if fundus (i,j,1) > 190 && fundus (i,j,1) < 215 && i < 460 && j < 800
%             if fundus (i,j,2) < 70 && fundus (i,j,3) < 40
%                 flag=1;
%             end
%         elseif fundus (i,j,1) > 150 && fundus (i,j,1) < 180
%             if fundus (i,j,2) < 30 && fundus (i,j,3) < 15
%                 flag=1;
%             end
%         end
%         if flag==1
%             temp (i,j,1) = 0;
%             temp (i,j,2) = 0;
%             temp (i,j,3) = 0;
%             flag=0;
%         end
%     end
% end

imwrite(temp,'C:\Users\Ojas\Desktop\vessels_5tap.png','png')
