%Uses a greyscale image of just the vessels
%to do: add left going points

function find_disc(vessels)
    
    %get rows, columns
    [x,y,~]=size(vessels);
    
    %set number of start points
    n = 100;
    
    %init blank arrays to store coordinates of start points
    i_start = zeros (1,n);
    j_start = zeros (1,n);
    
    %init blank arrays to store coordinates of end points
    i_end_right = zeros (1,n);
    j_end_right = zeros (1,n);
    %i_end_left = zeros (1,n);
    %j_end_left = zeros (1,n);
    
    %init random number generator
    rng('shuffle');
    
    %init 10 points to start from
    for i = 1:n
        [i_start(i), j_start(i)] = init_rand_point(vessels, x, y);
        %vessels(i_start(i),j_start(i)) = 128; %debug
    end
    
    %pass these points to the vessel tracker
    for i = 1:n
        [i_end_right(i), j_end_right(i)] = track_vessels(vessels,i_start(i),j_start(i), 'right', x,y);
        %[i_end_left(i), j_end_left(i)] = track_vessels(vessels,i_start(i),j_start(i), 'left' x,y);
    end
    
    [Distance,Angle] = get_distance(i_end_right,j_end_right,n,x,y);
    
    %UNTESTED
    Cluster_indices = good_cluster (Distance, Angle, n);
    [Ci, Cj] = build_cluster_array(i_end_right, j_end_right, Cluster_indices);
    
    [cx, cy] = centroid(Ci,Cj,Angle,Cluster_indices);
    
    %--------debug functions---------
%     for i = 1:n
%     vessels(i_end_right(i),j_end_right(i)) = 128;
%     end
%     display (i_end_right);
%     display (j_end_right);
%     display (Distance);
%     display (Angle);
%     display (Cluster_indices);
%     display (Ci);
%     display (Cj);
    
    display (cx);
    display (cy);
    vessels(uint16(cx),uint16(cy)) = 128;
    
%     imtool(vessels);
    %-------debuggers end-----------

end

function [i,j] = init_rand_point (img, x, y)

    good = 0;

    while good == 0
        %init random pixel coordinates
        i = randi([5 x-4]); %rows
        j = randi([5 y-4]); %columns
        weight = 0;
        
        if img(i,j) == 0
            %calc total 9x9 grid weight only if starting from black
            for r = -4:4
                for c = -4:4
                    if img(i+r,j+c) == 0
                        weight = weight + 1;
                    end
                end
            end
            
            if weight > 20
                good = 1;
                %display (i, 'i');
                %display (j, 'j');
            end
        end
    end

end

function [i,j] = track_vessels (img, i, j, direction, x,y)

    terminate = 0;
    
    if strcmpi(direction, 'right')
        while terminate == 0
            
           if j+1 <= y 
                if img(i,j+1) == 0 
                    j = j+1;
                else
                    if i+4 <= x && j+4 <= y
                        weight = -1;

                        for r = -4:4
                            for c = 0:4
                                if img(i+r,j+c) == 0
                                    weight = weight + 1;
                                end                       
                            end
                        end

                        if weight > 0
                            topWt = 0;
                            bottomWt = 0;

                            for r = -4:-1
                                for c = -4:4
                                    if img(i+r,j+c) == 0
                                        topWt = topWt + 1;
                                    end
                                end
                            end
                            for r = 1:4
                                for c = -4:4
                                    if img(i+r,j+c) == 0
                                        bottomWt = bottomWt + 1;
                                    end
                                end
                            end

                            j = j+1;

                            if topWt > bottomWt
                                i = i-1;   
                            else
                                if topWt < bottomWt
                                    i = i+1;
                                end
                            end
                        else
                             if img (i,j) == 0
                                 %display('black end');
                                 if img(i+1,j) == 0
                                     %display('below is black');
                                     while img(i+1,j) == 0   
                                        i = i+1;
                                     end
                                 else
                                     if img(i-1,j) == 0
                                         %display('above is black');
                                         while img(i-1,j) == 0
                                            i = i-1;
                                         end
                                     end    
                                 end
                                 j = j+1;
                            else
                                terminate = 1;
                                %display('terminate1');
                            end
                        end
                    else
                        terminate = 1;
                        %display('terminate2');
                    end
                end
           else
               terminate = 1;
               %display('terminate3');
           end
        end
    end
end

function [D, A] = get_distance (X,Y,n,imx,imy)
    
    D = zeros(1,n);
    A = zeros(1,n);
    
    Ox = round(imx/2);
    Oy = round(imy/2);
    
    for i = 1:n
        D(i) = sqrt(((X(i)-Ox)^2) + ((Y(i)-Oy)^2));
        A(i) = atan((X(i)-Ox)/(Y(i)-Oy));
    end
    
end

function index = good_cluster (D, A, n)
    
    index = [];
    
    for i = 1:n
        if D(i) >= 200 && D(i) <= 270 && A(i) < 0.52 && A(i) > -0.52
            index = [index i];
        end
    end
    
end

function [Ci, Cj] = build_cluster_array (I, J, index)
    
    [~,n] = size(index);
    Ci = [];
    Cj = [];
    
    for i = 1:n
         Ci = [Ci I(index(i))];
         Cj = [Cj J(index(i))];
    end

end

function [centroidI, centroidJ] = centroid(Ci,Cj,angle,index)

%computes weighted average of points
%weight = 1/Angle, closer to the centeral line of the sector, higher the weight.
    
    [~,n] = size(index);
    
    wi = zeros(1,n);
    wj = zeros(1,n);
    weight = zeros(1,n);
    
    for i = 1:n
        weight(i) = abs((1/angle(index(i))));
        wi(i) = Ci(i)*weight(i);
        wj(i) = Cj(i)*weight(i);
    end
    
    centroidI = sum(wi,n)/sum(weight,n);
    centroidJ = sum(wj,n)/sum(weight,n);

end

% function sum = customSum (Array, Length)
% 
%     sum = double(0.00001);
%     for i = 1:Length
%         sum = sum + Array(i);
%     end
%     sum
% end