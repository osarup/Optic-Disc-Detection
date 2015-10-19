for i=1:697
    for j=1:1011
        if fundus (i,j,1) > 250 && fundus (i,j,2) > 250
            temp (i,j,1) = 0;
            temp (i,j,2) = 0;
            temp (i,j,3) = 0;
        end
    end
end

imwrite(temp,'C:\Users\Ojas\Desktop\brightest.png','png')