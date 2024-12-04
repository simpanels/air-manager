                          
local knob_width = 90
local switch_width = 60*0.75
local switch_height = 113*0.75
local first_row_y = 100
local second_row_y = 50 
local knob_spacing = 100
local switch_spacing = 80
local top_text_y = 5
local below_top_text_y = 28
local switch_top_text_y = 50
local switch_bottom_text_y = 144
local switch_mid_text_y = switch_top_text_y + (switch_bottom_text_y - switch_top_text_y)/2

local rotation_scalar = 2.75
                                                                              
local hExchDumpL_percent
local hExchDumpR_percent
local aircon_percent
local elecHeatTemp_percent
local hExchTempL_percent
local hExchTempR_percent

text_color_prop = user_prop_add_enum("Text Color", "White, Black", "White", "You can choose a text color for labels")
local text_color = "#DDDDDDFF"
if user_prop_get(text_color_prop) == "White" then
    text_color = "#DDDDDDFF"
else
    text_color = "#020202FF"
end

canvas_vert_lines_id = canvas_add(0, 0, 780,166)
canvas_draw(canvas_vert_lines_id, function()
  local x = 216
  _move_to(x, 20)
  _line_to(x, 155)
  x = 460
  _move_to(x, 20)
  _line_to(x, 155)
  _stroke(text_color, 6)
  
  _arc(59, 100, 315,225, 51, false)
  _stroke(text_color, 4)
  _triangle(100, 60, 102, 72, 90,68)
  _fill(text_color)
  
  _translate(knob_spacing,0)
  _arc(59, 100, 315,225, 51, false)
  _stroke(text_color, 4)
  _triangle(100, 60, 102, 72, 90,68)
  _fill(text_color)
  
  _translate(361,0)
  _arc(59, 100, 315,225, 51, false)
  _stroke(text_color, 4)
  _triangle(100, 60, 102, 72, 90,68)
  _fill(text_color)

  _translate(knob_spacing,0)
  _arc(59, 100, 315,225, 51, false)
  _stroke(text_color, 4)
  _triangle(100, 60, 102, 72, 90,68)
  _fill(text_color)

  _translate(knob_spacing,0)
  _arc(59, 100, 315,225, 51, false)
  _stroke(text_color, 4)
  _triangle(100, 60, 102, 72, 90,68)
  _fill(text_color)

  _translate(-441,24)
  _scale(0.7,0.7)
  _arc(59, 100, 315,225, 51, false)
  _stroke(text_color, 4)
  _triangle(100, 60, 102, 72, 90,68)
  
  _fill(text_color)

end)


local text_format_string = "font:MS33558.ttf; size:18; color:"..text_color.."; halign:center;"
local text_format_string_med = "font:MS33558.ttf; size:16; color:"..text_color.."; halign:center;"
local text_format_string_small = "font:MS33558.ttf; size:14; color:"..text_color.."; halign:center;"
press_air_text = txt_add("PRESS AIR DUMP", text_format_string, 17,top_text_y, 200, 25)
local x_set = -40
press_air_LH_text = txt_add("LH", text_format_string, x_set,below_top_text_y, 200, 25)
press_air_RH_text = txt_add("RH", text_format_string, x_set + knob_spacing,below_top_text_y, 200, 25)
aircon_text = txt_add("AIR CONDITIONING", text_format_string, 246,top_text_y, 200, 25)
x_set = 163
aircon_cooler_text = txt_add("COOLER", text_format_string_med, x_set,below_top_text_y + 10, 200, 25)
x_set = 244
aircon_blower_text = txt_add("BLOWER", text_format_string_small, x_set,switch_bottom_text_y + 8, 200, 25)
aircon_blower_high_text = txt_add("HIGH", text_format_string_small, x_set,switch_top_text_y, 200, 25)
aircon_blower_low_text = txt_add("LOW", text_format_string_small, x_set,switch_bottom_text_y - 8, 200, 25)
x_set = x_set + switch_spacing
aircon_cool_text = txt_add("COOL", text_format_string_small, x_set,switch_top_text_y, 200, 25)
aircon_off_text = txt_add("OFF", text_format_string_small, x_set - 40,switch_mid_text_y, 200, 25)
aircon_circ_text = txt_add("CIRC", text_format_string_small, x_set,switch_bottom_text_y, 200, 25)
x_set = 420
cabin_text = txt_add("CABIN", text_format_string_small, x_set,below_top_text_y - 14, 200, 25)
cabin_text = txt_add("HEAT", text_format_string_small, x_set,below_top_text_y + 2, 200, 25)
cabin_press_air_text = txt_add("CABIN PRESS AIR", text_format_string, x_set + (1.5* knob_spacing),top_text_y, 200, 25)
press_air_LH_text = txt_add("LH WARM", text_format_string_small, x_set + (1 * knob_spacing),below_top_text_y, 200, 25)
press_air_RH_text = txt_add("RH WARM", text_format_string_small, x_set + (2 * knob_spacing),below_top_text_y, 200, 25)

local xpos = 15
--START DUMP
--H.E. Left Dump control
function hExchDumpL_cb(direction)
    if direction == 1 then
        if hExchDumpL_percent < 100.0 then
            hExchDumpL_percent = hExchDumpL_percent + 5
        end
    else
        if hExchDumpL_percent > 0.0 then
            hExchDumpL_percent = hExchDumpL_percent - 5
        end
    end 
    fs2020_variable_write("L:XMLVAR_PRESSURIZATION_CONTROL_LEFT_Position", "Number", var_round(hExchDumpL_percent, 1))
--    fs2020_variable_write("L:CLIMATE_EXCHANGER_CONTROL_LEFT_REDUCER", "Number", var_round(hExchDumpL_percent, 1)*0.7)
    request_callback(hExchDumpL_dial(hExchDumpL_percent))
end
hExchDumpL_id = dial_add(nil, xpos, second_row_y, knob_width, knob_width, hExchDumpL_cb)
hExchDumpL_image = img_add("triangle_knob.png", xpos, second_row_y, knob_width, knob_width)

function hExchDumpL_dial(hExchDumpL_dial)
    hExchDumpL_percent = hExchDumpL_dial
    rotate(hExchDumpL_image, (hExchDumpL_dial * rotation_scalar), "LINEAR", 0.04)
end
fs2020_variable_subscribe("L:XMLVAR_PRESSURIZATION_CONTROL_LEFT_Position", "NUMBER", hExchDumpL_dial)
                                            
--H.E. Right Dump control
function hExchDumpR_cb(direction)
    if direction == 1 then
        if hExchDumpR_percent < 100.0 then
            hExchDumpR_percent = hExchDumpR_percent + 5
        end
    else
        if hExchDumpR_percent > 0.0 then
            hExchDumpR_percent = hExchDumpR_percent - 5
        end
    end 
    fs2020_variable_write("L:XMLVAR_PRESSURIZATION_CONTROL_RIGHT_Position", "Number", var_round(hExchDumpR_percent, 1))
    --fs2020_variable_write("L:CLIMATE_EXCHANGER_CONTROL_RIGHT_REDUCER", "Number", var_round(hExchDumpR_percent, 1)*0.7)
    request_callback(hExchDumpR_dial(hExchDumpR_percent))
end
hExchDumpR_id = dial_add(nil, xpos + knob_spacing, second_row_y, knob_width, knob_width, hExchDumpR_cb)
hExchDumpR_image = img_add("triangle_knob.png", xpos + knob_spacing, second_row_y, knob_width, knob_width)

function hExchDumpR_dial(hExchDumpR_dial)
    hExchDumpR_percent = hExchDumpR_dial
    rotate(hExchDumpR_image, (hExchDumpR_dial * rotation_scalar), "LINEAR", 0.04)
end
fs2020_variable_subscribe("L:XMLVAR_PRESSURIZATION_CONTROL_RIGHT_Position", "NUMBER", hExchDumpR_dial)
--END DUMP

xpos = 229
--START AC KNOB
function aircon_cb(direction)
    if direction == 1 then
        if aircon_percent < 100.0 then
            aircon_percent = aircon_percent + 5
        end
    else
        if aircon_percent > 0.0 then
            aircon_percent = aircon_percent - 5
        end
    end 
    fs2020_variable_write("L:XMLVAR_AIRCON_COOLER_KNOB_Position", "Number", var_round(aircon_percent, 1))
    request_callback(aircon_dial(aircon_percent))
end
aircon_id = dial_add(nil, xpos, second_row_y + 15, knob_width * 0.7, knob_width * 0.7, aircon_cb)
aircon_image = img_add("knob_dn.png", xpos, second_row_y + 15, knob_width * 0.7, knob_width * 0.7)

function aircon_dial(aircon_dial)
    aircon_percent = aircon_dial
    rotate(aircon_image, (aircon_dial * rotation_scalar) - 10, "LINEAR", 0.04)
end
fs2020_variable_subscribe("L:XMLVAR_AIRCON_COOLER_KNOB_Position", "NUMBER",aircon_dial)
--END AC KNOB

xpos = 322
--START AC FAN SWITCH
function aircon_fan_cb(position, direction)
print(position)
    new_pos = (position + direction)
    fs2020_variable_write("L:AIRCON_HI_LOW_SWITCH", "Enum", new_pos)
end
aircon_fan_id = switch_add ( "white_down.png", "white_up.png", xpos, second_row_y +10, switch_width, switch_height, "VERTICAL", aircon_fan_cb)

function aircon_fan_pos(pos)
    switch_set_position(aircon_fan_id, pos)
end
fs2020_variable_subscribe("L:AIRCON_HI_LOW_SWITCH", "Enum", aircon_fan_pos)
--END AC FAN SWITCH

--START AC COMPRESSOR SWITCH
function aircon_switch_cb(position, direction)
print(position)
    new_pos = (position + direction)
    fs2020_variable_write("L:GENERIC_Momentary_AIRCON_COOL_SWITCH_1", "Enum", new_pos)
end
aircon_sw_id = switch_add ( "white_down.png", "white_mid.png", "white_up.png", xpos + switch_spacing, second_row_y +10, switch_width, switch_height, "VERTICAL", aircon_switch_cb)

function aircon_pos(pos)
    switch_set_position(aircon_sw_id, pos)
end
fs2020_variable_subscribe("L:GENERIC_Momentary_AIRCON_COOL_SWITCH_1", "Enum", aircon_pos)
--END AC COMPRESSOR SWITCH

xpos = 475
--START ELECT HEAT
function elecHeatTemp_cb(direction)
    if direction == 1 then
        if elecHeatTemp_percent < 100.0 then
            elecHeatTemp_percent = elecHeatTemp_percent + 5
        end
    else
        if elecHeatTemp_percent > 0.0 then
            elecHeatTemp_percent = elecHeatTemp_percent - 5
        end
    end 
    fs2020_variable_write("L:XMLVAR_CABIN_AIR_HEAT_Position", "Number", var_round(elecHeatTemp_percent, 1))
--    fs2020_variable_write("L:CLIMATE_HEATER_LOW_KNOB", "Number", var_round(elecHeatTemp_percent, 1)*0.6)
--    fs2020_variable_write("L:CLIMATE_HEATER_HIGH_KNOB", "Number", var_round(elecHeatTemp_percent, 1)*0.8)
    request_callback(elecHeatTemp_dial(elecHeatTemp_percent))
end
elecHeatTemp_id = dial_add(nil, xpos, second_row_y, knob_width, knob_width, elecHeatTemp_cb)
elecHeatTemp_image = img_add("triangle_knob.png", xpos, second_row_y, knob_width, knob_width)

function elecHeatTemp_dial(elecHeatTemp_dial)
    elecHeatTemp_percent = elecHeatTemp_dial
    rotate(elecHeatTemp_image, (elecHeatTemp_dial * rotation_scalar), "LINEAR", 0.04)
end
fs2020_variable_subscribe("L:XMLVAR_CABIN_AIR_HEAT_Position", "NUMBER", elecHeatTemp_dial)
--END ELECT HEAT

--START HEAT EXCHANGER TEMP CONTROLS

--H.E. Left Temp control
function hExchTempL_cb(direction)
    if direction == 1 then
        if hExchTempL_percent < 100.0 then
            hExchTempL_percent = hExchTempL_percent + 5
        end
    else
        if hExchTempL_percent > 0.0 then
            hExchTempL_percent = hExchTempL_percent - 5
        end
    end 
    fs2020_variable_write("L:XMLVAR_HEAT_EXCHANGER_HANDLE_LEFT_Position", "Number", var_round(hExchTempL_percent, 1))
--    fs2020_variable_write("L:CLIMATE_EXCHANGER_LEFT_KNOB", "Number", var_round(hExchTempL_percent, 1)*0.7)
    request_callback(hExchTempL_dial(hExchTempL_percent))
end
hExchTempL_id = dial_add(nil, xpos + (1*knob_spacing), second_row_y, knob_width, knob_width, hExchTempL_cb)
hExchTempL_image = img_add("triangle_knob.png", xpos + (1*knob_spacing), second_row_y, knob_width, knob_width)

function hExchTempL_dial(hExchTempL_dial)
    hExchTempL_percent = hExchTempL_dial
    rotate(hExchTempL_image, (hExchTempL_dial * rotation_scalar), "LINEAR", 0.04)
end
fs2020_variable_subscribe("L:XMLVAR_HEAT_EXCHANGER_HANDLE_LEFT_Position", "NUMBER", hExchTempL_dial)
                                            
--H.E. Right Temp control
function hExchTempR_cb(direction)
    if direction == 1 then
        if hExchTempR_percent < 100.0 then
            hExchTempR_percent = hExchTempR_percent + 5
        end
    else
        if hExchTempR_percent > 0.0 then
            hExchTempR_percent = hExchTempR_percent - 5
        end
    end 
    fs2020_variable_write("L:XMLVAR_HEAT_EXCHANGER_HANDLE_RIGHT_Position", "Number", var_round(hExchTempR_percent, 1))
    --fs2020_variable_write("L:CLIMATE_EXCHANGER_RIGHT_KNOB", "Number", var_round(hExchTempR_percent, 1)*0.7)
    request_callback(hExchTempR_dial(hExchTempR_percent))
end
hExchTempR_id = dial_add(nil, xpos + (2*knob_spacing), second_row_y, knob_width, knob_width, hExchTempR_cb)
hExchTempR_image = img_add("triangle_knob.png", xpos + (2*knob_spacing), second_row_y, knob_width, knob_width)

function hExchTempR_dial(hExchTempR_dial)
    hExchTempR_percent = hExchTempR_dial
    rotate(hExchTempR_image, (hExchTempR_dial * rotation_scalar), "LINEAR", 0.04)
end
fs2020_variable_subscribe("L:XMLVAR_HEAT_EXCHANGER_HANDLE_RIGHT_Position", "NUMBER", hExchTempR_dial)
--END HEAT EXCHANGER TEMP CONTROLS
                                                                                                                                                                                                                                            