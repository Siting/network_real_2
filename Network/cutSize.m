function[new_travel_times] = cutSize(old_travel_times)

global expectAR
new_travel_times = [];
for i = 1 : size(old_travel_times,2)
    old_travel_time = old_travel_times(:,i);
    % sort in ascending order
    old_travel_time = sort(old_travel_time, 'ascend');
    totalNumber = size(old_travel_time,1);
    cutNumber = ceil(totalNumber * (1-expectAR));
    headCut = floor(cutNumber * 0.5);
    tailCut = cutNumber - headCut;

    % cut head
    old_travel_time = old_travel_time(headCut+1:end);
    % cut tail
    new_travel_times(:,i) = old_travel_time(1:size(old_travel_time,1)-tailCut);
end
