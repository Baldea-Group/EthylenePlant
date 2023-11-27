function Tvapsp = scenario_Tvap(t)
    global Tvapsp
   
    %% 6 hours
    
    if t>= 6*3600
        Tvapsp = -21;
    end
    if t>= 12*3600
        Tvapsp = -19;
    end
    if t>= 18*3600
        Tvapsp = -20;
    end


end