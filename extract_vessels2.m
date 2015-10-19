fundus2=imread('C:\Users\Ojas\Desktop\fundus2.png');

temp2=fundus2;

flag2 = 0;
[m2,n2,o2]=size(fundus2);

for i=1:m2
    for j=1:n2
        if fundus2 (i,j,1) > 100 && fundus2 (i,j,1) < 115
            if fundus2 (i,j,2) > 70 && fundus2 (i,j,2) < 110 && fundus2 (i,j,3) > 50 && fundus2 (i,j,3) < 100
                flag2=1;
            end
        elseif fundus2 (i,j,1) > 45 && fundus2 (i,j,1) < 60
            if fundus2 (i,j,2) > 30 && fundus2 (i,j,2) < 45 && fundus2 (i,j,3) < 45
                flag2=1;
            end
        end
        if flag2==1
            temp2 (i,j,1) = 0;
            temp2 (i,j,2) = 0;
            temp2 (i,j,3) = 0;
            flag2=0;
        end
    end
end

imwrite(temp2,'C:\Users\Ojas\Desktop\vessels2.png','png')

