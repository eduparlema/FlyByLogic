function [trace] = runMission(missionName)
    % add the path for the scenarios 
    addpath('../../scenarios/')
    
    % Load the mission data from the provided filename 
    missionData = load(missionName);

    %create a struct to store results 
    handles.myhandle = missionData.myhandle;

    % Degine the csv output path 
    csv_path = '../../nominal_traces/)';

    % Get the position matrixes and robustness 
    [handles.myhandle.w_opt, handles.myhandle.optParams, handles.myhandle.time_taken] = planMission(handles.myhandle);

    [negative_rob, xx, yy, zz] = Mission_Robustness_exact(handles.myhandle.w_opt, handles.myhandle.optParams);
    
    % Generate traces
    time = handles.myhandle.Horizon;
    t = linspace(0, time, size(xx, 1))';
    N_drones = handles.myhandle.optParams.N_drones;
    trace = [];
    for drone = 1:N_drones
        %rob_column = repmat(-negative_rob, size(xx,1), 1);
        trace = [trace, xx(:, drone), yy(:, drone), zz(:, drone)]; %[rob_column]
    end
    % Include time in the trace
    trace = horzcat(t, trace);
    
    % Output the trace in a file
    columnNames = {'Time'};
    for j = 1:N_drones
        setColumnNames = {sprintf('X%d', j), sprintf('Y%d', j), sprintf('Z%d', j)};
        columnNames = [columnNames, setColumnNames{:}];
    end
    csv_file = strcat(csv_path,'data', num2str(i), '.csv');
    fid = fopen(csv_file, 'w');
    fprintf(fid, '%s,', columnNames{1:end-1});
    fprintf(fid, '%s\n', columnNames{end});
    fclose(fid);
    dlmwrite(csv_file, trace, '-append', 'delimiter', ',');
end