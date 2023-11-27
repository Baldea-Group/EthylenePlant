function Xliq_prodsp = scenario_purity(t,boolean)
    global Xliq_prodsp

    if boolean == false
        return
    end
    
    if t>= 1*3600
        Xliq_prodsp = 0.60;
    end
    
end