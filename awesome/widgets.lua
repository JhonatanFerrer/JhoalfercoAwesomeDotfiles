local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")

-- Volume widget ----------------------------------------------------------
function volume_widget()
    local volume_widget = wibox.widget.textbox()
    vicious.register(
        volume_widget, 
        vicious.widgets.volume,
        function (widget, args)
            volume_icon = ""
            if args[2] == "🔈" then
                volume_icon = "󰖁" 
            else
                if args[1] >= 50 then
                    volume_icon = "󰕾"
                elseif args[1] >= 1 then
                    volume_icon = "󰖀"
                else
                    volume_icon = "󰕿"
                end
            end
            
            return (" "..volume_icon..'%s%% '):format(args[1])
        end,
        .2,
        "Master")
    return volume_widget
end

-- Battery widget -------------------------------------------------------------------------------

function battery_widget()
    local battery_widget = wibox.widget.textbox()
    battery_widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                awful.spawn("tlpui", false)
            end)
            )
        )
    vicious.register(
        battery_widget, 
        vicious.widgets.bat,
        function (widget, args)
            battery_icon = ""
            battery_icons_discharging = {
                [100] = "󰁹",
                [90]  = "󰂂",
                [80]  = "󰂁",
                [70]  = "󰂀",
                [60]  = "󰁿",
                [50]  = "󰁾",
                [40]  = "󰁽",
                [30]  = "󰁼",
                [20]  = "󰁻",
                [10]  = "󰁺",
                [0]   = "󰂎",
            }
            battery_icons_charging = {
                [100] = "󰂅",
                [90]  = "󰂋",
                [80]  = "󰂊",
                [70]  = "󰢞",
                [60]  = "󰂉",
                [50]  = "󰢝",
                [40]  = "󰂈",
                [30]  = "󰂇",
                [20]  = "󰂆",
                [10]  = "󰢜",
                [0]   = "󰢟",
            }
            function battery_state()
                battery_state = args[2]
                while (battery_state % 10 ~= 0)
                do
                    if battery_state <=5 then
                        battery_state = battery_state-1
                    else
                        battery_state = battery_state+1
                    end
                end
                return battery_state
            end
            
            if args[1] == "-" then
                battery_icon = battery_icons_discharging[battery_state()]
            else 
                battery_icon = battery_icons_charging[battery_state()]
            end
            return (" "..battery_icon..'%s%% '):format(args[2])
        end,
        5,
        "BAT1")
    return battery_widget
end

-- Bluetooth widget ---------------------------------------

function bluetooth_widget()
    local bluetooth_widget = wibox.widget.textbox("󰂯 ")
    bluetooth_widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                awful.spawn("kitty -e bluetoothctl", false) -- ToDo: a rofi bluetooth menu
            end)
            )
        )
    return bluetooth_widget
end

-- Power widget ---------------------------------------

function power_widget()
    local power_widget = wibox.widget.textbox("  ")
    power_widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                awful.spawn("bash .config/awesome/powermenu.sh", false)
            end)
            )
        )
    return power_widget
end

-- Net widget ---------------------------------

function network_widget()
    network_widget = wibox.widget.textbox()
    network_widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                awful.spawn("kitty -e nmcli", false) -- ToDo: A rofi network menu
            end)
            )
        )

    vicious.register(network_widget, vicious.widgets.net, 
    function (widget, args)
        local status = ""

        if args["{enp1s0f1 carrier}"] == 1 then
            status = "󰈀 "

        elseif args ["{enp0s16u4 carrier}"] == 1 then
            status = "󰕓󰖩 "
            
        elseif args["{wlp2s0 carrier}"] == 1 then
            local downspeed = args["{wlp2s0 down_kb}"]
            local upspeed = args["{wlp2s0 up_kb}"]
            local quality = (downspeed + upspeed) / 2 -- Calculating average speed
            
            if quality > 1000 then
                status = "󰤨 "
            elseif quality > 500 then
                status = "󰤥 "
            elseif quality > 200 then
                status = "󰤢 "
            else
                status = "󰤟 "
            end
            
        else
            status = "󰲛 "  -- No hay conexión
        end
        
        return " " .. status .. " "
    end, 2)
    return network_widget
end

-- keyboard layout------------------------------------------------
function keyboardlayout()
    local keyboardlayout = awful.widget.keyboardlayout()
    keyboardlayout:buttons(
      awful.util.table.join(
        awful.button({}, 1, function ()
          keyboardlayoutchange()
        end)
        ) 
      )
      return keyboardlayout
    
end 

function keyboardlayoutchange()
    local current_layout = io.popen("setxkbmap -query | grep layout | awk '{print $2}'"):read("*line")

    if current_layout == "es" then
        os.execute("setxkbmap -layout us -variant intl")
    else
        os.execute("setxkbmap es")
    end
end


-- Blank widget, only to separate first and last widgets for borders ---------
function blank()
    local blank = wibox.widget.textbox("   ")
    return blank
end
