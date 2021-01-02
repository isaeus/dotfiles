-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
--Link external files
keys = require("keys")

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Defaults
terminal ="alacritty"
editor = os.getenv("EDITOR") or "nano"
browser = "chrome"
file_manager = "thunar"


-- Layouts
awful.layout.layouts={
    awful.layout.suit.floating,
    awful.layout.suit.tile,
}

awful.rules.rules = {
    {
        -- All clients will match this rule.
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.clientkeys,
            buttons = keys.clientbuttons,
            -- screen = awful.screen.preferred,
            screen = awful.screen.focused,
            size_hints_honor = false,
            honor_workarea = true,
            honor_padding = true,
            maximized = false,
            titlebars_enabled = beautiful.titlebars_enabled,
            maximized_horizontal = false,
            maximized_vertical = false,
            placement = floating_client_placement
        },
    },
    -- Centered clients
    {
        rule_any = {
            type = {
                "dialog",
            },
            class = {
                "Steam",
                "discord",
                "music",
                "markdown_input",
                "scratchpad",
            },
            instance = {
                "music",
                "markdown_input",
                "scratchpad",
            },
            role = {
                "GtkFileChooserDialog",
                "conversation",
            }
        },
        properties = { placement = centered_client_placement },
    },
    -- League of Legends client QoL fixes
    {
        rule = { instance = "league of legends.exe" },
        properties = {},
        callback = function (c)
            local matcher = function (c)
                return awful.rules.match(c, { instance = "leagueclientux.exe" })
            end
            -- Minimize LoL client after game window opens
            for c in awful.client.iterate(matcher) do
                c.urgent = false
                c.minimized = true
            end

            -- Unminimize LoL client after game window closes
            c:connect_signal("unmanage", function()
                for c in awful.client.iterate(matcher) do
                    c.minimized = false
                end
            end)
        end
    },


-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
 }

 mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Screen geometry
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

