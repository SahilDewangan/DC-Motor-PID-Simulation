%% DC Motor PID Control Simulation
% Analyzes the effect of varying Moment of Inertia (J) on system stability,
% power consumption, and efficiency under a step load change.


global V Kb Kt R L B J;

% ---Physical Parameters---

V = 24; %Input Voltage
R = 2.0; %resistance
L = 0.5; %inductance
Kb = 0.1; %back EMF constant
Kt = 0.1;  %Torque constant
B = 0.01; %friction coefficient

function xdot = motor_system(x, t)
  global V Kb Kt R L B J;

  %Load Torque variation

  if t < 2.5
    TL = 0.05;
  else
    TL = 0.4;
  end

  % Main Electrical and Mechanical Equations

  di_dt = (V - x(1).*R - Kb.*x(2))/L;

  dw_dt = (Kt.*x(1) - B.*x(2) - TL)/J;

  xdot = [di_dt; dw_dt];

endfunction

% Defining different cases of inertia

J_list = [0.01, 0.05, 0.1];
color = {'r', 'b', [0, 0.5, 0]};

for i = 1:3
  J = J_list(i);

  t = linspace(0, 5, 100);
  y = lsode("motor_system", [0;0] , t)


    current_data = y(:,1);
    speed_data = y(:,2);

    % Power Loss
    heat_loss = (current_data.^2) * R;

    % Useful Mechanical Power
    useful_power = (Kt * current_data) .* speed_data;

    total_input_power = V .* current_data;

    efficiency = (useful_power ./ max(0.1, total_input_power)) .* 100;


  subplot(3, 2, 3); hold on;
  plot(t, y(:,1), 'Color', color{i}, 'LineWidth', 2);

  subplot(3, 2, 1); hold on;
  plot(t, y(:,2), 'Color', color{i}, 'LineWidth', 2);

  subplot(3, 2, 2); hold on;
  plot(t, heat_loss, 'Color', color{i}, 'LineWidth', 2);

  subplot(3, 2, 4); hold on;
  plot(t, useful_power, 'Color', color{i}, 'LineWidth', 2);

  subplot(3, 2, 6); hold on;
  plot(t, efficiency, 'Color', color{i}, 'LineWidth', 2);


end

subplot(3,2,3); title("Armature Current"); grid on; xlabel("Time(s)"); ylabel("Armature Current(A)");

subplot(3,2,1); title("Speed "); grid on; xlabel("Time(s)"); ylabel("Speed(rad/s)");

subplot(3,2,2); title("Heat Lost"); grid on; xlabel("Time(s)"); ylabel("Heat(J)");

subplot(3,2,4); title("Output Power"); grid on; xlabel("Time(s)"); ylabel("Power(W)");

subplot(3,2,6); title("Efficiency"); grid on; xlabel("Time(s)"); ylabel("Efficiency(%)");

subplot(3,2,1); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5] , 'LineWidth', 0.5, 'LineStyle', '--'); legend('J = 0.01', 'J = 0.05', 'J = 0.10', 'Load Hits', 'location', 'northeastoutside');
subplot(3,2,2); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
subplot(3,2,3); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
subplot(3,2,4); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
subplot(3,2,6); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
