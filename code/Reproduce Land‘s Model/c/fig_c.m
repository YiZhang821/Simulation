% SMOOTH SYSTEM
% FIGURE C
% PSM = 11   VSM = 0

clc;
clear all;

% TIME & INPUT
% POSITION INPUT
N_temp = 534;
delta_t = 0.01;
t = 0:delta_t:2*N_temp*delta_t;
NT = 2*N_temp;
t1 = 0:delta_t:N_temp*delta_t;
I_p(1:N_temp+1) = -chirp(t1,0.5,N_temp*delta_t,1)+1;
I_p(N_temp+1:2*N_temp+1) = -chirp(t1,1,N_temp*delta_t,3)+1;
% VELOCITY INPUT
I_v = diff(I_p)/delta_t;

% TIME ALIGNMENT
I_p = I_p(1:NT);
t = t(1:NT);

% PARAMETERS
psm = 11;
vsm = 0;
d = 0.1;
Nd = d/delta_t;

O_p = [];
O_v = [];

% TIME DIFFERENCE EQUATION
for i = 1:NT
    if i<=Nd 
        O_p(i) = 0;
        O_v(i) = 0;
    else
        O_p(i) = O_p(i-1) + psm*(I_p(i-Nd)-O_p(i-Nd))*delta_t + vsm*(I_v(i-Nd)-O_v(i-Nd))*delta_t;
        O_v(i) = (O_p(i)-O_p(i-1))/delta_t;
    end
end

% PERCENTAGE OF TRACKING ERROR
E_p = abs(I_p-O_p);
E_v = abs(I_v-O_v);

El_pos = cumsum(E_p(1:N_temp))/cumsum(I_p(1:N_temp));
Eh_pos = cumsum(E_p(N_temp+1:2*N_temp))/cumsum(I_p(N_temp+1:2*N_temp));
El_vel = cumsum(E_v(1:N_temp))/cumsum(abs(I_v(1:N_temp)));
Eh_vel = cumsum(E_v(N_temp+1:2*N_temp))/cumsum(abs(I_v(N_temp+1:2*N_temp)));

% PLOT
E_p = abs(I_p-O_p);
E_v = abs(I_v-O_v);

El_pos = cumsum(E_p(1:N_temp))/cumsum(I_p(1:N_temp));
Eh_pos = cumsum(E_p(N_temp+1:2*N_temp))/cumsum(I_p(N_temp+1:2*N_temp));
El_vel = cumsum(E_v(1:N_temp))/cumsum(abs(I_v(1:N_temp)));
Eh_vel = cumsum(E_v(N_temp+1:2*N_temp))/cumsum(abs(I_v(N_temp+1:2*N_temp)));

% PLOT
figure('units','normalized','outerposition',[0 0 0.5 1])

subplot(3,1,1)
plot(t,E_p,'k')
xlim([0 NT*delta_t])
% ylim([-1 3])
xlabel('time [sec]')
ylabel('Error')
title({'Figure C';
    ['0.5-1Hz E_{pos} = ',num2str(int16(100*El_pos)),' E_{vel} = ',num2str(int16(100*El_vel))];
    ['  1-3Hz E_{pos} = ',num2str(int16(100*Eh_pos)),' E_{vel} = ',num2str(int16(100*Eh_vel))]} )

subplot(3,1,2)
plot(t,O_p,'k')
xlim([0 NT*delta_t])
% ylim([-1 3])
xlabel('time [sec]')
ylabel('Output')

subplot(3,1,3)
plot(t,I_p,'k')
xlim([0 NT*delta_t])
ylim([-1 3])
xlabel('time [sec]')
ylabel('Input')

savefig(gcf,'c.fig')
saveas(gcf,'c.jpg')
close(gcf)

