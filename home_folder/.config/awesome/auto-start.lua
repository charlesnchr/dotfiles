local awful = require('awful')

local function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(' ')
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.with_shell(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', findme, cmd))
end

run_on_start_up = {
    'picom -b --experimental-backends',
    'nm-applet', -- wifi
    'kmix --keepvisibility', -- shows an audiocontrol applet in systray when installed.
    --'blueberry-tray', -- Bluetooth tray icon
    'numlockx on', -- enable numlock
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1', -- credential manager
    'xfce4-power-manager', -- Power manager
    -- Add applications that need to be killed between reloads
    -- to avoid multipled instances, inside the awspawn script
    '~/.config/awesome/awspawn', -- Spawn "dirty" apps that can linger between sessions
    'copyq',
    'unclutter',
    'spotify',
}

for _, app in ipairs(run_on_start_up) do
  run_once(app)
end

-- Run always
awful.spawn.with_shell("~/.config/awesome/auto-start-always.sh")
