{
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  xdg.configFile."awesome/rc.lua".text = ''
    -- If LuaRocks is installed, make sure that packages installed through it are
    -- found (e.g. lgi). If LuaRocks is not installed, do nothing.
    pcall(require, "luarocks.loader")

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
    -- Enable hotkeys help widget for VIM and other apps
    -- when client with a matching name is opened:
    require("awful.hotkeys_popup.keys")

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
    beautiful.init({
      font          = "JetBrainsMonoNerdFont SemiBold 10",

      bg_normal     = "#${colors.base00}",
      bg_focus      = "#${colors.base00}",
      bg_urgent     = "#${colors.base00}",
      bg_minimize   = "#${colors.base01}",
      bg_systray    = "#${colors.base00}",

      fg_normal     = "#${colors.base04}",
      fg_focus      = "#${colors.base05}",
      fg_urgent     = "#${colors.base05}",
      fg_minimize   = "#${colors.base05}",

      useless_gap         = 8,
      border_width        = 2,
      border_color_normal = "#${colors.base03}",
      border_color_active = "#${colors.base0E}",
      border_color_marked = "#${colors.base06}",
    })

    -- This is used later as the default terminal and editor to run.
    terminal = "kitty"
    editor = os.getenv("EDITOR") or "nvim"
    editor_cmd = terminal .. " " .. editor

    -- Default modkey.
    -- Usually, Mod4 is the key with a logo between Control and Alt.
    -- If you do not like this or do not have such a key,
    -- I suggest you to remap Mod4 to another key using xmodmap or other tools.
    -- However, you can use another modifier like Mod1, but it may interact with others.
    modkey = "Mod4"

    -- Table of layouts to cover with awful.layout.inc, order matters.
    awful.layout.layouts = {
      awful.layout.suit.fair,
      awful.layout.suit.fair.horizontal,
      awful.layout.suit.floating,

      -- awful.layout.suit.spiral,
      awful.layout.suit.spiral.dwindle,
      awful.layout.suit.max,
      -- awful.layout.suit.max.fullscreen,
      -- awful.layout.suit.magnifier,

      awful.layout.suit.tile,
      awful.layout.suit.tile.bottom,
      -- awful.layout.suit.tile.left,
      -- awful.layout.suit.tile.top,
      -- awful.layout.suit.corner.nw,
      -- awful.layout.suit.corner.ne,
      -- awful.layout.suit.corner.sw,
      -- awful.layout.suit.corner.se,
    }
    -- }}}

    -- {{{ Menu
    -- Create a launcher widget and a main menu
    myawesomemenu = {
       { "Show hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
       { "Show manual", terminal .. " -e man awesome" },
       { "Restart", awesome.restart },
       { "Quit", function() awesome.quit() end },
    }

    mymainmenu = awful.menu({ items = { { "AwesomeWM", myawesomemenu, beautiful.awesome_icon },
                                        { "Start terminal", terminal }
                                      }
                            })

    mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                         menu = mymainmenu })

    -- Menubar configuration
    menubar.utils.terminal = terminal -- Set the terminal for applications that require it
    -- }}}

    -- Keyboard map indicator and switcher
    mykeyboardlayout = awful.widget.keyboardlayout()

    -- {{{ Wibar
    -- Create a textclock widget
    mytextclock = wibox.widget.textclock()

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
                        awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                        awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
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
                         awful.button({ }, 4, function ()
                                                  awful.client.focus.byidx(1)
                                              end),
                         awful.button({ }, 5, function ()
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
        -- Wallpaper
        set_wallpaper(s)

        -- Each screen has its own tag table.
        awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

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
        s.mytasklist = awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons
        }

        -- Create the wibox
        s.mywibox = awful.wibar({ position = "top", screen = s })

        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                mykeyboardlayout,
                wibox.widget.systray(),
                mytextclock,
                s.mylayoutbox,
            },
        }
    end)
    -- }}}

    -- {{{ Mouse bindings
    root.buttons(gears.table.join(
        awful.button({ }, 3, function () mymainmenu:toggle() end),
        awful.button({ }, 4, awful.tag.viewnext),
        awful.button({ }, 5, awful.tag.viewprev)
    ))
    -- }}}

    -- {{{ Key bindings
    globalkeys = gears.table.join(
        awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
                  {description="Show hotkeys", group="AwesomeWM"}),
        awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
                  {description = "View previous tag", group = "Tags"}),
        awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
                  {description = "View next tag", group = "Tags"}),
        awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
                  {description = "Go back", group = "Tags"}),

        awful.key({ modkey,           }, "j",
            function ()
                awful.client.focus.byidx( 1)
            end,
            {description = "Focus next client", group = "Clients"}
        ),
        awful.key({ modkey,           }, "k",
            function ()
                awful.client.focus.byidx(-1)
            end,
            {description = "Focus previous client", group = "Clients"}
        ),
        awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
                  {description = "Show main menu", group = "AwesomeWM"}),

        -- Layout manipulation
        awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
                  {description = "Swap with next client", group = "Clients"}),
        awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
                  {description = "Swap with previous client", group = "Clients"}),
        awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
                  {description = "Focus the next screen", group = "Screen"}),
        awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
                  {description = "Focus the previous screen", group = "Screen"}),
        awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
                  {description = "Jump to urgent client", group = "Clients"}),
        awful.key({ modkey,           }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
            {description = "Go back", group = "Clients"}),

        -- Standard program
        awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
                  {description = "Start terminal", group = "Launcher"}),
        awful.key({ modkey, "Shift" }, "r", awesome.restart,
                  {description = "Reload awesome", group = "AwesomeWM"}),
        awful.key({ modkey, "Control", "Shift"   }, "e", awesome.quit,
                  {description = "quit awesome", group = "AwesomeWM"}),

        awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
                  {description = "Increase master width", group = "Layout"}),
        awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
                  {description = "decrease master width", group = "Layout"}),
        awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
                  {description = "Increase the number of master clients", group = "Layout"}),
        awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
                  {description = "Decrease the number of master clients", group = "Layout"}),
        awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
                  {description = "Increase the number of columns", group = "Layout"}),
        awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
                  {description = "Decrease the number of columns", group = "Layout"}),
        awful.key({ modkey,  "Shift"  }, "space", function () awful.layout.inc( 1)                end,
                  {description = "Cycle layouts", group = "Layout"}),

        awful.key({ modkey, "Control" }, "n",
                  function ()
                      local c = awful.client.restore()
                      -- Focus restored client
                      if c then
                        c:emit_signal(
                            "request::activate", "key.unminimize", {raise = true}
                        )
                      end
                  end,
                  {description = "Restore minimized", group = "Clients"}),

        -- Prompt
        awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
                  {description = "Run prompt", group = "Launcher"}),

        awful.key({ modkey }, "x",
                  function ()
                      awful.prompt.run {
                        prompt       = "Run Lua code: ",
                        textbox      = awful.screen.focused().mypromptbox.widget,
                        exe_callback = awful.util.eval,
                        history_path = awful.util.get_cache_dir() .. "/history_eval"
                      }
                  end,
                  {description = "Lua prompt", group = "AwesomeWM"}),
        -- Menubar
        awful.key({ modkey }, "p", function() menubar.show() end,
                  {description = "Show menubar", group = "Launcher"})
    )

    clientkeys = gears.table.join(
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "Toggle fullscreen", group = "Clients"}),
        awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
                  {description = "close", group = "Clients"}),
        awful.key({ modkey,           }, "t",  awful.client.floating.toggle                     ,
                  {description = "Toggle floating", group = "Clients"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                  {description = "Move to master", group = "Clients"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                  {description = "Move to screen", group = "Clients"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                  {description = "Toggle keep-on-top", group = "Clients"}),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "Minimize", group = "Clients"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(Un)maximize", group = "Clients"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(Un)maximize vertically", group = "Clients"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(Un)maximize horizontally", group = "Clients"})
    )

    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it work on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, 9 do
        globalkeys = gears.table.join(globalkeys,
            -- View tag only.
            awful.key({ modkey }, "#" .. i + 9,
                      function ()
                            local screen = awful.screen.focused()
                            local tag = screen.tags[i]
                            if tag then
                               tag:view_only()
                            end
                      end,
                      {description = "View tag #"..i, group = "Tags"}),
            -- Toggle tag display.
            awful.key({ modkey, "Control" }, "#" .. i + 9,
                      function ()
                          local screen = awful.screen.focused()
                          local tag = screen.tags[i]
                          if tag then
                             awful.tag.viewtoggle(tag)
                          end
                      end,
                      {description = "Toggle tag #" .. i, group = "Tags"}),
            -- Move client to tag.
            awful.key({ modkey, "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus then
                              local tag = client.focus.screen.tags[i]
                              if tag then
                                  client.focus:move_to_tag(tag)
                              end
                         end
                      end,
                      {description = "Move focused client to tag #"..i, group = "Tags"}),
            -- Toggle tag on focused client.
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus then
                              local tag = client.focus.screen.tags[i]
                              if tag then
                                  client.focus:toggle_tag(tag)
                              end
                          end
                      end,
                      {description = "Toggle focused client on tag #" .. i, group = "Tags"})
        )
    end

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
                         placement = awful.placement.no_overlap+awful.placement.no_offscreen
         }
        },

        -- Floating clients.
        { rule_any = {
            instance = {
              "DTA",  -- Firefox addon DownThemAll.
              "copyq",  -- Includes session name in class.
              "pinentry",
            },
            class = {
              "Arandr",
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

        -- Set Firefox to always map on the tag named "2" on screen 1.
        -- { rule = { class = "Firefox" },
        --   properties = { screen = 1, tag = "2" } },
    }
    -- }}}

    -- {{{ Signals
    -- Signal function to execute when a new client appears.
    client.connect_signal("manage", function (c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup
          and not c.size_hints.user_position
          and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end)



    -- INFO: Titlebars & hacky double borders
    client.connect_signal("request::titlebars", function(c)
      -- buttons for the titlebar
      local buttons = gears.table.join(
        awful.button({ }, 1, function()
          c:emit_signal("request::activate", "titlebar", {raise = true})
          awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
          c:emit_signal("request::activate", "titlebar", {raise = true})
          awful.mouse.client.resize(c)
        end)
      )

      -- INFO: Top titlebar
      local top_titlebar = awful.titlebar(c, {
        size            = beautiful.border_width or 2,
        enable_tooltip  = false,
        position        = 'top',
        bg              = c.border_color
      })
      top_titlebar:setup {
        {
          {
            bg     = c.border_color or '#FFFFFF',
            widget = wibox.container.background
          },
          top    = (beautiful.border_width * 2) or 1,
          left   = (beautiful.border_width * 2) or 1,
          right  = (beautiful.border_width * 2) or 1,
          widget = wibox.container.margin
        },
        bg     = beautiful.border_outer or '#000000',
        widget = wibox.container.background
      }

      -- INFO: Bottom titlebar (bottom `border`)
      local bottom_titlebar = awful.titlebar(c, {
        size            = beautiful.border_width or 2,
        enable_tooltip  = false,
        position        = 'bottom',
        bg              = c.border_color
      })
      bottom_titlebar:setup {
        {
          {
            bg     = c.border_color or '#FFFFFF',
            widget = wibox.container.background
          },
          bottom = (beautiful.border_width * 2) or 1,
          left   = (beautiful.border_width * 2) or 1,
          right  = (beautiful.border_width * 2) or 1,
          widget = wibox.container.margin
        },
        bg     = beautiful.border_outer or '#000000',
        widget = wibox.container.background
      }

      -- INFO: Left titlebar (left `border`)
      local left_titlebar = awful.titlebar(c, {
          size            = beautiful.border_width or 2,
          enable_tooltip  = false,
          position        = 'left',
          bg              = c.border_color
      })
      left_titlebar:setup {
        {
          {
            bg     = c.border_color or '#FFFFFF',
            widget = wibox.container.background
          },
          left   = (beautiful.border_width * 2) or 1,
          widget = wibox.container.margin
        },
        bg     = beautiful.border_outer or '#000000',
        widget = wibox.container.background
      }

      -- INFO: Right titlebar (right `border`)
      local right_titlebar = awful.titlebar(c, {
        size            = beautiful.border_width or 2,
        enable_tooltip  = false,
        position        = 'right',
        bg              = c.border_color
      })
      right_titlebar:setup {
        {
          {
            bg     = c.border_color or '#FFFFFF',
            widget = wibox.container.background
          },
          right  = (beautiful.border_width * 2) or 1,
          widget = wibox.container.margin
        },
        bg     = beautiful.border_outer or '#000000',
        widget = wibox.container.background
      }
      --[[ awful.titlebar(c) : setup {
        { -- Left
          awful.titlebar.widget.iconwidget(c),
          buttons = buttons,
          layout  = wibox.layout.fixed.horizontal
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
          awful.titlebar.widget.floatingbutton (c),
          awful.titlebar.widget.maximizedbutton(c),
          awful.titlebar.widget.stickybutton   (c),
          awful.titlebar.widget.ontopbutton    (c),
          awful.titlebar.widget.closebutton    (c),
          layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
      }
      ]]
    end)

    -- Enable sloppy focus, so that focus follows mouse.
    client.connect_signal("mouse::enter", function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end)

    -- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
    -- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
    -- }}}
  '';
}