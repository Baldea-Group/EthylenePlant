% s-function file for the integrated model

function [sys,x0] = integratedmodel(t,x,u,flag)

% Parameters
globalparametersdefine

%% Calculation of variables
if abs(flag)==1 || abs(flag)==3

% converting states into variables
Mrxt=x(1); Xrxtf=x(2); Xrxtp=x(3); Xrxth=x(4); Trxt=x(5); 
Mves=x(6); Xvesf=x(7); Xvesp=x(8); Xvesh=x(9); Tves=x(10); 
Mvap=x(11); Xvapf=x(12); Xvapp=x(13); Xvaph=x(14); Tvap=x(15); 
Mliq=x(16); Xliqf=x(17); Xliqp=x(18); Xliqh=x(19); Tliq=x(20); Q_input=x(21);
Xrxtc=1-Xrxtf-Xrxtp-Xrxth; Xvesc=1-Xvesf-Xvesp-Xvesh;
Xvapc=1-Xvapf-Xvapp-Xvaph; Xliqc=1-Xliqf-Xliqp-Xliqh;
error_Trxt = x(22); error_Tves = x(23); error_Xliqp = x(24);


%% Controller Setpoint Change Section
% Select Scenarios
% Each scenario will be activated only if booleans are true
scenario_Tves(t,Tves_spchange_boolean);       
scenario_Trxt(t,Trxt_spchange_boolean);       
scenario_X0(t,X0_feedchange_boolean);
scenario_F0(t,F0_feedchange_boolean);
scenario_purity(t,Xliq_spchange_boolean);

% Perfect Mixing Assumption
X1f=Xrxtf; X1p=Xrxtp; X1h=Xrxth; X1c=Xrxtc; X2f=Xvesf; X2p=Xvesp; X2h=Xvesh; X2c=Xvesc;
Xrf=Xvapf; Xrp=Xvapp; Xrh=Xvaph; Xrc=Xvapc; Xpf=Xliqf; Xpp=Xliqp; Xph=Xliqh; Xpc=Xliqc;
T1=Trxt; T2=Tves; Tp=Tliq; Tr=Tvap;

% Calculation of molar concentration and reaction rates
ConcF = (Mrxt*Xrxtf)/0.030 /(Mrxt/rho);
ConcP = (Mrxt*Xrxtp)/0.028 /(Mrxt/rho);
ConcH = (Mrxt*Xrxth)/0.002 /(Mrxt/rho);
r1 = (Mrxt/rho)*k01*ConcF*exp(-Ea1/Rgas/(Trxt+273));
r2 = (Mrxt/rho)*k02*ConcP*exp(-Ea2/Rgas/(Trxt+273)); 
rrev = (Mrxt/rho)*k0rev*ConcP*ConcH*exp(-Earev/Rgas/(Trxt+273)); %reactions, mol/s

% Calculation of vapor phase pressure and separator variables
Ptot = Mvap*(Xvapf/mwf+Xvapp/mwp+Xvaph/mwh+Xvapc/mwc)*Rgas_atmm3*(273+Tvap)/(Vtot_ss-Mliq/rholiq);
Nf = Mliq*Kjf*(Xvapf-Xliqf*Psf/Ptot);
Np = Mliq*Kjp*(Xvapp-Xliqp*Psp/Ptot);
Nh = Mliq*Kjh*(Xvaph-Xliqh*Psh/Ptot);
Nc = Mliq*Kjc*(Xvapc-Xliqc*Psc/Ptot);
Ntot=Nf+Np+Nh+Nc;

% Calculation of LHV
LHV = (LHV_f*Xrf + LHV_p*Xrp + LHV_h*Xrh + LHV_c*Xrc)/(Xrf+Xrp+Xrh+Xrc) ;

% Purity Controller in the liquid phase of the separator
if puritycontroller_boolean == true
    Tvessp = -20 - 100*(Xliq_prodsp-Xliqp) - 10 * error_Xliqp;
end

% P controller for holdup controls
F0 = F0sp;
F1 = F1sp*(1 + 0.1*(Mrxt-Mrxtsp));
F2 = F2sp*(1 + 0.1*(Mves-Mvessp));
Fp = Fpsp*(1 + 0.1*(Mliq-Mliqsp));
Fr = Frsp*(1 + 0.1*(Mvap-Mvapsp));
Fr_comb = Fr;          

% Temperature controllers
Kp = 35; KI = 5;
Qnatural= max(0, Qnatural0 + Kp * (Trxtsp-Trxt)+ KI * error_Trxt);
Fr_comb = min(Fr, max(0, Fr + 0.00001*Kp*(Trxtsp - Trxt) + 0.00001*KI*error_Trxt));
Qcomb = LHV*Fr_comb + Qnatural;                       
Qelec = max(0, Qrxt0+ Kp * (Trxtsp - Trxt) + KI * error_Trxt);
Qves = Qves0*(1 - 0.02 * (Tvessp - Tves) - 0.0001*error_Tves );

% For combustion
Qrxt = Qcomb;

% For Electric
% Qrxt = Qelec;

% Calculation of enthalpies
tothold_f = Mrxt * Xrxtf + Mves * Xvesf + Mvap * Xvapf + Mliq * Xliqf;
tothold_p = Mrxt * Xrxtp + Mves * Xvesp + Mvap * Xvapp + Mliq * Xliqp;
tothold_h = Mrxt * Xrxth + Mves * Xvesh + Mvap * Xvaph + Mliq * Xliqh;
tothold_c = Mrxt * Xrxtc + Mves * Xvesc + Mvap * Xvapc + Mliq * Xliqc;
tot_H = cp * (Mrxt * Trxt + Mves * Tves + Mvap * Tvap + Mliq * Tliq);

co2emission = 0.044 * (Fr * (2 * Xvapf/mwf + 2 * Xvapp/mwp + 1 * Xvapc/mwc)+Qnatural/LHV_c/mwc);

end

%% Switch
%% Initialization Block
if abs(flag)==0                     % Initialization                   
    
    sizes = simsizes;
    sizes.NumContStates = 27 ;  % Number of continuous states (equations)
    sizes.NumDiscStates = 0 ;   % Number of discrete states  
    sizes.NumOutputs = 36;
    sizes.NumInputs = 0;        % Number of Inputs
    sizes.DirFeedthrough = 0;
    sizes.NumSampleTimes = 0;
    sys=simsizes(sizes);
    sys=sys(1:6);

    x0 = [Mrxtsp 0.330 0.55533 0.04467 850 ...
           Mvessp 0.330 0.55533 0.04467 -20 ...
           Mvapsp 0.02848 0.03000 0.27208 -20 ...
           Mliqsp 0.35255 0.59462 0.02766 -20 ...
           Qrxt0 0 0 0 11.0533 0 18.03352766]';
   
    x0 = [2	0.330000050588409	0.555333268725474	0.0446666632941061	850.000000008505	45000	0.330000050961215	0.555333268555080	0.0446666632692525	-20.0000000000556	9.33329614179284	0.0284849749790832	0.0300001329321264	0.272081942241219	-20.0000000000556	3000.00000028854	0.352549541929157	0.594621502278305	0.0276588942328905	-20.0000000000606	97456.7304468847	0.0173318808169641	-1.08791640391159e-07	0	0	0 18.22072684]';

    %x0=x0*1.01;
    %x0(1:20)=x0(1:20)*1.01;
    
    F0=F0sp; F1=F1sp; F2=F2sp; Fr=Frsp; Fp=Fpsp; Fr_comb=Frcombsp;
    X0f=1; X0p=0; X0h=0; X0c=0;
    X1f=x0(2); X1p=x0(3); X1h=x0(4); X1c=1-X1f-X1p-X1h;
    X2f=x0(7); X2p=x0(8); X2h=x0(9); X2c=1-X2f-X2p-X2h;
    Xrf=x0(12); Xrp=x0(13); Xrh=x0(14); Xrc=1-Xrf-Xrp-Xrh; 
    Xpf=x0(17); Xpp=x0(18); Xph=x0(19); Xpc=1-Xpf-Xpp-Xph;
    Mrxt=x0(1); Mves=x0(6); Mvap=x0(11); Mliq=x0(16);
    T0=20; T1=x0(5); T2=x0(10); Tr=x0(15); Tp=x0(20); Q_input=x0(21);
    error_Trxt=x0(22); error_Tves=x0(23); error_Xliqp = x0(24);
    
    LHV=68400.99; Qelec=Qrxt0;
    Nf = 6.5603585; Np =  11.06490999; Nh = 0.51469054; Nc = 0.46837388;
    Ntot=18.6083;
    Ptot=25;
    Vtot_ss=8.107329;
    ConcF=15.4; ConcP=27.76667; ConcH=31.26662;
    r1= 448.0952857; r2=50; rrev=1.428571429; % mol/s
    

%% Derivative Block
%  This block is for calcultion of derivatives, represented as mass and
%  energy balances
elseif abs(flag)==1           % Calculate Derivative
  sys=zeros(1,27);
  

  %% Reactor Block
  sys(1) = F0-F1; 
  sys(2) = 1/Mrxt * ( F0 * X0f - F1 * X1f + mwf*(-r1+rrev)-Xrxtf*(F0-F1));
  sys(3) = 1/Mrxt * ( F0 * X0p - F1 * X1p + mwp*(r1-rrev-r2)-Xrxtp*(F0-F1));
  sys(4) = 1/Mrxt * ( F0 * X0h - F1 * X1h + mwh*(r1-rrev)-Xrxth*(F0-F1));

  % for combustion
  sys(5) = 1/cp/Mrxt * (F0*cp*T0 - F1*cp*T1 + Q_input -Hr1*r1- Hr2*r2-Hrrev*rrev-(F0-F1)*Trxt*cp);
  sys(21) = -1/tau_comb * (Q_input -  Qcomb);

  % for electric
  % sys(5) = 1/cp/Mrxt * (F0*cp*T0 - F1*cp*T1 + Q_input -Hr1*r1- Hr2*r2-Hrrev*rrev-(F0-F1)*Trxt*cp);
  % sys(21) = -1/tau_elec * (Q_input - Qelec);

  %% Vessel Block
  sys(6) = F1-F2; 
  sys(7) = 1 / Mves * (F1 * X1f - F2*X2f - Xvesf*(F1-F2)) ; 
  sys(8) = 1 / Mves * (F1 * X1p - F2*X2p - Xvesp*(F1-F2)) ;
  sys(9) = 1 / Mves * (F1 * X1h - F2*X2h - Xvesh*(F1-F2)) ;
  sys(10) = 1/(cp * Mves) * (F1 * cp * T1 - F2 * cp * T2 + Qves - Tves*cp*(F1-F2));

  %% Separator Vapor Block

  sys(11) = F2 - Fr - Ntot;
  sys(12) = 1 / Mvap * (F2 * X2f - Fr*Xrf -Nf - Xvapf*(F2 - Fr - Ntot)) ;
  sys(13) = 1 / Mvap * (F2 * X2p - Fr*Xrp -Np - Xvapp*(F2 - Fr - Ntot)) ;
  sys(14) = 1 / Mvap * (F2 * X2h - Fr*Xrh -Nh - Xvaph*(F2 - Fr - Ntot)) ;
  sys(15) = 1/(cp * Mvap) * (F2 * cp * T2 - Fr * cp * Tr - Ntot * cp* Tvap - Tvap*cp*(F2 - Fr - Ntot));

  %% Separator Liquid Block

  sys(16) = Ntot - Fp;
  sys(17) = 1 / Mliq * (- Fp*Xpf + Nf - Xliqf*(Ntot-Fp)) ;
  sys(18) = 1 / Mliq * (- Fp*Xpp + Np - Xliqp*(Ntot-Fp)) ;
  sys(19) = 1 / Mliq * (- Fp*Xph + Nh - Xliqh*(Ntot-Fp)) ;
  sys(20) = 1/(cp * Mliq) * (- Fp * cp * Tp + Ntot * cp* Tvap - Tliq*cp*(- Fp + Ntot));

  %% PI Controller integrator part (accumulation of error)
  
  sys(22) = Trxtsp - Trxt;
  sys(23) = Tvessp - Tves;
  sys(24) = Xliq_prodsp - Xliqp;

  %% 
  sys(25) = (Trxtsp - Trxt)^2;
  sys(26) = (Xliq_prodsp - Xliqp)^2;
  sys(27) = Fp;

  %% Derivative output
  sys=sys';

%% Output calculation Block
elseif abs(flag)==3            % calculate output
    sys = [x;Qrxt;LHV;Fp;Qnatural;Ptot;Ntot;Fr_comb;tot_H;Qves];
    
    %     [1~27;28;29;30;      31; 32;   33;  34;      35;  36;
   

%% Else
else
        sys=[];
end

end