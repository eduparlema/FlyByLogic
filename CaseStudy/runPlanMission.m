function [trace, N_drones, goals, obs, d_min, jsonString, rob] = runPlanMission(mission_name)
       addpath('../../scenarios/')
       dd = load(mission_name);
       d_min = dd.myhandle.d_min; 
       handles.myhandle = dd.myhandle;


       jsonString = jsonencode(dd);


       % Get the poisition matrices and robustness
       [handles.myhandle.w_opt, handles.myhandle.optParams, handles.myhandle.time_taken] = planMission(handles.myhandle);


       [negative_rob, xx, yy, zz] = Mission_Robustness_exact(handles.myhandle.w_opt, handles.myhandle.optParams);
       
       % Get information in the workspace

       N_drones = handles.myhandle.optParams.N_drones;
       trace = [];
       rob = -negative_rob; 
       disp(negative_rob)
       disp("PRINTING ROB");
       disp(rob);
       disp(">>>>>>>>")

       time = handles.myhandle.Horizon;
       t = linspace(0, time, size(xx,1))';
       for drone = 1:N_drones
              trace = [trace, xx(:, drone), yy(:, drone), zz(:, drone)];
       end
       trace = horzcat(t, trace);
       goals = handles.myhandle.goal; 
       obs = handles.myhandle.obs; 
end
