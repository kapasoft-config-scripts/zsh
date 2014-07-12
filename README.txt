To use these zshrc files, just run the install.sh script.  

	./install.sh
	
This will create a new ~/.zshrc file that will automatically load up the zshrc files in this directory.

It will also look for a host specific file on startup where you can put settings that are only for that host.  If there is no host specific file found, it will echo out the path of where you can put a file for it to get loaded.

I use this to hold things like cd aliases for directories that are machine specific, commands with hostnames in them, etc.

