function extract_vessels_edge_gray (fundus)
[y,x,~]=size(fundus);
black_flag = 0;

%fundus = rgb2gray(fundus);

temp = fundus;
temp = temp + 255;

for i = 1:x
    for j = 5:y
        %black_flag = 0;
        if fundus(j,i)> 49
            t1 = cast(uint8(fundus(j,i)),'single');
            t2 = cast(uint8(fundus(j-1,i)),'single');
            t3 = cast(uint8(fundus(j-2,i)),'single');
            t4 = cast(uint8(fundus(j-3,i)),'single');
            td = cast(uint8(fundus(j-4,i)),'single');
            tn = (t1+t2+t3+t4)/4;
            gradient = tn/td;
            
            if (gradient) < 0.86
                black_flag = 1;              
            elseif (gradient) > 1
                black_flag = 0;
            end
            if black_flag == 1
                temp (j,i) = 0;
            end
        end
    end
end

% for j = 1:y
%     for i = 1:x
%         if fundus(j,i,1)== 0 && fundus(j,i+3,1)~= 0 && fundus(j,i-3,1)~= 0
%             temp(j,i)=fundus(j,i);
%         end
%     end
% end

%imwrite(temp,'C:\Users\Ojas\Desktop\vessels.png','png');
imwrite(temp,'vessels86.png','png');
%imshow(temp);
end