function [X0f,X0p,X0h,X0c] = scenario_F0(t,boolean)
    global F0sp

    if boolean == false
        return
    end
   
    %% Change Production Rate F0

    if t > 1*3600
        F0sp = 21;
    end
   
    if t>30000
        F0sp = 19;
        if t>50000
            F0sp = 20;
        end
    end
    

end