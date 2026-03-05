global V Kb Kt R L B J;
V = 24; R = 2.0; L = 0.5; Kb = 0.1; Kt = 0.1; B = 0.01;

function xdot = motor_system(x, t)
  global V Kb Kt R L B J;

  if t < 2.5
    TL = 0.05;
  else
    TL = 0.4;
  end

  di_dt = (V - x(1).*R - Kb.*x(2))/L;

  dw_dt = (Kt.*x(1) - B.*x(2) - TL)/J;

  xdot = [di_dt; dw_dt];

endfunction

J_list = [0.01, 0.05, 0.1];
color = {'r', 'b', [0, 0.5, 0]};

for i = 1:3
  J = J_list(i);

  t = linspace(0, 5, 100);
  y = lsode("motor_system", [0;0] , t)

  % Calculate Power after the solver is done
    current_data = y(:,1);
    speed_data = y(:,2);

    % Power Loss (Heat) = i^2 * R
    heat_loss = (current_data.^2) * R;

    % Useful Mechanical Power = Torque * Speed
    % Torque is Kt * current
    useful_power = (Kt * current_data) .* speed_data;

    total_input_power = V .* current_data;

    efficiency = (useful_power ./ max(0.1, total_input_power)) .* 100;

  subplot(3, 2, 1); hold on;
  plot(t, y(:,1), 'Color', color{i}, 'LineWidth', 2);

  subplot(3, 2, 3); hold on;
  plot(t, y(:,2), 'Color', color{i}, 'LineWidth', 2);

  subplot(3, 2, 2); hold on;
  plot(t, heat_loss, 'Color', color{i}, 'LineWidth', 2);

  subplot(3, 2, 4); hold on;
  plot(t, useful_power, 'Color', color{i}, 'LineWidth', 2);

  subplot(3, 2, 5); hold on;
  plot(t, efficiency, 'Color', color{i}, 'LineWidth', 2);


end

subplot(3,2,1); title("Armature Current Variation"); grid on; xlabel("Time(s)"); ylabel("Armature Current(A)");

subplot(3,2,3); title("Speed Variation"); grid on; xlabel("Time(s)"); ylabel("Speed(rad/s)");

subplot(3,2,2); title("Heat Lost"); grid on; xlabel("Time(s)"); ylabel("Heat(J)");

subplot(3,2,4); title("Useful Power"); grid on; xlabel("Time(s)"); ylabel("Power(W)");

subplot(3,2,5); title("Efficiency"); grid on; xlabel("Time(s)"); ylabel("Efficiency(%)");

subplot(3,2,1); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5] , 'LineWidth', 0.5, 'LineStyle', '--'); legend('J = 0.01', 'J = 0.05', 'J = 0.10', 'Load Hits', 'location', 'northeastoutside');
subplot(3,2,2); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
subplot(3,2,3); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
subplot(3,2,4); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
subplot(3,2,5); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
