#!/bin/bash

# Check if PulseAudio is installed
echo -e "\e[1;36mLooking for PulseAudio\e[0m"
if ! type pulseaudio >/dev/null 2>&1; then
    clear
    echo -e "\e[1;31mPulseAudio not found\e[0m"
    echo -e "\e[1;32mInstalling PulseAudio\e[0m"
    pkg install pulseaudio
else
    clear
    echo -e "\e[1;33mFound PulseAudio\e[0m"
fi

# Configure default.pa
default_pa_path="$PREFIX/etc/pulse/default.pa"
default_pa_temp="$HOME/default.pa.temp"

echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> "$default_pa_temp"
cat "$default_pa_path" >> "$default_pa_temp"
mv "$default_pa_temp" "$default_pa_path"

# Edit daemon.conf
daemon_conf_path="$PREFIX/etc/pulse/daemon.conf"
sed -i 's/^exit-idle-time = 20/exit-idle-time = -1/' "$daemon_conf_path"

# Create and edit sound file
cd ~
echo "pulseaudio --start --load=\"module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1\" --exit-idle-time=-1" > sound

# Save and make sound file executable
chmod +x sound

# Run sound script
./sound

# Done
clear
echo -e "\e[1;32mSound has been fixed.\e[0m"
echo -e "\e[1;32mLogin to your distro and run this cmd ⬇\e[0m"
echo -e "\e[1;36mexport PULSE_SERVER=127.0.0.1\e[0m"
echo ""
echo -e "\e[1;30m© \x41n\x6bs\x69\x6f\e[0m"
