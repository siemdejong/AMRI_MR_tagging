%% INTRODUCTION
% Authors: Siem de Jong & Abel Bregman.
% Supervisor: Anne Spakman (PhD. candidate Amsterdam UMC).
% Course: Advanced MRI final assignment.
% Topic: MR Tagging using SPAMM, C-SPAMM and, if achieved, DENSE.
% Date: 18-06-2022.
% Institute: Vrije Universiteit Amsterdam & Universiteit van Amsterdam.
%% CODE START
clear all
close all

%% BUTTON SECTION
% Here buttons can be added if chosen to implement such structures.
movie.button = 'yes'; % Either yes or no to create magnetization visualization movie.
SPAMM.button = 'yes'; % Either yes or no to toggle the SPAMM tagging module.

%% Step -1: Perform a Bloch simulation of the simplest tagging module : 90RF-Genc-90RF-Gspoil
% SPIN - ECHO FOR 90 RF followed by 90 RF:
% Spin-Echo sequence
% Let us now do a real pulse sequence, with 90 and 90 degree RF pulses.
% This is the tagging module we want to have with now still 2 gradients
% missing.

T1 = 200e-3;
T2 = 100e-3; 
T = 40e-3;
df = 10;
dt = 50e-6;
time = 1e3*[dt:dt:T]; 
TE = 1;
TR = 1;

% define number of spins and freq. range
Nspins = 1000;
dfrange = 2000; %Hz, 2000Hz is the original value
df = (-dfrange/2:dfrange/(Nspins-1):dfrange/2); % frequency range

%define RF pulses
alpha_RF1 = pi/2; % first RF 90* 
alpha_RF2 = pi/2; % second RF 90*

%Calculate free precession matrices Afp_dt and Bfp_dt for each frequency.
%So Afp_dt is the A matrix for free precession during timestep dt governing T1 relaxation and
%Bfp_dt is the B matrix for free precession governing T1 relaxation.
%Note that they are stored in the struct FP for convenience to be able to loop over all spins.

for s = 1:Nspins
    [FP(s).Afp_dt,FP(s).Bfp_dt] = freeprecess(dt,T1,T2,df(s));
end


%% SPIN SIMULATION ----------
disp('simulation in progress.....')

grad_enc = 0.1 * ones(size(time)); % Encoding gradient shape.
grad_crusher = 1000 * ones(size(time)); % Crusher gradient shape.

gamma = 42.58e6;

for s = 1:Nspins
    M = [0 0 1]';
    M_evolution = M;
    
    for n = 1:length(time)
        if n == 2
            M = throt(alpha_RF1,pi/2)*M;    % RF pulse around x-axis (phi = 0)
        end
        
        % Encoding gradient
        if n == 10
            % Gradient encodes for position.
%             grad_enc_rot = 2 * pi * gamma * grad_crusher(n) * dt; % * pos(x)?
            grad_enc_rot = 2 * pi * df(s) * dt; % ?
            M = xrot(grad_enc_rot) * M;
        end 

        if n == 20                  
            M=throt(alpha_RF2,0)*M;  % 90 RF pulse around x-axis (phi = 0). If you want to have it on the +My axis, use pi/2 for the phase phi.
        end             

        % Crusher gradient
        if n == 28
            %
            grad_crusher_rot = 2 * pi * df(s) * dt * 1000;
%             grad_crusher_rot = 2 * pi * gamma * grad_crusher(n) * dt; % * pos(x)?
            M = xrot(grad_crusher_rot) * M;
        end
        
        % -----------------------------------------------------
        M = FP(s).Afp_dt*M + FP(s).Bfp_dt;     % free precession between pulses!!     
        % -----------------------------------------------------
                
        M_evolution = [M_evolution,M];
    end
    M_evolution_allspins(:,:,s) = M_evolution;
end

M_evolution_allspins = M_evolution_allspins(:,2:end,:);
disp('simulation done.....')

%------------------------------
% Plot magnetization over time 
Mx = squeeze(sum(M_evolution_allspins(1,:,:),3))/Nspins;
My = squeeze(sum(M_evolution_allspins(2,:,:),3))/Nspins;
Mz = squeeze(sum(M_evolution_allspins(3,:,:),3))/Nspins;
Mabs = squeeze(abs(sum(M_evolution_allspins(1,:,:)+1i*M_evolution_allspins(2,:,:),3)))/Nspins;

figure(2)

subplot(3,1,1)
plot(time,Mx)
xlabel('time [ms]')
ylabel('Mx')
axis([0 max(time) -1 1])
subplot(3,1,2)
plot(time,My)
xlabel('time [ms]')
ylabel('My')
axis([0 max(time) -1 1])
subplot(3,1,3)
plot(time,Mabs)
xlabel('time [ms]')
ylabel('Mabs')
axis([0 max(time) 0 1])

figure(3)
plot(time, Mx, 'r--', time, My, 'b-.', time, Mz, 'g-')
legend('M_x','M_y','M_z');

% %define RF pulses
% Rflip = yrot(pi/2); % First 90* RF
% Rrefoc = yrot(pi/2); % This is the second 90* RF
% 
% M(:,2)=A*Rflip*M(:,1)+B % We flip the magnetization at the start of the sequence using this.
%                         % So at t=(k=2) we flip Mz to Mx and My
% 
% for k=3:N1+1 % Here we can choose how long we let the signal propagate for.
% 	M(:,k) = A*M(:,k-1)+B;
% end
% 
% % % % HERE A GRADIENT NEEDS TO BE PLACED Genc % % %
% M(:,25) = effrot(0,0,20*dt,df)*M(:,24);
% for k=26:N1+1 % Here we can choose how long we let the signal propagate for.
% 	M(:,k) = A*M(:,k-1)+B;
% end
% 
% % % % SECOND RF PULSE % % % 
% M(:,N1+2)=A*Rrefoc*M(:,N1+1)+B; % IF YOU WANT TO CHANGE THE PLACE OF THE RF PULSe, CHANGE N1
% 
% for k=2:N2-1
% 	M(:,k+N1+1) = A*M(:,k+N1)+B;
% end
% 
% % % % HERE A SPOIL GRADIENT NEEDS TO BE PLACED Gspoil % % %
% M(:,75) = effrot(0,0,40*dt,df)*M(:,74);
% 
% for k=76:N1+1 % Here we can choose how long we let the signal propagate for.
% 	M(:,k) = A*M(:,k-1)+B;
% end



%% STEP 0: Encode phantom with rotating structure and fill/extract k-space
%%%% Phantom code %%%%
N = 128; % Phantom size, 128x128

% Phantom characteristics: 
% First column represents intensities.
% Second and third column represent shape positions.
% Fourth and fifth column represent x and y centers.
% Sixth column represents angles.
E = [  0.4   .69   .92    0     0     0   
        -.3  .6624 .8740   0  -.0184   0
        0.2  .1100 .3100  .28    0    -18
        0.2  .1600 .4100 -.28    0     18
         .1  .2100 .2500   0    .35    0
         .1  .0460 .0460   0     0     0
         .3  .0460 .0460   0   -.2     0
         .1  .0460 .0230 -.08  -.605   0 
         .1  .0230 .0230   0   -.606   0
         .1  .0230 .0460  .06  -.605   0   ]; 

image = phantom(E,N); % Make an object of the phantom as defined above.
figure(4)             % Plot the phantom image.
imshow(image,[]);

%%%% K-space code %%%%
kspace = fft2(image); % Fast fourier 2D of the image to acquire frequency data.
kspace = fftshift(kspace); % Fourier shift to obtain correct k-space coordinates.

kspace = fftshift(fft2(image)); % Code to obtain the image again from k-space.

%%%% Rotating phantom code %%%%
kspacetemp = zeros(size(kspace)); % Code required for filling k-space as movie.
kphase = 1;                       % Code required for filling k-space as movie.
kincr=1;                          % Code required for filling k-space as movie.
imno=1;                           % Code required for filling k-space as movie.

dy=0; % Definition of the variable dy which will be used to move phantom structure(s).

while imno <= 128; % While loop to register every movement of the phantom whilst filling k-space.
  % Novel phantom characteristics: Movement of shape induced by adding dy.
  Enew = [  0.4         .69    .92        0     0     0
            -.3         .6624  .8740      0  -.0184   0
            0.2         .1100  .3100     .28    0    -18
            0.2         .1600  .4100    -.28    0     18
            .1          .2100  .2500      0    .35    0
            .1          .0460  .0460      0     0     0
            .3          .0460  .0460+dy   0   -.2     0
            .1          .0460  .0230    -.08  -.605   0
            .1          .0230  .0230      0   -.606   0
            .1          .0230  .0460     .06  -.605   0   ];
        
  dy=0.1*sin(imno/2); % dy is a periodic movement of sine with amplitude 0.1 and period 2pi/(imno/2).            

  image = phantom(Enew,N);                  % Newly formed image per imno.
  kspace = fftshift(fft2(image));           % Defining k-space.
  maxkspace = max(log10(abs(kspace(:))));   % Defining the max value present in k-space.

  kspacetemp(kphase,:) = kspace(kphase,:);  % Defining kspacetemp variable required for movie.
                                            % kspacetemp consists out of
                                            % the data from an entire individual horizontal
                                            % k-line (so it increments by
                                            % kspace(1,:) --> kspace(128,:)
                                            % over time.

  imrecon = abs(ifft2(ifftshift(kspacetemp)));  % Image reconstruction based on kspacetemp.
  
  % Plotting the new phantom, kspace movie and reconstruction movie.
  figure(5)
  subplot(1,3,1); imshow(image,[0 max(image(:))])
  subplot(1,3,2); imshow(log10(abs(kspacetemp)),[0 maxkspace]);
  subplot(1,3,3); imshow(imrecon,[0 max(imrecon(:))]);

  drawnow % Update figure per timeframe.

  % Incrementing the necessary variables.
  imno = imno+1;
  kphase = kphase+kincr;
end

%% STEP 1: SPAMM MODULE
% Define RF pulses
if strcmp(SPAMM.button, 'yes')
    alpha_RF1 = pi/2; % 1st 90 degree RF pulse
    alpha_RF2 = pi/2; % 2nd 90 degree RF pulse
else
    alpha_RF1 = pi/2; % Only 1 RF implemented
end

RF = load('sinc.txt');              % integral of RF = 1; IF you use sinc10.txt instead of sinc.txt you get a wiggly/ringing artefact in the figure with RFphase.
    NRF = length(RF);               % Length of RF pulse
    pulselength = 5*(1e-3);         % s
    alpha = alpha_RF1;              % radians
    RFabs = alpha*RF(:,1);          % amplitude
    RFphase = RF(:,2)*(pi/180);     % phase

figure (4)
dt = pulselength/NRF;                         % s
time = 1e6*[dt:dt:pulselength];               % ms
gamma = 2*pi*42.57e6;                         % rad/T
B1 = 1e6*RFabs/(gamma*dt);                    % microTesla
B1x = B1.*cos(RFphase);                       % microTesla
B1y = B1.*sin(RFphase);                       % microTesla

subplot(2,2,1)
plot(time,B1);
xlabel('time [ms]')
ylabel('B1 [microTesla]')
axis([0 max(time) -1.1*max(B1) 1.1*max(B1)])
subplot(2,2,2)
plot(time,RFphase);
xlabel('time [ms]')
ylabel('RF phase [rad]')
axis([0 max(time) -2*pi 2*pi])
subplot(2,2,3)
plot(time,B1x);
xlabel('time [ms]')
ylabel('B1x [microTesla]')
axis([0 max(time) -1.1*max(B1) 1.1*max(B1)])
subplot(2,2,4)
plot(time,B1y);
xlabel('time [ms]')
ylabel('B1y [microTesla]')
axis([0 max(time) -1.1*max(B1) 1.1*max(B1)])

% Define gradients
%%%% TO BE CONTINUED %%%%

%% STEP 2: MAGNETIZATION VISUALIZATION
% define time in simulation
t = 10e-3; %s, 40e-3 in the case of question 1E, original is 20e-3;
dt = 50e-6; %s;
time = 1e3*[dt:dt:t]; %ms

% define number of spins and freq. range
Nspins = 1000;
dfrange = 2000; %Hz, 2000Hz is the original value
df = (-dfrange/2:dfrange/(Nspins-1):dfrange/2); % frequency range

%define tissue properties
T1 = 1;       %s
T2 = 1;       %s

%Calculate free precession matrices Afp_dt and Bfp_dt for each frequency.
%So Afp_dt is the A matrix for free precession during timestep dt governing T1 relaxation and
%Bfp_dt is the B matrix for free precession governing T1 relaxation.
%Note that they are stored in the struct FP for convenience to be able to loop over all spins.
for s = 1:Nspins
    [FP(s).Afp_dt,FP(s).Bfp_dt] = freeprecess(dt,T1,T2,df(s));
end

disp('simulation in progress.....')

for s = 1:Nspins
    M = [0 0 1]';
    M_evolution = M;
    
    for n = 1:length(time)
        if strcmp(SPAMM.button, 'yes')
            if n == 1
                M = throt(alpha_RF1,pi/2)*M;    % RF pulse around x-axis (phi = 0).
            end

            if n == 50
                M = throt(alpha_RF2,0)*M;    % Second RF pulse required for tagging.
                % pi/2 phase to obtain positive
                % My.
            end
        else
            if n == 1
                M = throt(alpha_RF1,0)*M;    % RF pulse around x-axis (phi = 0).
            end
        end
        % -----------------------------------------------------
        M = FP(s).Afp_dt*M + FP(s).Bfp_dt;     % free precession between pulses!!     
        % -----------------------------------------------------                
        M_evolution = [M_evolution,M];
    end
    M_evolution_allspins(:,:,s) = M_evolution;
end

M_evolution_allspins = M_evolution_allspins(:,2:end,:);
disp('simulation done.....')

% Plot magnetization over time 
Mx = squeeze(sum(M_evolution_allspins(1,:,:),3))/Nspins;
My = squeeze(sum(M_evolution_allspins(2,:,:),3))/Nspins;
Mabs = squeeze(abs(sum(M_evolution_allspins(1,:,:)+i*M_evolution_allspins(2,:,:),3)))/Nspins;

figure(6)
subplot(3,1,1)
plot(time,Mx)
xlabel('time [ms]')
ylabel('Mx')
axis([0 max(time) -1 1])
subplot(3,1,2)
plot(time,My)
xlabel('time [ms]')
ylabel('My')
axis([0 max(time) -1 1])
subplot(3,1,3)
plot(time,Mabs)
xlabel('time [ms]')
ylabel('Mabs')
axis([0 max(time) 0 1])

% Visualization
if strcmp(movie.button,'yes')
fps_output = 25; %frames/s in output movie
siminterval = 2;
Magn2Movie_update(M_evolution_allspins,fps_output,dt,1,siminterval)
end
