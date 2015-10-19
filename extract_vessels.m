flag = 0;
[m,n,o]=size(fundus);

for i=1:m
    for j=1:n
        if fundus (i,j,1) > 190 && fundus (i,j,1) < 215 && i < 460 && j < 800
            if fundus (i,j,2) < 70 && fundus (i,j,3) < 40
                flag=1;
            end
        elseif fundus (i,j,1) > 150 && fundus (i,j,1) < 180
            if fundus (i,j,2) < 30 && fundus (i,j,3) < 15
                flag=1;
            end
        end
        if flag==1
            temp (i,j,1) = 0;
            temp (i,j,2) = 0;
            temp (i,j,3) = 0;
            flag=0;
        end
    end
end

imwrite(temp,'C:\Users\Ojas\Desktop\vessels.png','png')

