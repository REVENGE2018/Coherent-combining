function fitness = objectiveFunction(params, N_num,Fs, beta_m, f0, t_delay, tau, phase_delay, Imax, SNR, N_Loop)
    K1 = params(1);
    df = params(2);


    f = (0:N_num-1) * df + f0;
    omega = f * 2 * pi;
    dt = 1 / Fs;
    tau_use = tau;
    N_tau = round(tau / dt);
    N_use = round(tau_use / dt);
    N_delay = round(t_delay / dt);
    N_real = N_tau * N_Loop;
    t = dt * (1:N_real);
    
    load('Phase_noise.mat')
    %Phase_noise = ones(N_real, 1) * rand(1, N_num) * 2 * pi; 
    [phase_r, J, efm, acm, stm] = LOCSET(Phase_noise, N_delay, K1, dt, N_tau, N_use, omega, beta_m, phase_delay, N_real, Imax, SNR);
    %fprintf('%.8f%%\n',efm*100);

%     fitness = 1/acm; 
%     acm

    regularization_K1 = 0.01 * K1^2; 
    regularization_df = 0.01 * (df/1e6 - 2.5)^2;
     
    % 
    fitness = -acm + regularization_K1 + regularization_df;

end