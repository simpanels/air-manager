--add graphics
img_add_fullscreen("FuelSelectPanel.png")
img_knob = img_add("FuelSelectKnob.png", 4, -35, 382, 338)

-- set functions to switch tanks
function callback_left()
    fs2020_event("FUEL_SELECTOR_LEFT")
end    

function callback_right()
    fs2020_event("FUEL_SELECTOR_RIGHT")
end

function callback_off()
    fs2020_event("FUEL_SELECTOR_OFF")
end
-- set touch zones for switch activation
button_off = button_add(nil,nil,100,45,150,150,callback_off)
button_left = button_add(nil,nil,122,185,150,150,callback_left)
button_right = button_add(nil,nil,240,185,150,150,callback_right)

function new_pos_select(tank)
    if (tank == 2) then -- left tank
        rotate(img_knob, -90, "LINEAR", 0.05)
    elseif (tank == 3) then -- right tank
        rotate(img_knob, -180, "LINEAR", 0.05)
    elseif (tank == 0) then -- fuel off
        rotate(img_knob, 0, "LINEAR", 0.05)
    end
end

fs2020_variable_subscribe("RECIP ENG FUEL TANK SELECTOR:1", "enum", new_pos_select)