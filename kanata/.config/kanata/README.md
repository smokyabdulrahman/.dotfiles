Then, copy this file to your LaunchDaemon folder.

sudo cp ./com.example.kanata.plist /Library/LaunchDaemons/
Once copied over, you can then load it using sudo

sudo launchctl load /Library/LaunchDaemons/com.example.kanata.plist
sudo launchctl start com.example.kanata
You might have to specifically allow the executable kanata the permission for input monitoring (if you didn't get this GUI popup guiding you to do so already). To do this go to Settings > Privacy & Security > Input Monitoring, and click the + icon, navigate to the place your kanata executable is (should match the same path in the *.plist above, ~/.cargo/bin/kanata), and add it.

Now, kanata should be running whenever your macbook starts up!

To help with debugging any potential issues, you can look in the error log specified by the *.plist:

sudo tail -f /Library/Logs/Kanata/kanata.err.log
If you use multiple keyboards, you may want to limit this to only showing up on your MacBooks internal keyboard.