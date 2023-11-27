function Tvessp = scenario_Tves(t,boolean)
    global Tvessp

    if boolean == false
        return
    end
    
    %% Increase in Tves set point in every 2 hours by 1 degree 

    if t>= 7200
        Tvessp = -19;
        if t>=14400
            Tvessp = -18;
            if t>=21600
                Tvessp = -17;
                if t>=28800
                    Tvessp = -16;
                    if t>=36000
                        Tvessp = -15;
                        if t>=43200
                            Tvessp = -14;
                        end
                    end
                end
            end
        end
    end

    if t>= 50400
        Tvessp = -13;
        if t>=64800
            Tvessp = -12;
            if t>=72000
                Tvessp = -11;
                if t>=79200
                    Tvessp = -10;
                end
            end
        end
    end

   

end