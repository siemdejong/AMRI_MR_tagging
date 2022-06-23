clear all
close all
%% Step -1: Perform a Bloch simulation of the simplest tagging module : 90RF-Genc-90RF-Gspoil
M = [1 0 0]';         % Initial magnetization in the X,Y or Z (first, second, third) direction (M0)
t=1e-3;
% Transverse magnetization code
T2 = 0.1; % ms                      
T2decay = exp(-t/T2); % T2 decay formula

% Longitudinal magnetization code
% Mz(t)=M0+[Mz(0)-M0]exp(-t/T1) 
T1 = 0.6; % ms
T1decay = exp(-t/T1);

% Free precession
dt = 1e-3; % ms
df = 10; % Hz, off resonance frequency.
[A,B] = freeprecess(dt, T1, T2, df)

% Now lets plot what we have obtained so far.
duration = 1; % ms, time range
timesteps = ceil(duration/dt)+1;

M = zeros(3,timesteps);
M(:,1) = [1 0 0]'; % So M(:,1) means all data on position 1, so on time step 1. At t=1, M is entirely in X direction.
                   % If you use M(:,1) = [0 0 1]' here, you would
                   % theoretically be correct. However, since M0 is not
                   % excited here, we already state it as being excited by
                   % using M(:,1) = [1 0 0]'.
for k=2:timesteps
	M(:,k) = A*M(:,k-1)+B;
end

time = (0:timesteps-1)*dt; % ms, x-axis range.
plot(time, M(1,:),'b-', time, M(2,:),'r--', time, M(3,:),'g-.')

legend('M_x','M_y','M_z');
xlabel('Time (ms)');
ylabel('Magnetization');
axis([min(time) max(time) -1 1]);
grid on;
%% Simple pulse sequence
% lets now simulate n degree RF pulses excitation spaced TR apart.
% assume that there is no off-resonance, so change df to 0.
M = [0 0 1]'; % Initial magnetization
alpha = pi/2; % x degree flip angle for the RF pulse.
Rflip = yrot(alpha); % precession around the y axis after pulse 
df = 0; % no off-resonance present.
TR = 500e-3; % Repetition time given in appropriate form.
TE = 1e-3; % Echo time given in appropriate form.
T1 = 600e-3; % If you increase T1, the amplitudes will get smaller because of faster T1 relaxation.
T2 = 0.1; % If you increase T2, the peaks will get broader because the T2 relaxation is slower.
t = 1e-3;

% IF WE WANT TO KNOW WHAT THE M IS AT THE SECOND TE, WE NEED TO SIMULATE
% THE FIRST TR. THIS IS DONE HERE BELOW
[Atr,Btr] = freeprecess(TR,T1,T2,df); % Matrices at TR

M= Rflip * M;
M = Atr * M + Btr;

% FOR THE SECOND TE THE M IS GIVEN BY
[Ate,Bte] = freeprecess(TE,T1,T2,df); % Matrices at TE

M = Rflip * M; % Magnetization after tipping away from equilibrium.
M = Ate*M + Bte; % Magnetization at TE

Mss = inv(eye(3)-Atr*Rflip)*Btr % value at steady state prior to excitation 2.

% IF WE WANT TO KNOW THE FIRST 10 EXCITATIONS WE USE
Ntr = round(TR/dt); % Results in the range of 5 seconds.
Nex = 5; % Number of excitations.

M = [0;0;1]; % Initital magnetization
Rflip = yrot(alpha); % tip to y-axis
[A1,B1] = freeprecess(dt,T1,T2,df); 

Mcount=1;
for n=1:Nex
	M(:,Mcount) = Rflip*M(:,Mcount);	

	for k=1:Ntr
		Mcount=Mcount+1;
		M(:,Mcount)=A1*M(:,Mcount-1)+B1;
        
    end
end

time = [0:Mcount-1]*dt;
figure(2)
plot(time,M(1,:),'b-',time,M(2,:),'r--',time,M(3,:),'g-.');
legend('M_x','M_y','M_z');
xlabel('Time (ms)');
ylabel('Magnetization');
axis([min(time) max(time) -1 1]);
grid on;

%% Spin-Echo sequence
% Let us now do a real pulse sequence, with 90 and 180 degree RF pulses.
% The basic spin-echo sequence consists of a 90-degree excitation about y,
% and a 180-degree refocusing pulse about x that is TE/2 after the 90.
T1 = 600e-3;
T2 = 100e-3; 
df = 10;
dt = 1e-3;
t = 1;
TE = 50e-3;
TR = 500e-3;

N1 = round(TE/2/dt);        % This determines when the 180 RF will take place.
N2 = round((TR-TE/2)/dt); % range of x-axis for Mz

% ===== Get the Propagation Matrix ======

[A,B] = freeprecess(dt,T1,T2,df);

% ===== Simulate the Decay ======

M = zeros(3,N1+N2);	% Keep track of magnetization at all time points.
M(:,1)=[0;0;1];	% Starting magnetization.

Rflip = yrot(pi/2);
Rrefoc = xrot(pi);

M(:,2)=A*Rflip*M(:,1)+B;
for k=3:(N1+1)
	M(:,k) = A*M(:,k-1)+B;
end

M(:,N1+2)=A*Rrefoc*M(:,N1+1)+B;

for k=2:N2-1
	M(:,k+N1+1) = A*M(:,k+N1)+B;
end


% ===== Plot the Results ======

time = [0:N1+N2-1]*dt;
plot(time,M(1,:),'b-',time,M(2,:),'r--',time,M(3,:),'g-.');
legend('M_x','M_y','M_z');
xlabel('Time (ms)');
ylabel('Magnetization');
axis([min(time) max(time) -1 1]);
grid on;

% Bloch Equation Simulation, Excercise B-2b
% -----------------------------------------
% 

dt = 1;		% 1ms delta-time.
T = 1000;	% total duration
Nf = 5;		% Number of frequencies.
df = 100*(rand(1,Nf)-.5);	% Hz off-resonance.
T1 = 600;	% ms.
T2 = 100;	% ms.
TE = 50;	% ms.
TR = 500;	% ms.

N1 = round(TE/2/dt);
N2 = round((TR-TE/2)/dt);


% ===== Get the Propagation Matrix ======


clear Msig;

for f=1:length(df)
  [A,B] = freeprecess(dt,T1,T2,df(f));

  % -------- This section taken from b2a ----------------
  M = zeros(3,N1+N2);	% Keep track of magnetization at all time points.
  M(:,1)=[0;0;1];	% Starting magnetization.
  
  Rflip = yrot(pi/2);
  Rrefoc = xrot(pi);
  
  M(:,2)=A*Rflip*M(:,1)+B;
  for k=3:(N1+1)
	  M(:,k) = A*M(:,k-1)+B;
  end;
  
  M(:,N1+2)=A*Rrefoc*M(:,N1+1)+B;
  
  for k=2:N2-1
	  M(:,k+N1+1) = A*M(:,k+N1)+B;
  end;
  % -----------------------------------------------------


  Msig(f,:)=M(1,:)+i*M(2,:);	% Just keep the signal component.

end;


% ===== Plot the Results ======
% 
% figure(1);
% time = [0:N1+N2-1]*dt;
% subplot(2,1,1);
% plot(time,abs(Msig.'));
% xlabel('Time (ms)');
% ylabel('Magnitude');
% axis([min(time) max(time) -1 1]);
% grid on;
% 
% subplot(2,1,2);
% plot(time,angle(Msig.'));
% xlabel('Time (ms)');
% ylabel('Phase (radians)');
% axis([min(time) max(time) -pi pi]);
% grid on;
% 
% 
% figure(2);
% time = [0:N1+N2-1]*dt;
% plot(time,abs(mean(Msig)));
% xlabel('Time (ms)');
% ylabel('Net Magnitude');
% axis([min(time) max(time) -1 1]);
% grid on;

M=gssignal(pi/3,600,100,2,10,0,pi/2)
Mss = greignal(pi/3,600,100,2,10,0)
Mss = srsignal(pi/3,600,100,2,10,0)