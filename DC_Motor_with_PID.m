global R L Kb Kt w_ref J B Kp Ki Kd;
R = 2.0; L = 0.5; Kb = 0.1; Kt = 0.1; B = 0.01; w_ref = 20;
Kp = 5.0; Ki = 2.0; Kd = 0.5;

J_list = [0.01, 0.05, 0.10];
colors = {'r', 'b', [0, 0.5, 0]};

function xdot = motor_system(x, t)
  global R L Kb Kt w_ref J B Kp Ki Kd;

  TL = (t<2.5) * 0.05 + (t>=2.5) * 0.4;

  error = w_ref - x(2);

  dw_dt_est = (Kt .* x(1) - B .* x(2) - TL)/J;

  V_raw = (Kp .* error) + (Ki .* x(3)) + (Kd .* -dw_dt_est);
  V_out = max(min(V_raw, 24), -24);

  di_dt = (V_out - Kb .* x(2) - x(1) .* R)/L;
  dw_dt = (Kt .* x(1) - B .* x(2) - TL)/J;
  de_dt = error;

  xdot = [di_dt; dw_dt; de_dt];

endfunction

figure(1); clf;

for i = 1:3
  global J;
  J = J_list(i);
  color = colors{i};

  t = linspace(0, 5, 2000);
  y = lsode("motor_system", [0;0;0], t);

  i_data = y(:,1);
  w_data = y(:,2);
  e_data = y(:,3);

  TL_vec = (t<2.5) * 0.05 + (t>=2.5) * 0.4;
  dw_dt_vec = (Kt .* i_data - B .* w_data - TL_vec')/J;
  V_raw = Kp*(w_ref - w_data) + Ki*e_data + Kd*(-dw_dt_vec);
  V_plot = max(min(V_raw, 24), -24);


  heat_loss = ((i_data) .^ 2) .* R;
  power_output = (Kt .* w_data) .* i_data;
  power_input = max(abs(V_plot .* i_data), 5);
  eff = min(max((power_output ./ power_input) .* 100, 0), 100);

  subplot(3,2,3); hold on; plot(t,i_data,'Color',color,'LineWidth',2); title("Armature current"); ylabel("Current(A)"); xlabel("Time(s)"); grid on;
  subplot(3,2,1); hold on; plot(t,w_data,'Color',color,'LineWidth',2); title("Speed"); ylabel("Speed(rad/s)"); xlabel("Time(s)"); grid on; ylim([0 30]);
  subplot(3,2,5); hold on; plot(t,V_plot,'Color',color,'LineWidth',2); title("Control Voltage"); ylabel("Voltage(V)"); xlabel("Time(s)"); grid on;

  subplot(3,2,2); hold on; plot(t,heat_loss,'Color',color,'LineWidth',2); title("Heat Lost"); ylabel("Heat(J)"); xlabel("Time(s)"); grid on;
  subplot(3,2,4); hold on; plot(t,power_output,'Color',color,'LineWidth',2); title("Output Power"); ylabel("Power(W)"); xlabel("Time(s)"); grid on; ylim([0 30]);
  subplot(3,2,6); hold on; plot(t,eff,'Color',color,'LineWidth',2); title("Efficiency"); ylabel("Efficiency(%)"); xlabel("Time(s)"); grid on;

end

subplot(3,2,1); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5] , 'LineWidth', 0.5, 'LineStyle', '--'); line([0 5], [w_ref w_ref], 'Color', 'k', 'LineWidth', 1, 'LineStyle', '--'); legend('J = 0.01', 'J = 0.05', 'J = 0.10', 'Load Hits', 'Ref Speed', 'location', 'northeastoutside');
subplot(3,2,2); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
subplot(3,2,3); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
subplot(3,2,4); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
subplot(3,2,5); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');
subplot(3,2,6); line([2.5 2.5], ylim, 'Color', [0.5,0.5,0.5], 'LineWidth', 0.5, 'LineStyle', '--');


