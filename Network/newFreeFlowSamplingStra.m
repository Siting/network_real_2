function[POPULATION_2] = newFreeFlowSamplingStra(POPULATION_2, mean_travelTimes, var_travelTimes, sensorMetaDataMap, linkMap, travel_times_new)


condition = 'true';

means_sensor1 = mean_travelTimes(:,1);
vars_sensor1 = var_travelTimes(:,1);
means_sensor2 = mean_travelTimes(:,2);
vars_sensor2 = var_travelTimes(:,2);

sampleSize = size(POPULATION_2(1).samples,2);
vmax1Collection = [];
vmax2Collection = [];
vmax3Collection = [];
vmax4Collection = [];
while(condition)
    % draw random numbers from gaussian distribution t_1
%     t1 = normrnd(means_sensor1,sqrt(vars_sensor1), sampleSize, 1);
%     t2 = normrnd(means_sensor2,sqrt(vars_sensor2), sampleSize, 1);
    t1 = travel_times_new(1,1) + (travel_times_new(end,1) - travel_times_new(1,1)).*rand(sampleSize,1);
    t2 = travel_times_new(1,2) + (travel_times_new(end,2) - travel_times_new(1,2)).*rand(sampleSize,1);
    % draw t_1^1 & t_1^2
    t11 = 0.5.*t1.*rand(1,1);
    t12 = (t1-t11).*rand(1,1);
    % compute t_1^3
    t13 = t1 - t11 - t12;
    % compute t_2^3
    t23 = t13 ./ (sensorMetaDataMap(400739).offsetMiles / linkMap(5).lengthInMiles);
    % compute t_2^4
    t24 = t2 - t11 - t12 - t23;
    % check with restrictions
    if isempty(find(t1<t2 & t11+t12 < t1 & t11+t12+t23<t2 &sign(t1)>0 &  sign(t2)>0 & sign(t11)>0 & sign(t12)>0 & sign(t13)>0 & sign(t24)>0 & sign(t23)>0,1))
        continue
    else

        t11_new = t11(t1<t2 & t11+t12 < t1 & t11+t12+t23<t2 &sign(t1)>0 &  sign(t2)>0 & sign(t11)>0 & sign(t12)>0 & sign(t13)>0 & sign(t24)>0 & sign(t23)>0);
        t12_new = t12(t1<t2 & t11+t12 < t1 & t11+t12+t23<t2 &sign(t1)>0 &  sign(t2)>0 & sign(t11)>0 & sign(t12)>0 & sign(t13)>0 & sign(t24)>0 & sign(t23)>0);
        t23_new = t23(t1<t2 & t11+t12 < t1 & t11+t12+t23<t2 &sign(t1)>0 &  sign(t2)>0 & sign(t11)>0 & sign(t12)>0 & sign(t13)>0 & sign(t24)>0 & sign(t23)>0);
        t24_new = t24(t1<t2 & t11+t12 < t1 & t11+t12+t23<t2 &sign(t1)>0 &  sign(t2)>0 & sign(t11)>0 & sign(t12)>0 & sign(t13)>0 & sign(t24)>0 & sign(t23)>0);
        % calculate vmax
        vmax1 = linkMap(1).lengthInMiles ./ t11_new;
        vmax2 = linkMap(3).lengthInMiles ./ t12_new;
        vmax3 = linkMap(5).lengthInMiles ./ t23_new;
        vmax4 = sensorMetaDataMap(400363).offsetMiles ./ t24_new;
        % check with criteria of below 100
        indices = find(vmax1<170 & vmax2<170 & vmax3<170 & vmax4<170);
    end
       
    vmax1Collection = [vmax1Collection; vmax1(indices)];
    vmax2Collection = [vmax2Collection; vmax2(indices)];
    vmax3Collection = [vmax3Collection; vmax3(indices)];
    vmax4Collection = [vmax4Collection; vmax4(indices)];
    
    disp(['samples ' num2str(size(vmax1Collection,1)) ' are drawn.']);
    
    if size(vmax1Collection,1) >= sampleSize
        condition = false;
    end
end

POPULATION_2(1).samples(1,:) = vmax1Collection(1:sampleSize);
POPULATION_2(3).samples(1,:) = vmax2Collection(1:sampleSize);
POPULATION_2(5).samples(1,:) = vmax3Collection(1:sampleSize);
POPULATION_2(7).samples(1,:) = vmax4Collection(1:sampleSize);