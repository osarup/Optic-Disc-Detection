function extract_vessels_edge (fundus)
[y,x,~]=size(fundus);
black_flag = 0;

temp = fundus;
temp = temp + 255;

for i = 1:x
    for j = 4:y
        if fundus(j,i,1)> 150
            t1 = cast(uint8(fundus(j,i,2)),'single');
            t2 = cast(uint8(fundus(j-1,i,2)),'single');
            t3 = cast(uint8(fundus(j-2,i,2)),'single');
            t4 = cast(uint8(fundus(j-3,i,2)),'single');
            td = cast(uint8(fundus(j-4,i,2)),'single');
            tn = (t1+t2+t3+t4)/4;
            gradient = tn/td;
            
            if (gradient) < 0.75
                black_flag = 1;              
            elseif (gradient) > 1
                black_flag = 0;
            end
            if black_flag == 1
                temp (j,i,1) = 0;
                temp (j,i,2) = 0;
                temp (j,i,3) = 0;
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
%imwrite(temp,'vessels3.png','png');
imshow(temp);
end