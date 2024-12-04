--[[
--******************************************************************************************
-- ******************************** TBM 9x0 Parking Brake ********************************
--******************************************************************************************

    Made by SIMSTRUMENTATION "EXTERMINATE THE MICE FROM YOUR COCKPIT!"
    GitHub: https://github.com/simstrumentation

    Parking Brake for the TBM 930 in MSFS, and HotStart TBM 900 for X-Plane
    
    
    V1.0 - Released Augst 2021
    v1.01 - Released 2022-01-03
        - X-Plane support for HotStart TMB 900 added by John Green
           
    KNOWN ISSUES:
        - None

   --******************************************************************************************
--]]

-- add graphics
img_blank = img_add("Panel.png",0,0,512,512)
brake_knob  = img_add("knob.png",0,104,382, 382)

-- Initialize a global variable to track brake status
brake_status = 0.0

-- callback function for MSFS 2020
function brake_button_cb()
    fs2020_event("PARKING_BRAKES")
    fsx_event("PARKING_BRAKES")
end

-- callback function for X-Plane
-- Separate function becuase there is no actual command to set the park brake;
-- just a dataref
function xpl_brake_button_cb()
    if brake_status == 1.0 then
        xpl_dataref_write("tbm900/switches/gear/park_brake", "FLOAT", 0.0)
    else
        xpl_dataref_write("tbm900/switches/gear/park_brake", "FLOAT", 1.0)
    end
    request_callback(new_switch_pos)
end 

-- declare button hotspot
if xpl_connected() then
    brake_button = button_add(nil, nil, 0, 0, 512, 512, xpl_brake_button_cb)
else
    brake_button = button_add(nil, nil, 0,0,512,512, brake_button_cb)
end

-- operate brake using bool 
function new_switch_pos(sw_on)
    if sw_on then
        rotate(brake_knob, 90, 192,178, nil, "LINEAR",0.5, CW) 
    else
        rotate(brake_knob, 0, 164,130, nil, "LINEAR",0.5, CCW) 
    end
end

-- operate brake using float
function xpl_new_switch_pos(sw_on)
    brake_status = sw_on
    if sw_on == 1.0 then
        rotate(brake_knob, 90, 192,178, nil, "LINEAR",0.5, CW)
    else
        rotate(brake_knob, 0, 164,130, nil, "LINEAR",0.5, CCW) 
    end
end

-- variable subscribe
if fs2020_connected() then
    fs2020_variable_subscribe("BRAKE PARKING INDICATOR", "Bool", new_switch_pos)
elseif xpl_connected() then
    xpl_dataref_subscribe("tbm900/switches/gear/park_brake", "FLOAT", xpl_new_switch_pos)
end
-- end
