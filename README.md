# shell-script-for-updating-ubuntu

This script is used to automatically update linux using apt and torvalds linux mirrors if there is an internet connection. If the connectivity check fails 5 times in a row the program ends. Only one instance can run at a time.

After cloning this repository you can use this script as follows:

```

chmod u=rwx updater.sh
./updater.sh

```
