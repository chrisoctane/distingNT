-- Core variables
local slew_algo
local mix2_ratio_algo
local mix2_output_algo
local p_attack, p_decay, p_threshold, p_output_gain
local current_page = 1
local confirm_exit = false

-- State tracking
local attack_value = 0
local decay_value = 0
local threshold_value = 0
local output_gain_value = 0

-- Animation
local time = 0
local shake_amount = 0
local SHAKE_DECAY = 0.1
local MAX_SHAKE = 3
local PULSE_RATE = 0.2

-- Layout
local MARGIN = 10
local COL1_X = MARGIN
local COL2_X = 90
local COL3_X = 170
local TOP_MARGIN = 10
local NAV_Y = 58
local ROW1_Y = 20
local ROW1_Y_CONTROL = 25
local ROW2_Y = 35

local ROW2_COL1_X = COL1_X + (COL2_X - COL1_X) / 2
local ROW2_COL2_X = COL2_X + (COL3_X - COL2_X) / 2

local function to_db(normalized)
    return -70 + (normalized * 76)
end

local function updateShake()
    time = time + PULSE_RATE
    shake_amount = shake_amount * (1 - SHAKE_DECAY)
end

local function triggerShake()
    shake_amount = MAX_SHAKE
end

local function drawFlowPage()
    drawText(MARGIN, TOP_MARGIN, "DUCKER SAUCE")
    
    drawRectangle(100, 20, 160, 40, 8)
    drawBox(100, 20, 160, 40, 15)
    drawText(120, 30, ">o)_")
    
    drawRectangle(40, 25, 100, 28, 15)
    drawRectangle(40, 35, 100, 38, 15)
    drawRectangle(160, 30, 220, 33, 15)
    
    drawText(MARGIN, NAV_Y, "[1:FLOW] 2:CTRL 3:INFO")
end

local function drawControlPage()
    drawText(MARGIN, TOP_MARGIN, "DUCKER SAUCE")
    
    updateShake()
    
    drawText(COL1_X, ROW1_Y_CONTROL, string.format("ATK:%3d", math.floor(attack_value * 100)))
    drawText(COL1_X, ROW1_Y_CONTROL + 15, string.format("DEC:%3d", math.floor(decay_value * 100)))
    
    local box_x = 100
    local box_y = 20
    local box_width = 60
    local box_height = 20
    
    local shake_x = math.floor(shake_amount * math.sin(time * 5))
    local shake_y = math.floor(shake_amount * math.cos(time * 3))
    
    local thr_text = string.format("THR:%3.0fdB", to_db(threshold_value))
    drawText(box_x + 5, box_y - 10, thr_text)
    
    drawRectangle(box_x + shake_x, box_y + shake_y, box_x + box_width + shake_x, box_y + box_height + shake_y, 
                 math.max(4, math.floor((1 - threshold_value) * 15)))
    drawBox(box_x + shake_x, box_y + shake_y, box_x + box_width + shake_x, box_y + box_height + shake_y, 15)
    drawText(box_x + 20 + shake_x, box_y + 7 + shake_y, ">o)_")
    
    drawText(190, 35, string.format("OUT:%3.0fdB", to_db(output_gain_value)))
    
    drawText(MARGIN, NAV_Y, "1:FLOW [2:CTRL] 3:INFO")
end

local function drawInfoPage()
    local ROW2_Y = 20
    local ROW3_Y = 30
    local ROW4_Y = 40
    local ROW5_Y = 50

    drawText(COL1_X, TOP_MARGIN, "AUDIO IN:")
    drawText(COL1_X, ROW2_Y, "1: Mono")
    drawText(COL1_X, ROW3_Y, "2: Mono")
    drawText(COL1_X, ROW4_Y, "3&4: Stereo")
    drawText(COL1_X, ROW5_Y, "9: Side")
    
    drawText(COL2_X, TOP_MARGIN, "OUT:")
    drawText(COL2_X, ROW2_Y, "1&2: Main")
    drawText(COL2_X, ROW3_Y, "3: Input")
    drawText(COL2_X, ROW4_Y, "4: Env")
    
    drawText(COL3_X, TOP_MARGIN, "CTRL IN:")
    drawText(COL3_X, ROW2_Y, "10: Attack")
    drawText(COL3_X, ROW3_Y, "11: Decay")
    drawText(COL3_X, ROW4_Y, "12: Thresh")
    
    drawText(MARGIN, NAV_Y, "1:FLOW 2:CTRL [3:INFO]")
end

local function drawConfirmScreen()
    drawText(COL2_X, ROW1_Y, "Exit?")
    drawText(COL1_X, ROW2_Y, "BT1: Yes")
    drawText(COL3_X, ROW2_Y, "BT2/3/4: No")
end

return {
    name = 'Ducker Sauce UI',
    author = 'chordsmaze',
    description = 'UI script for Ducker Sauce preset',
    
    init = function()
        slew_algo = findAlgorithm("Trbo Encabulator")
        if slew_algo == nil then
            return "Could not find Trbo Encabulator"
        end
        
        mix2_ratio_algo = findAlgorithm("Ratio Input 12")
        if mix2_ratio_algo == nil then
            return "Could not find Ratio Input"
        end
        
        mix2_output_algo = findAlgorithm("Mono 1&2 Stro 3&4")
        if mix2_output_algo == nil then
            return "Could not find output mixer"
        end
        
        p_attack = findParameter(slew_algo, "Up/shared slew")
        p_decay = findParameter(slew_algo, "Down slew")
        p_threshold = findParameter(mix2_ratio_algo, "Gain")
        p_output_gain = findParameter(mix2_output_algo, "Output gain")
        
        if p_attack == nil or p_decay == nil or p_threshold == nil or p_output_gain == nil then
            return "Could not find required parameters"
        end
        
        return true
    end,
    
    pot1Turn = function(value)
        attack_value = value
        setParameterNormalized(slew_algo, p_attack, value)
        triggerShake()
    end,
    
    pot2Turn = function(value)
        decay_value = value
        setParameterNormalized(slew_algo, p_decay, value)
        triggerShake()
    end,
    
    pot3Turn = function(value)
        threshold_value = value
        setParameterNormalized(mix2_ratio_algo, p_threshold, value)
        triggerShake()
    end,
    
    encoder2Turn = function(direction)
        output_gain_value = math.max(0, math.min(1, output_gain_value + (direction * 0.01)))
        setParameterNormalized(mix2_output_algo, p_output_gain, output_gain_value)
    end,
    
    button1Push = function()
        if confirm_exit then
            exit()
        else
            current_page = 1
        end
    end,
    
    button2Push = function()
        if confirm_exit then
            confirm_exit = false
        else
            current_page = 2
        end
    end,
    
    button3Push = function()
        if confirm_exit then
            confirm_exit = false
        else
            current_page = 3
        end
    end,
    
    button4Push = function()
        if confirm_exit then
            confirm_exit = false
        else
            confirm_exit = true
        end
    end,
    
    draw = function()
        if confirm_exit then
            drawConfirmScreen()
        else
            if current_page == 1 then
                drawFlowPage()
            elseif current_page == 2 then
                drawControlPage()
            else
                drawInfoPage()
            end
        end
    end
}
