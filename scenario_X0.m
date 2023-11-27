function [X0f,X0p,X0h,X0c] = scenario_X0(t,boolean)
    global X0f X0p X0h X0c
    
    if boolean == false
        return
    end

    X0f = 1; X0p = 0; X0h = 0; X0c = 0;

    %% Change in Feed Composition

    if t > 3600
        X0f = 0.90; X0p = 0.10; X0h = 0.00; X0c = 0.00;
        if t>50000
            X0f = 1; X0p =0; X0h = 0; X0c = 0;
        end
    end
   

end