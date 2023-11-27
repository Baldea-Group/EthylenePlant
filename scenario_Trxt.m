function Trxtsp = scenario_Trxt(t,boolean)
    global Trxtsp
   
    if boolean == false
        return
    end

    %% 6 hours
    if t>= 1*3600
        Trxtsp = 855;
    end

end