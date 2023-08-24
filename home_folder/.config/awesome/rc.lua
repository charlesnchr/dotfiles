-- If LuaRocks is installed, meke sure that packages installed through it arelocal cyclefocus = require('cyclefocus')
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local dpi   = require("beautiful.xresources").apply_dpi
require("awful.autofocus")
local freedesktop   = require("freedesktop")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

require('auto-start')
require('modules.notifications')
require('modules.decorate-client')
require('modules.quake-terminal')

-- dofile('sliders.lua')
hostname = io.popen("uname -n"):read()

-- fix screen order on work pc -- otherwise west/east monitor is inversed
if hostname == "alienware" then
    if screen.count() == 3 then
        screen[2]:swap(screen[3])
    end
end

-- resize floating windows
-- require("collision")()
-- collision_resize_width = 0

-- doesnt work yet
-- require('volume-adjust')

local revelation=require("revelation")
local cyclefocus = require('cyclefocus')
local TaskList = require('widget.task-list')
local lain  = require("lain")
local separators = lain.util.separators
local markup = lain.util.markup

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/"
theme.fg_normal                                 = "#FEFEFE"
theme.fg_focus                                  = "#32D6FF"
theme.fg_urgent                                 = "#C83F11"
theme.bg_normal                                 = "#222222"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.font                                      = "sans 10"

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
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
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
revelation.init()

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
awful.util.terminal = terminal
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw5
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Manual", string.format("%s -e man awesome", terminal) },
   { "Edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
   { "Restart", awesome.restart },
   { "Quit", function() awesome.quit() end },
}

awful.util.mymainmenu = freedesktop.menu.build {
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- close menu when mouse leaves?
-- awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function()
--     if not awful.util.mymainmenu.active_child or
--        (awful.util.mymainmenu.wibox ~= mouse.current_wibox and
--        awful.util.mymainmenu.active_child.wibox ~= mouse.current_wibox) then
--         awful.util.mymainmenu:hide()
--     else
--         awful.util.mymainmenu.active_child.wibox:connect_signal("mouse::leave",
--         function()
--             if awful.util.mymainmenu.wibox ~= mouse.current_wibox then
--                 awful.util.mymainmenu:hide()
--             end
--         end)
--     end
-- end)

-- {{{ Wibar

local arrow = separators.arrow_left

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem, true)
-- memicon.forced_height = 20
-- local memicon = wibox.widget {
--     image  = theme.widget_mem,
--     resize = true,
--     widget = wibox.widget.imagebox
-- }
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)

-- local cpuicon =  wibox.widget {
--     image         = theme.widget_cpu,
--     dpi           = 10,
--     resize        = true,
--     forced_height = 30,
--     forced_width  = 30,
--     widget        = wibox.widget.imagebox
--     }
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

widget_battery = require('widget.battery')

-- local watch = awful.widget.watch('sh bin/i3status-inactivity-suspend.sh', 15)
-- local watch = awful.widget.watch('echo "😅hej"', 15)
local inactivity_suspend_status = wibox.widget{
    font = "sans 18",
    widget = awful.widget.watch('sh bin/i3status-inactivity-suspend.sh', 2),
    buttons = gears.table.join(
    awful.button({ }, 1, function () awful.spawn.with_shell("sh ~/bin/i3status-inactivity-suspend.sh set") end))
}
local presentation_status = wibox.widget{
    font = "sans 18",
    widget = awful.widget.watch('sh bin/i3status-presentation.sh', 2),
    buttons = gears.table.join(
    awful.button({ }, 1, function () awful.spawn.with_shell("sh ~/bin/i3status-presentation.sh set") end))
}
-- Create a textclock widget
textclock = wibox.widget.textclock()

local function rounded_shape(size, partial)
    if partial then
        return function(cr, width, height)
                   gears.shape.partially_rounded_rect(cr, width, height,
                        false, true, false, true, 5)
               end
    else
        return function(cr, width, height)
                   gears.shape.rounded_rect(cr, width, height, size)
               end
    end
end

-- Add a calendar (credits to kylekewley for the original code)
local month_calendar = awful.widget.calendar_popup.month({
  screen = s,
  start_sunday = false,
  week_numbers = true,
  style_month   = { padding      = 5,
                   bg_color     = '#555555',
                   border_width = 2,
                   shape        = rounded_shape(10)
               },
    style_normal  = { shape    = rounded_shape(5),
                       border_color = "#777777",
},
    style_focus   = { fg_color = '#000000',
                       bg_color = '#ff9800',
                       markup   = function(t) return '<b>' .. t .. '</b>' end,
                       shape    = rounded_shape(5, true)
    },
    style_header  = { fg_color = '#de5e1e',
                       markup   = function(t) return '<b>' .. t .. '</b>' end,
                       shape    = rounded_shape(10)
    },
    style_weekday = { fg_color = '#7788af',
                       markup   = function(t) return '<b>' .. t .. '</b>' end,
                       shape    = rounded_shape(5),
                       border_color = "#ff9800",
                       border_width = 0
    },
    style_weeknumber = { fg_color = '#7788af',
                       markup   = function(t) return '<b>' .. t .. '</b>' end,
                       shape    = rounded_shape(5),
                       opacity = 0.5
    },
})
month_calendar:attach(textclock)




-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper -- nice option for same image on all
    -- set_wallpaper(s)
    -- naughty.notify({text=tostring(screen.count())})

    if screen.count() == 1 then
            awful.tag.add("🤖", { screen = s, selected = true, layout = awful.layout.layouts[2], gap = 3, gap_single_client = true })
            awful.tag.add("🌎", { screen = s, layout = awful.layout.layouts[2], gap = 3, gap_single_client = true })
            awful.tag.add("🐺", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client = true })
            awful.tag.add("🐋", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client = true })
            awful.tag.add("📭", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client = true })
            awful.tag.add("🎵", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client = true })
            awful.tag.add("🏰", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client = true })
            awful.tag.add("🐧", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client = true })
            awful.tag.add("📓", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client = true })
    elseif screen.count() == 2 then
        if s.index == 1 then
            -- awful.tag({ "🤖", "🌎", "🐺", "🐋", "📭" }, s, awful.layout.layouts[1])
            awful.tag.add("🤖", { screen = s, selected = true, layout = awful.layout.layouts[2], gap = 3, gap_single_client  = true })
            awful.tag.add("🌎", { screen = s, layout = awful.layout.layouts[2], gap = 3, gap_single_client  = true })
            awful.tag.add("🐺", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
            awful.tag.add("🐋", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
            awful.tag.add("📭", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
            awful.tag.add("🐧", { screen = s, selected = true, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
            awful.tag.add("📓", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
        elseif s.index == 2 then
            awful.tag.add("🎵", { screen = s, selected = true, layout = awful.layout.layouts[3], gap = 3, gap_single_client  = true })
            awful.tag.add("🏰", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
        end
    else
        -- Each screen has its own tag table.
        if s.index == 1 then
            -- awful.tag({ "🤖", "🌎", "🐺", "🐋", "📭" }, s, awful.layout.layouts[1])
            awful.tag.add("🤖", { screen = s, selected = true, layout = awful.layout.layouts[2], gap = 3, gap_single_client  = true })
            awful.tag.add("🌎", { screen = s, layout = awful.layout.layouts[2], gap = 3, gap_single_client  = true })
            awful.tag.add("🐺", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
            awful.tag.add("🐋", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
            awful.tag.add("📭", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
            awful.tag.add("🗿", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
        elseif s.index == 2 then
            awful.tag.add("🐧", { screen = s, selected = true, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
            awful.tag.add("📓", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
            awful.tag.add("⚗", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
        elseif s.index == 3 then
            awful.tag.add("🎵", { screen = s, selected = true, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
            awful.tag.add("🏰", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
            awful.tag.add("🔬", { screen = s, layout = awful.layout.layouts[1], gap = 3, gap_single_client  = true })
        end
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    -- s.mytasklist = awful.widget.tasklist {
    --     screen  = s,
    --     filter  = awful.widget.tasklist.filter.currenttags,
    --     buttons = tasklist_buttons,
    --     layout  = wibox.layout.fixed.horizontal(),
    --     widget_template = {
    --         {
    --             {
    --                 {
    --                     {
    --                         widget = awful.widget.clienticon,
    --                     },
    --                     margins = 3,
    --                     widget  = wibox.container.margin,
    --                 },
    --                 {
    --                     id     = "text_role",
    --                     widget = wibox.widget.textbox,
    --                 },
    --                 layout = wibox.layout.fixed.horizontal,
    --             },
    --             left  = 10,
    --             right = 10,
    --             widget = wibox.container.margin
    --         },
    --         forced_width = 150,
    --         id     = "background_role",
    --         widget = wibox.container.background,
    --     },
    --     buttons = tasklist_buttons
    -- }

    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        }
    }


    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(22), bg = theme.bg_normal, fg = theme.fg_normal})
    -- s.mywibox.buttons(taglist_buttons)

    local mic_widget = require('mic-widget.volume')
    local volume_widget = require('volume-widget.volume')
    local cpu_widget = require("widget.cpu-widget.cpu-widget")
    local pomodoroarc_widget = require("widget.pomodoroarc-widget.pomodoroarc")


    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.container.background(wibox.container.margin(s.mytaglist, dpi(5), dpi(50)), theme.bg_normal),
            s.mypromptbox,
        },
        {
            layout = wibox.layout.flex.horizontal,
            s.mytasklist
            -- TaskList(s)
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            pomodoroarc_widget,
            arrow("#5B60711A", "#5366B6"),
            wibox.container.background(wibox.container.margin(inactivity_suspend_status, dpi(8), dpi(4)), "#5366B6"),
            wibox.container.background(wibox.container.margin(presentation_status, dpi(4), dpi(8)), "#5366B6"),
            arrow("#5366B6", "#2A5878"),
            wibox.container.background(wibox.container.margin(volume_widget{ widget_type = 'icon_and_text', font = 'sans 10' }, dpi(2), dpi(3)), "#2A5878"),
            arrow("#2A5878", "#4A556E"),
            wibox.container.background(wibox.container.margin(mic_widget{ widget_type = 'icon_and_text', font = 'sans 10' }, dpi(2), dpi(3)), "#4A556E"),
            arrow("#4A556E", "#344356"),
            wibox.container.background(wibox.container.margin(wibox.widget { memicon, mem.widget, layout = wibox.layout.align.horizontal }, dpi(2), dpi(3)), "#344356"),
            arrow("#344356", "#4B696D"),
            wibox.container.background(wibox.container.margin(wibox.widget { cpuicon, cpu.widget, layout = wibox.layout.align.horizontal }, dpi(3), dpi(4)), "#4B696D"),
            wibox.container.background(wibox.container.margin(cpu_widget(), dpi(3), dpi(4)), "#4B696D"),
            widget_battery,
            wibox.layout.margin(wibox.widget.systray(), dpi(10), dpi(1), dpi(2), dpi(2)),
            wibox.container.background(wibox.container.margin(textclock, dpi(10), dpi(10)), "#5B60711A"),
            cal,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end)
))
-- }}}





local r_ajust = {
    left  = function(c, d) return { x      = c.x      - d, width = c.width   + d } end,
    right = function(c, d) return { width  = c.width  + d,                       } end,
    up    = function(c, d) return { y      = c.y      - d, height = c.height + d } end,
    down  = function(c, d) return { height = c.height + d,                       } end,
}
-- Resize tiled using the keyboard
local layouts_all = {
    [awful.layout.suit.floating]    = { right = "" },
    [awful.layout.suit.tile]        = { right = {mwfact= 0.05}, left = {mwfact=-0.05}, up ={wfact=-0.1  }, down = {wfact = 0.1 } },
    [awful.layout.suit.tile.left]   = { right = {mwfact=-0.05}, left = {mwfact= 0.05}, up ={wfact= 0.1  }, down = {wfact =-0.1 } },
    [awful.layout.suit.tile.bottom] = { right = {wfact=-0.1  }, left = {wfact= 0.1  }, up ={mwfact=-0.05}, down = {mwfact= 0.05} },
    [awful.layout.suit.tile.top]    = { right = {wfact=-0.1  }, left = {wfact= 0.1  }, up ={mwfact= 0.05}, down = {mwfact=-0.05} },
    [awful.layout.suit.spiral]      = { right = {wfact=-0.1  }, left = {wfact= 0.1  }, up ={mwfact= 0.05}, down = {mwfact=-0.05} },
    [awful.layout.suit.magnifier]   = { right = {mwfact= 0.05}, left = {mwfact=-0.05}, up ={mwfact= 0.05}, down = {mwfact=-0.05} },
    -- The other layouts cannot be resized using variables
}



-- {{{ Key bindings
globalkeys = gears.table.join(

    awful.key({ }, 'XF86AudioPlay', function() awful.spawn('playerctl play-pause') end, {description = 'play-pause', group = 'awesome'}),
    awful.key({ }, 'XF86AudioPause', function() awful.spawn('playerctl play-pause') end, {description = 'play-pause', group = 'awesome'}),
    awful.key({ }, 'XF86AudioNext', function() awful.spawn('playerctl next') end, {description = 'play next', group = 'awesome'}),
    awful.key({ }, 'XF86AudioPrev', function() awful.spawn('playerctl previous') end, {description = 'play prev', group = 'awesome'}),
    -- awful.key({ }, 'XF86Tools', function() awful.spawn('rofi -combi-modi window,drun -show combi -modi combi -theme ~/.config/rofi/purple.rasi -selected-row 1') end, {description = 'rofi', group = 'awesome'}),

    awful.key({ modkey }, 'o', function() awful.spawn.with_shell('pactl set-sink-mute @DEFAULT_SINK@ false') end, {description = 'unmute', group = 'awesome'}),
    awful.key({ modkey, 'Shift' }, 'o', function() awful.spawn.with_shell('pactl set-sink-mute @DEFAULT_SINK@ true') end, {description = 'mute', group = 'awesome'}),

    awful.key({ modkey }, 'i', function() awful.spawn.with_shell('pactl set-source-mute @DEFAULT_SOURCE@ false && notify-send "mic ON"') end, {description = 'mic on', group = 'awesome'}),
    awful.key({ modkey, 'Shift' }, 'i', function() awful.spawn.with_shell('pactl set-source-mute @DEFAULT_SOURCE@ true && notify-send "mic OFF"'); awesome.emit_signal("volume::change") end, {description = 'mic off', group = 'awesome'}),

    awful.key({ modkey, altkey }, 'g', function() awful.spawn.with_shell('~/bin/i3_ws_touch') end, {description = 'workspace gui', group = 'awesome'}),

    awful.key({ modkey, }, "BackSpace", function()     revelation({curr_tag_only=true}) end, {description = 'revelation', group = 'awesome'}),
    awful.key({ modkey, 'Shift' }, "BackSpace", revelation), -- a bit buggy with preserving window-tag location

    awful.key({modkey}, 'F1', hotkeys_popup.show_help, {description = 'Show help', group = 'awesome'}),
    awful.key(
      {modkey},
      'v',
    function()
      awful.spawn('copyq toggle')
    end,
    {description = 'Copyq', group = 'awesome'}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    --           {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "Escape",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey, 'Shift' }, "Escape",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),


  -- Tag browsing
  awful.key({modkey, 'Control'}, 'h', awful.tag.viewprev, {description = 'view previous', group = 'tag'}),
  awful.key({modkey, 'Control'}, 'l', awful.tag.viewnext, {description = 'view next', group = 'tag'}),
    awful.key({ modkey, altkey }, "h", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, altkey }, "l", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
  awful.key({modkey, altkey}, 'l', awful.screen.focus_bydirection("right"), {description = 'view next', group = 'tag'}),
  awful.key({altkey, 'Control'}, 'Up', awful.tag.viewprev, {description = 'view previous', group = 'tag'}),
  awful.key({altkey, 'Control'}, 'Down', awful.tag.viewnext, {description = 'view next', group = 'tag'}),
  awful.key({modkey}, 'Tab', awful.tag.history.restore, {description = 'go back', group = 'tag'}),
  -- awful.key({modkey}, 'b', awful.tag.history.restore, {description = 'go back', group = 'tag'}),

    -- By-direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    -- By-direction client swap
    awful.key({ modkey, 'Shift' }, "j",
        function()
            awful.client.swap.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey, 'Shift' }, "k",
        function()
            awful.client.swap.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey, 'Shift' }, "h",
        function()
            awful.client.swap.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey, 'Shift' }, "l",
        function()
            awful.client.swap.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

  awful.key(
    {modkey},
    'z',
    function()
      _G.toggle_quake()
    end,
    {description = 'dropdown application', group = 'launcher'}
  ),


  -- rofi
  awful.key(
    {altkey},
    'grave',
    function()
      awful.spawn.with_shell('rofi -show window -theme ~/.config/rofi/purple_windows.rasi -selected-row 1')
    end,
    {description = 'Rofi window', group = 'awesome'}
  ),

  awful.key(
    {modkey,altkey, 'Control'},
    'e',
    function()
        local count = screen.count()
        local currentscreen = awful.screen.focused()
        if count == 2 then
            if currentscreen.index == 2 then
                awful.spawn('rofi -show drun -theme ~/.config/rofi/purple.rasi')
            else
                awful.spawn('rofi -dpi 1 -show drun -theme ~/.config/rofi/purple.rasi')
            end
        else
            awful.spawn('rofi -show drun -theme ~/.config/rofi/purple.rasi')
        end
    end,
    {description = 'Show rofi', group = 'LCAG layer'}
  ),

  awful.key(
    {modkey,altkey, 'Control'},
    'period',
    function () awful.client.focus.byidx(  1)    end,
    {description = 'focus next', group = 'LCAG layer'}
  ),

  awful.key(
    {modkey,altkey, 'Control'},
    'comma',
    function () awful.client.focus.byidx( -1)    end,
    {description = 'focus prev', group = 'LCAG layer'}
  ),

  awful.key(
    {modkey,altkey, 'Shift', 'Control'},
    'comma',
    function () awful.client.swap.byidx( -1)    end,
    {description = 'swap prev', group = 'LCAG layer'}
  ),

  awful.key(
    {modkey,altkey, 'Shift', 'Control'},
    'period',
    function () awful.client.swap.byidx( 1)    end,
    {description = 'swap next', group = 'LCAG layer'}
  ),

  awful.key(
    {modkey,altkey, 'Control'},
    'z',
    function () awful.spawn('rofimoji -f ~/dotfiles/emojis.csv') end,
    {description = 'emoji', group = 'LCAG layer'}
  ),

  awful.key(
    {modkey,altkey,'Shift','Control'},
    'c',
    function () awful.spawn('qalculate-qt') end,
    {description = 'qalculate', group = 'launcher'}
  ),

  -- screenshot
  awful.key(
    {modkey,altkey,'Shift', 'Control'},
    'w',
    function () awful.spawn.with_shell('maim  -i "$(xdotool getactivewindow)" | xclip -selection clipboard -t image/png') end,
    {description = 'screenshot window', group = 'launcher'}
  ),
  awful.key(
    {modkey,altkey,'Shift', 'Control'},
    'a',
    function () awful.spawn.with_shell('maim -u | xclip -selection clipboard -t image/png') end,
    {description = 'screenshot all', group = 'launcher'}
  ),

  awful.key(
    {modkey,altkey,'Shift', 'Control'},
    'x',
    function () awful.spawn.with_shell('maim -s | xclip -selection clipboard -t image/png') end,
    {description = 'screenshot region', group = 'launcher'}
  ),

  awful.key(
    {modkey,altkey,'Shift', 'Control'},
    'z',
    function () awful.spawn.with_shell('~/bin/dm-maim') end,
    {description = 'screenshot utility', group = 'launcher'}
  ),

  awful.key(
    {modkey,altkey,'Shift', 'Control'},
    'm',
    function () awful.spawn('pavucontrol') end,
    {description = 'pavucontrol', group = 'launcher'}
  ),

  awful.key(
    {modkey,altkey, 'Control'},
    'x',
    function () awful.spawn('xkill') end,
    {description = 'xkill', group = 'LCAG layer'}
  ),

  awful.key(
    {modkey,altkey, 'Control'},
    '1',
    function () awful.layout.set(awful.layout.suit.tile) end,
    {description = 'tile layout', group = 'LCAG layer'}
  ),
  awful.key(
    {modkey,altkey, 'Control'},
    '2',
    function () awful.layout.set(awful.layout.suit.floating) end,
    {description = 'floating layout', group = 'LCAG layer'}
  ),
  awful.key(
    {modkey,altkey, 'Control'},
    '3',
    function () awful.layout.set(awful.layout.suit.fair) end,
    {description = 'fair layout', group = 'LCAG layer'}
  ),
  awful.key(
    {modkey,altkey, 'Control'},
    '4',
    function () awful.layout.set(awful.layout.suit.tile.top) end,
    {description = 'top layout', group = 'LCAG layer'}
  ),
  awful.key(
    {modkey,altkey, 'Control'},
    '5',
    function () awful.layout.set(awful.layout.suit.max) end,
    {description = 'max layout', group = 'LCAG layer'}
  ),

  awful.key(
    {modkey,altkey, 'Control'},
    'a',
    function () twothirds() end,
    {description = 'two thirds', group = 'LCAG layer'}
  ),
  awful.key(
    {modkey,altkey, 'Control'},
    's',
    function () twothirds(true) end,
    {description = 'two thirds right', group = 'LCAG layer'}
  ),
  awful.key(
    {modkey,altkey, 'Control'},
    'd',
    function () twothirds(false,30) end,
    {description = 'two thirds right', group = 'LCAG layer'}
  ),
  awful.key(
    {modkey,altkey, 'Control'},
    'bracketleft',
    function () onehalf(false) end,
    {description = 'one half', group = 'LCAG layer'}
  ),
  awful.key(
    {modkey,altkey, 'Control'},
    'bracketright',
    function () onehalf(true) end,
    {description = 'one half right', group = 'LCAG layer'}
  ),

    -- Layout manipulation
    awful.key({ modkey, altkey   }, "Escape", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, altkey, "Shift"   }, "Escape", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),


    -- modkey+Tab: cycle through all clients.
    awful.key({ altkey }, "Tab", function(c)
        cyclefocus.cycle({modifier="Alt_L",display_notifications = false})
    end),
    -- modkey+Shift+Tab: backwards
    awful.key({ altkey, "Shift" }, "Tab", function(c)
        cyclefocus.cycle({modifier="Alt_L"})
    end),

    -- Standard program
    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end, {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, altkey }, "Return", function () awful.spawn('firefox') end, {description = "firefox", group = "launcher"}),
    awful.key({ modkey, altkey, 'Shift', 'Control' }, "t", function () awful.spawn(terminal) end, {description = "open a terminal", group = "launcher"}),
    -- awful.key({ modkey, altkey, 'Shift', 'Control' }, "d", function ()
    --     local currentscreen = awful.screen.focused()
    --     local geometry = currentscreen.geometry
    --     awful.spawn('dolphin --qwindowgeometry 800x800+' .. geometry.x .. '+30')
    -- end, {description = "open dolphin", group = "launcher"}),
    awful.key({ modkey, altkey, 'Shift', 'Control' }, "d", function ()
        awful.spawn('nautilus')
    end, {description = "open nautilus", group = "launcher"}),
    awful.key({ modkey, altkey, 'Shift', 'Control' }, "f", function () awful.spawn('firefox') end, {description = "firefox", group = "launcher"}),
    -- awful.key({ modkey, altkey, 'Shift', 'Control' }, "s", function () awful.spawn.with_shell('exo-open ~/.local/share/applications/webcatalog-spotify.desktop') end, {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, altkey, 'Shift', 'Control' }, "s", function () awful.spawn.with_shell("kitty -e ncspot") end, {description = "open spotify", group = "launcher"}),
    awful.key({ modkey, altkey, 'Shift', 'Control' }, "p", function () awful.spawn("spotify") end, {description = "spotify", group = "launcher"}),
    awful.key({ modkey, altkey, 'Shift', 'Control' }, "n", function () awful.spawn('notion-app') end, {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, altkey, 'Shift', 'Control' }, "b", function () awful.spawn('alacritty -e btop') end, {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, altkey, 'Shift', 'Control' }, "r", function () awful.spawn("alacritty -e zsh -c \"zsh -ic 'ranger'\"") end, {description = "open a terminal", group = "launcher"}),


    -- power menu
    awful.key({ modkey, altkey, "Control" }, "6", function()
        awful.spawn.with_shell("blurlock")
    end,
              {description = "lock", group = "power"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "power"}),
    awful.key({ modkey, altkey, "Control" }, "7", awesome.restart,
              {description = "reload awesome", group = "power"}),

     awful.key({ modkey, altkey, "Shift", "Control" }, "bracketright", function()
          awful.spawn("notify-send 'restarting kmonad'")
          awful.spawn.with_shell("killall kmonad; sleep 0.5 && kmonad ~/.config/dell-xps.kbd")
      end, {description = "reload kmonad", group = "power"}),

    awful.key({ modkey, altkey, "Control" }, "8", function() awful.spawn.with_shell("~/bin/rofi-confirm.sh 'Quit?' 'killall awesome'") end,
              {description = "quit awesome", group = "power"}),

    awful.key({ modkey, altkey, "Control" }, "9",
        function()
            awful.spawn.with_shell("~/bin/rofi-confirm.sh 'Suspend?' 'blurlock && systemctl suspend'")
        end, {description = "suspend", group = "power"}),

    awful.key({ modkey, altkey, "Control" }, "0",
        function()
            awful.spawn.with_shell("~/bin/rofi-confirm.sh 'Hibernate?' 'blurlock && systemctl hibernate'")
        end, {description = "hibernate", group = "power"}),

    awful.key({ modkey, altkey, "Control" }, "minus", function()
            awful.spawn.with_shell("~/bin/rofi-confirm.sh 'Reboot?' 'blurlock && systemctl reboot'")
        end, {description = "reboot", group = "power"}),

    awful.key({ modkey, altkey, "Control" }, "equal", function()
            awful.spawn.with_shell("~/bin/rofi-confirm.sh 'Power off?' 'blurlock && systemctl poweroff'")
        end, {description = "poweroff", group = "power"}),

    awful.key({ modkey, altkey }, "period",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, altkey }, "n",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, altkey }, "m",     function () awful.client.incwfact( 0.05)          end,
              {description = "increase client width factor", group = "layout"}),
    awful.key({ modkey, altkey }, "comma",     function () awful.client.incwfact(-0.05)          end,
              {description = "decrease client width factor", group = "layout"}),
    awful.key({ modkey, 'Shift'   }, "m",     function () awful.tag.incnmaster(1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, 'Shift' }, "n",     function () awful.tag.incnmaster(-1, nil, true)    end,
              {description = "decrease number of master clients", group = "layout"}),
    awful.key({ modkey, 'Shift' }, "period",     function () awful.tag.incncol(1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, 'Shift'  }, "comma",     function () awful.tag.incncol(-1, nil, true) end,
              {description = "decreaase the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, altkey, "Control" }, "g",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

function resize(c, direction, del)

        local lay = awful.layout.get(c.screen)

        if c.floating or lay == awful.layout.suit.floating then
            c:emit_signal("request::geometry", "mouse.resize", r_ajust[direction](c, del))
        elseif layouts_all[lay] then
            local ret = layouts_all[lay][direction]
            if ret.mwfact then
                awful.tag.incmwfact(ret.mwfact)
            end
            if ret.wfact then
                awful.client.incwfact(ret.wfact, c)
            end
        end

end

function twothirds(right,gap,c)
    right = right or false
    c = c or client.focus
    gap = gap or 0 -- gap is added more in width
    local geom = c.screen.geometry

    if right then
        geom.x = geom.x + geom.width / 3 - 2
    end
    geom.x = geom.x + gap
    geom.width = geom.width * 2 / 3 - 1 - 6*gap
    geom.y = geom.y + dpi(22) + gap
    geom.height = geom.height - dpi(22) - 2 - 2*gap
    c:geometry(geom)
end

function onehalf(right,gap,c)
    right = right or false
    c = c or client.focus
    gap = gap or 0 -- gap is added more in width
    local geom = c.screen.geometry

    if right then
        geom.x = geom.x + geom.width / 2
    end
    geom.x = geom.x + gap
    geom.width = geom.width / 2 - 2 - 6*gap
    geom.y = geom.y + dpi(22) + gap
    geom.height = geom.height - dpi(22) - 2 - 2*gap
    c:geometry(geom)
end


function move(c, dir, delta)

    local geom = ({left={x=c:geometry().x-delta},right={x=c:geometry().x+delta},up={y=c:geometry().y-delta},down={y=c:geometry().y+delta}})[dir]

    c:geometry(geom)

    -- another option
    -- c:relative_move(20,20, 20, 20)
end


clientkeys = gears.table.join(

    awful.key({ modkey, altkey,  }, "Left",
        function (c) resize(c, "left", "100") end,
        {description = "expand left", group = "resize"}),
    awful.key({ modkey, altkey,  }, "Right",
        function (c) resize(c, "right", "100") end,
        {description = "expand right", group = "resize"}),
    awful.key({ modkey, altkey,  }, "Up",
        function (c) resize(c, "up", "100") end,
        {description = "expand up", group = "resize"}),
    awful.key({ modkey, altkey,  }, "Down",
        function (c) resize(c, "down", "100") end,
        {description = "expand Down", group = "resize"}),

    awful.key({ modkey, altkey, 'Shift'  }, "Left",
        function (c) resize(c, "left", "-100") end,
        {description = "shrink left", group = "resize"}),
    awful.key({ modkey, altkey, 'Shift'  }, "Right",
        function (c) resize(c, "right", "-100") end,
        {description = "shrink right", group = "resize"}),
    awful.key({ modkey, altkey, 'Shift'  }, "Up",
        function (c) resize(c, "up", "-100") end,
        {description = "shrink up", group = "resize"}),
    awful.key({ modkey, altkey, 'Shift'  }, "Down",
        function (c) resize(c, "down", "-100") end,
        {description = "shrink Down", group = "resize"}),

    awful.key({ modkey, 'Shift'  }, "Left",
        function (c) move(c, "left", "100") end,
        {description = "move left", group = "resize"}),
    awful.key({ modkey, 'Shift'  }, "Right",
        function (c) move(c, "right", "100") end,
        {description = "move right", group = "resize"}),
    awful.key({ modkey, 'Shift'  }, "Down",
        function (c) move(c, "down", "100") end,
        {description = "move down", group = "resize"}),
    awful.key({ modkey, 'Shift'  }, "Up",
        function (c) move(c, "up", "100") end,
        {description = "move up", group = "resize"}),



    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey }, "q",  function (c) c:kill() end,
              {description = "close", group = "client"}),

    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, altkey, 'Control' }, "o",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),

    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey, 'Shift' }, "slash", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey, altkey, 'Control' }, "slash", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),

    awful.key({ modkey, 'Shift' }, "semicolon",      function (c) c:move_to_screen(c.screen.index-1)               end,
              {description = "move to prev screen", group = "client"}),
    awful.key({ modkey, 'Shift' }, "apostrophe",      function (c) c:move_to_screen(c.screen.index+1)               end,
              {description = "move to next screen", group = "client"}),

    awful.key({ modkey, altkey, 'Control' }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, altkey, 'Control' }, "f",      function (c) c.floating = not c.floating            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey, altkey, 'Control' }, "y",      function (c) c.sticky = not c.sticky            end,
              {description = "toggle sticky", group = "client"}),

    -- minimize
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey, altkey, 'Control' }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),

    -- maximize
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, altkey, 'Control' }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),

    -- maximize vertically
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, altkey, 'Control' }, "comma",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),

    -- maximize horizontally
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),
    awful.key({ modkey, altkey, 'Control' }, "period",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

function get_tag(i)
    local count = screen.count()
    local currentscreen = awful.screen.focused()
    local newscreen
    local tag

    if count == 3 then
        if i < 6 then
            newscreen = screen[1]
            tag = newscreen.tags[i]
        elseif i == 6 then
            newscreen = screen[3]
            tag = newscreen.tags[1]
        elseif i == 7 then
            newscreen = screen[3]
            tag = newscreen.tags[2]
        elseif i == 8 then
            newscreen = screen[2]
            tag = newscreen.tags[1]
        elseif i == 9 then
            newscreen = screen[2]
            tag = newscreen.tags[2]
        elseif i == 10 then
            newscreen = screen[3]
            tag = newscreen.tags[3]
        elseif i == 11 then
            newscreen = screen[2]
            tag = newscreen.tags[3]
        elseif i == 12 then
            newscreen = screen[1]
            tag = newscreen.tags[6]
        end
    elseif count == 2 then
        if i < 6 then
            newscreen = screen[1]
            tag = newscreen.tags[i]
        elseif i == 6 then
            newscreen = screen[2]
            tag = newscreen.tags[1]
        elseif i == 7 then
            newscreen = screen[2]
            tag = newscreen.tags[2]
        elseif i == 8 then
            newscreen = screen[1]
            tag = newscreen.tags[6]
        elseif i == 9 then
            newscreen = screen[1]
            tag = newscreen.tags[7]
        end
    else
        newscreen = currentscreen
        tag = currentscreen.tags[i]
    end

    return tag, newscreen, currentscreen
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 12 do
    globalkeys = gears.table.join(globalkeys,

        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local tag, newscreen = get_tag(i)

                        if tag then
                           awful.screen.focus(newscreen)
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local tag = get_tag(i)

                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag, newscreen, currentscreen = get_tag(i)

                          if tag then
                              local c = client.focus
                              c:move_to_screen(newscreen)
                              c:move_to_tag(tag)
                              awful.screen.focus(currentscreen)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Bring client to tag.
        awful.key({ modkey, altkey }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag, newscreen = get_tag(i)

                          if tag then
                              local c = client.focus
                              c:move_to_screen(newscreen)
                              c:move_to_tag(tag)
                              awful.screen.focus(newscreen)
                              tag:view_only()
                          end
                     end
                  end,
                  {description = "bring focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then

                          local tag = get_tag(i)

                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

globalkeys = gears.table.join(globalkeys,
        -- local screen view
        awful.key({ modkey, altkey, 'Shift', 'Control' }, "1",
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[1]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view local tag 1", group = "tag"}),
        awful.key({ modkey, altkey, 'Shift', 'Control' }, "2",
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[2]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view local tag 1", group = "tag"}),
        awful.key({ modkey, altkey, 'Shift', 'Control' }, "3",
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[3]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view local tag 1", group = "tag"})

        )




clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     floating = false,
                     maximized = false,
                     above = false,
                     below = false,
                     ontop = false,
                     sticky = false,
                     maximized_horizontal = false,
                     maximized_vertical = false
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pavucontrol",
          "pinentry",
        },
        class = {
          "Arandr",
          "qalculate-qt",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },
    { rule_any = {class = {'Terminator'}},
      properties = {skip_decoration = true, titlebars_enabled = false}
    },
    { rule_any = {class = {'Spotify'}},
      properties = {}, callback = function(c)
          local tag, newscreen, currentscreen = get_tag(6)


          if tag then
              c:move_to_screen(newscreen)
              c:move_to_tag(tag)
              awful.screen.focus(currentscreen)
              twothirds(false,30,c)
              c.minimized = true
          end
     end
    },
    { rule_any = {class = {'kitty'}},
      properties = {}, callback = function(c)
          local tag, newscreen, currentscreen = get_tag(6)


          if tag then
              c:move_to_screen(newscreen)
              c:move_to_tag(tag)
              awful.screen.focus(currentscreen)
              onehalf(false,30,c)
          end
     end
    },
    { rule_any = {class = {'copyq','qalculate-qt'}},
      properties = {}, callback = function(c)
         c:geometry({width = 800, height = 500})
         awful.placement.centered(c,nil)
     end
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
-- client.connect_signal("manage", function (c)
--     -- Set the windows at the slave,
--     -- i.e. put it at the end of others instead of setting it master.
--     -- if not awesome.startup then awful.client.setslave(c) end
--     if not c.fullscreen then
--         c.shape = function(cr, w, h)
--           gears.shape.rounded_rect(cr, w, h, 8)
--         end
--     end

--     if awesome.startup
--       and not c.size_hints.user_position
--       and not c.size_hints.program_position then
--         -- Prevent clients from being unreachable after screen count changes.
--         awful.placement.no_offscreen(c)
--     end
-- end)

-- Double click titlebar
function double_click_event_handler(double_click_event)
    if double_click_timer then
        double_click_timer:stop()
        double_click_timer = nil
        return true
    end

    double_click_timer = gears.timer.start_new(0.40, function()
        double_click_timer = nil
        return false
    end)
end


-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})

            -- WILL EXECUTE THIS ON DOUBLE CLICK
                if double_click_event_handler() then
                    c.maximized = not c.maximized
                    c:raise()
                else
                    awful.mouse.client.move(c)
                end
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    local titlebar = awful.titlebar(c, {
          size = dpi(25)
       })

    titlebar : setup {
        { -- Left
            layout  = wibox.layout.fixed.horizontal,
            wibox.layout.margin(awful.titlebar.widget.iconwidget(c), dpi(5), dpi(0),dpi(1),dpi(0)),
            buttons = buttons,
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            wibox.layout.margin(awful.titlebar.widget.minimizebutton(c), dpi(5), dpi(0),dpi(3),dpi(3)),
            wibox.layout.margin(awful.titlebar.widget.maximizedbutton(c), dpi(5), dpi(0),dpi(3),dpi(3)),
            wibox.layout.margin(awful.titlebar.widget.floatingbutton (c), dpi(5), dpi(0),dpi(3),dpi(3)),
            wibox.layout.margin(awful.titlebar.widget.stickybutton   (c), dpi(5), dpi(0),dpi(3),dpi(3)),
            wibox.layout.margin(awful.titlebar.widget.ontopbutton    (c), dpi(5), dpi(0),dpi(3),dpi(3)),
            wibox.layout.margin(awful.titlebar.widget.closebutton    (c), dpi(5), dpi(0),dpi(3),dpi(3)),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse. (buggy with some apps, raising even if false)
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- Focus urgent clients automatically
client.connect_signal("property::urgent", function(c)
    c.minimized = false
    c:jump_to()
end)


-- Spotify misbehaving bug (cant solve it)
-- awful.ewmh.add_activate_filter(function(c)
--     if c.class == "Spotify" then
--         awful.spawn.with_shell('notify-send "cancel ' .. c.name .. '"')
--         return false end
-- end, "ewmh")

-- client.connect_signal("focus", function(c)
--     if c.class == "Spotify" then
--         awful.spawn.with_shell('notify-send "hello ' .. c.name .. '"')

--         awful.client.focus.byidx(1)
--         if awful.client.ismarked() then
--             awful.screen.focus_relative(-1)
--             awful.client.getmarked()
--         end
--         if client.focus then
--             client.focus:raise()
--         end
--         awful.client.togglemarked()

--         -- awful.client.focus.history.previous()
--         -- awful.screen.focus(screen[1])
--         -- cyclefocus.cycle({modifier="Super_L"})
--         return false
--     end
--     return false
-- end)


-- Store geometries when switching layouts
local client_geos = {}

function client_or_tag_floating(c)
    if c.maximized then
        return false
    end

    if c.floating then
        return true
    end

    local tag_floating = false
    if c.first_tag then
        local tag_layout_name = awful.layout.getname(c.first_tag.layout)
        tag_floating = tag_layout_name == "floating"
    end

    return tag_floating
end

function should_show_titlebars(c)
    return not c.requests_no_titlebar and client_or_tag_floating(c)
end

function apply_geometry(c)
    if client_or_tag_floating(c) then
        c:geometry(client_geos[c.window])
    end
end

function save_geometry(c)
    if client_or_tag_floating(c) then
        client_geos[c.window] = c:geometry()
    end
end

tag.connect_signal("property::layout", function(t)
    for _, c in ipairs(t:clients()) do
        if client_or_tag_floating(c) then
            apply_geometry(c)
        end
        c:emit_signal("request::titlebars")
    end
end)

client.connect_signal("property::floating", function(c)
    -- if should_show_titlebars(c) then
    --     awful.titlebar.show(c)
    -- else
    --     awful.titlebar.hide(c)
    -- end
    apply_geometry(c)
end)

client.connect_signal("property::geometry", save_geometry)
client.connect_signal("manage", save_geometry)
client.connect_signal("unmanage", function(c) client_geos[c.window] = nil end)
