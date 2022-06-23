makemovie='yes';
Nspins = 1000;
dt = 50e-6;
T = 40e-3;
time = 1e3*[dt:dt:T];

spins = 1:Nspins;
    M_all_spins = zeros(3, T/dt+1, Nspins);
    
for s = 1:Nspins
    [FP(s).Afp_dt,FP(s).Bfp_dt] = freeprecess(dt,50e-3,200e-3,0);
end

    for s = spins
        M = [0 0 1]'; % Initialize magnetization
        M_evolution = M;

        for n = 1:length(time)
            if n == 3
                 M = throt(pi / 2, 0) * M; % 90 degree RF pulse
            end 

            if 101 < n < 112
                transverse_angle = 0:2 * pi / Nspins:2 * pi;
                frequency = 1;
                M = zrot(transverse_angle(s) * frequency) * M; % Encoding gradient
            end

            if n == 201
                M = throt(pi / 2, pi / 2) * M; % 90 degree RF pulse
            end

            if 401 < n < 412 
                transverse_angle = 0:2 * pi / Nspins:2 * pi;
                frequency = 1;
                M = zrot(transverse_angle(s) * frequency) * M; % Encoding gradient
            end

            M = FP(s).Afp_dt*M + FP(s).Bfp_dt;     % free precession between pulses!!

            M_evolution = [M_evolution,M];
        end
        M_all_spins(:, :, s) = M_evolution;
    end
M_all_spins = M_all_spins(:,2:end,:);

if strcmp(makemovie,'yes')
fps_output = 25; %frames/s in output movie
siminterval = 5;
Magn2Movie_update(M_all_spins,fps_output,dt,1,siminterval)
end