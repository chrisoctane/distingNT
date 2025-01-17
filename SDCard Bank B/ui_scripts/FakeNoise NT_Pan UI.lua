-- FakeNoise NT-Pan UI Control Script
local xfade1, xfade2  -- X-Fade algorithms
local sum             -- Sum algorithm
local time = 0        -- Time variable for animation

-- Mode toggles
local active_xfade = 0  -- 0 = xfade1, 1 = xfade2
local active_pan = 0    -- 0 = pan1, 1 = pan2
local encoder_fine = 0  -- 0 = fast mode, 1 = fine mode

-- Soft takeover variables
local pot1_last = -1    -- Last pot 1 position (-1 means uninitialized)
local pot2_last = -1    -- Last pot 2 position
local pot1_active = false  -- Whether pot 1 is actively controlling
local pot2_active = false  -- Whether pot 2 is actively controlling

-- Parameter indices
local p_xfade1, p_xfade2  -- X-Fade parameters
local p_pan1, p_pan2      -- Pan parameters
local p_gain1, p_gain2, p_gain3  -- Gain parameters

-- Current values for display
local xfade1_value = 0.5
local xfade2_value = 0.5
local pan1_value = 0
local pan2_value = 0
local gain1_value = 0.5
local gain2_value = 0.5
local gain3_value = 0.0

return {
    name = 'FakeNoise NT-Pan UI',
    author = 'chordsmaze',
    description = 'Dual Channel NT-Pan Control',
    
    init = function()
        -- Find X-Fade algorithms
        xfade1 = findAlgorithm("X-Fade 1")
        if xfade1 == nil then
            return "Could not find X-Fade 1 algorithm"
        end
        
        xfade2 = findAlgorithm("X-Fade 2")
        if xfade2 == nil then
            return "Could not find X-Fade 2 algorithm"
        end
        
        -- Find Sum algorithm
        sum = findAlgorithm("Sum")
        if sum == nil then
            return "Could not find Sum algorithm"
        end
        
        -- Find X-Fade parameters
        p_xfade1 = findParameter(xfade1, "Crossfader")
        p_xfade2 = findParameter(xfade2, "Crossfader")
        if p_xfade1 == nil or p_xfade2 == nil then
            return "Could not find X-Fade parameters"
        end
        
        -- Find Pan parameters
        p_pan1 = findParameter(sum, "1:Pan")
        p_pan2 = findParameter(sum, "2:Pan")
        if p_pan1 == nil or p_pan2 == nil then
            return "Could not find Pan parameters"
        end
        
        -- Find Gain parameters
        p_gain1 = findParameter(sum, "1:Gain")
        p_gain2 = findParameter(sum, "2:Gain")
        p_gain3 = findParameter(sum, "3:Gain")
        if p_gain1 == nil or p_gain2 == nil or p_gain3 == nil then
            return "Could not find Gain parameters"
        end

        -- Set initial values
        setParameterNormalized(sum, p_gain1, gain1_value)
        setParameterNormalized(sum, p_gain2, gain2_value)
        setParameterNormalized(sum, p_gain3, gain3_value)
        
        return true
    end,

    -- Encoder controls for Gain 1 and 2
    encoder1Turn = function(direction)
        local increment = encoder_fine == 1 and 0.01 or 0.05
        gain1_value = math.max(0, math.min(1, gain1_value + direction * increment))
        setParameterNormalized(sum, p_gain1, gain1_value)
    end,

    encoder2Turn = function(direction)
        local increment = encoder_fine == 1 and 0.01 or 0.05
        gain2_value = math.max(0, math.min(1, gain2_value + direction * increment))
        setParameterNormalized(sum, p_gain2, gain2_value)
    end,

    -- Pot controls with soft takeover
    pot1Turn = function(value)
        -- Store last position
        pot1_last = value
        
        -- Get current parameter value based on active mode
        local current = active_xfade == 0 and xfade1_value or xfade2_value
        
        -- Check if we should activate control
        if not pot1_active then
            -- Activate if within threshold of current value
            if math.abs(value - current) < 0.01 then
                pot1_active = true
            end
            return  -- Exit if not active yet
        end
        
        -- Update the value
        if active_xfade == 0 then
            xfade1_value = value
            setParameterNormalized(xfade1, p_xfade1, value)
        else
            xfade2_value = value
            setParameterNormalized(xfade2, p_xfade2, value)
        end
    end,

    pot2Turn = function(value)
        -- Store last position
        pot2_last = value
        
        -- Get current parameter value (normalized 0-1)
        local current
        if active_pan == 0 then
            current = (pan1_value + 100) / 200
        else
            current = (pan2_value + 100) / 200
        end
        
        -- Check if we should activate control
        if not pot2_active then
            -- Activate if within threshold of current value
            if math.abs(value - current) < 0.01 then
                pot2_active = true
            end
            return  -- Exit if not active yet
        end
        
        -- Update the value
        if active_pan == 0 then
            pan1_value = (value * 200) - 100  -- Convert 0-1 to -100/+100
            setParameterNormalized(sum, p_pan1, value)
        else
            pan2_value = (value * 200) - 100  -- Convert 0-1 to -100/+100
            setParameterNormalized(sum, p_pan2, value)
        end
    end,

    pot3Turn = function(value)
        gain3_value = value
        setParameterNormalized(sum, p_gain3, value)
    end,

    -- Pot push controls - reset active state when switching
    pot1Push = function()
        active_xfade = active_xfade == 0 and 1 or 0
        pot1_active = false  -- Reset active state when switching
    end,

    pot2Push = function()
        active_pan = active_pan == 0 and 1 or 0
        pot2_active = false  -- Reset active state when switching
    end,

    -- Button controls
    button1Push = function()
        encoder_fine = encoder_fine == 0 and 1 or 0
    end,

    button4Push = function()
        exit()
    end,

    -- Display
    draw = function()
        -- Draw "NT PAN" text
        drawText(195, 45, "NT PAN")

        -- First row: X-Fade values and active indicator
        drawText(10, 20, string.format("XF1[%s]: %.0f%%  XF2[%s]: %.0f%%", 
            active_xfade == 0 and "*" or " ",
            xfade1_value * 100,  -- Display as exact percentage
            active_xfade == 1 and "*" or " ",
            xfade2_value * 100)) -- Display as exact percentage
            
        -- Second row: Pan values and active indicator
        drawText(10, 35, string.format("P1[%s]: %+.0f  P2[%s]: %+.0f", 
            active_pan == 0 and "*" or " ",
            pan1_value,
            active_pan == 1 and "*" or " ",
            pan2_value))
            
        -- Third row: Gain values with mode indicator
        drawText(10, 50, string.format("G1: %.1f  G2: %.1f  G3: %.1f %s",
            gain1_value,
            gain2_value,
            gain3_value,
            encoder_fine == 1 and "[fine]" or "[fast]"))

        -- Fourth row: Controls info
        drawText(10, 63, "[B1:mode] [PP:toggle] [B4:Exit]")
    end
}