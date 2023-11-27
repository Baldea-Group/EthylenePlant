global k01 k02 k0rev Ea1 Ea2 Earev Rgas rho cp rholiq
global F0sp F1sp F2sp Frsp Fpsp Frcombsp Mrxtsp Mvessp Mvapsp Mliqsp Trxtsp Tvessp Tvapsp Tliqsp Xliq_prodsp Xp_sp
global LHV Hr1 Hr2 Hrrev Qves0 Qrxt0 Qelec Qves Q_input Qcomb Mliqsp0 Qnatural Qnatural0
global tau_comb tau_elec tau_ratio
global LHV_f LHV_p LHV_h LHV_c 
global F0 F1 F2 Fp Fr Fr_comb Ntot
global Nf Np Nh Nc ConcF ConcP ConcH r1 r2 rrev
global Kjf Kjp Kjh Kjc Psf Psp Psh Psc Ptot Vtot_ss
global mwf mwp mwh mwc Rgas_atmm3
global T0 T1 T2 Tp Tr Trxt Tves Tvap Tliq
global Mrxt Mves Mvap Mliq
global X0f X0p X0h X0c X1f X1p X1h X1c X2f X2p X2h X2c Xpf Xpp Xph Xpc Xrf Xrp Xrh Xrc
global Xrxtf Xrxtp Xrxth Xrxtc Xvesf Xvesp Xvesh Xvesc Xvapf Xvapp Xvaph Xvapc Xliqf Xliqp Xliqh Xliqc
global tothold_f tothold_p tothold_h tothold_c tot_H
global error_Trxt error_Tves error_Xliqp Kp KI
global co2emission
global tau_ratio Tvessp Trxtsp
global Trxt_spchange_boolean Tves_spchange_boolean F0_feedchange_boolean
global X0_feedchange_boolean Xliq_spchange_boolean puritycontroller_boolean

X0f=1; X0p=0; X0h=0; X0c=0; T0=20;
Mrxtsp = 2 ; Mvessp = 45000 ; Mvapsp = 9.3333; Mliqsp = 3000; Mliqsp0 = 3000; %kg
Trxtsp = 850; Tvessp=-20; Tvapsp=-20; Tliqsp=-20;
Xliq_prodsp = 0.59462;
cp = 1.5 ;                                                                  % heat capacity, kJ/kgC
rho = 1.4 ; rholiq = 450 ;                                                  % density of cracked gas, density of liquid phase 
LHV_f = 35000.000; LHV_p = 28000.000; LHV_h = 120000; LHV_c = 50000;                % lower heating value, kJ/kg
Hr1 = 144.53 ;  Hr2 = 160 ; Hrrev = -144.53;                                % dH of reaction, kJ/mol
Qrxt0 = 97456.735 ;                                                         % Nominal heat to the reactor. kJ/s
Qves0 = -26100 ;                                                            % Heat removal during quenching, kJ/s                                                                % Heat removal during separation, kJ/s
k01 = 9.98362E+13; k02 = 6.99835E+16; k0rev = 2572.367497;                  % k0, s-1
Ea1 = 272838; Ea2 = 360000; Earev = 136500;                                 % activation energy
Rgas = 8.3145; Rgas_atmm3=8.2057E-5;                                        % gas constant 
mwf=0.030; mwp=0.028; mwh=0.002; mwc=0.014;                                 % molar mass, kg/mol
Kjf=0.20816871; Kjp=13.71432545; Kjh=0.0100; Kjc=0.0100;
Psf=1.275; Psp=1.25; Psh=230.418393; Psc=649.4003663; Vtot_ss=8.107329;
Qnatural0 = 2.881043564209598e+03;
tau_ratio = 1;
tau_elec =100; tau_comb = tau_ratio * tau_elec ;

% nominal flowrate, kg/s
F0sp=20; F1sp=20; F2sp=20; Frsp=1.39166709; Fpsp=18.60833291; Frcombsp=1.39166709;
