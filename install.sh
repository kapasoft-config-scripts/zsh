#! /usr/bin/env sh

if [ -e ~/.zshrc ] 
then
	echo "You have an existing ~/.zshrc file, please remove it and rerun the install to create a new version from zshrc_template"
	exit 1
else 
	
	SCRIPTDIR=$(cd `dirname $0` && pwd)
	INSTALL_TO=~/.zshrc
	
cat <<Endmarker > $INSTALL_TO
export ZSHDIR=$SCRIPTDIR

export HOSTNAME=\$(hostname)

source \$ZSHDIR/zshrc_general

if [ -e \$ZSHDIR/$HOSTNAME/zshrc ]
then
	echo "Loading zshrc for host $HOSTNAME"
	source \$ZSHDIR/\$HOSTNAME/zshrc
else 
	echo "Create a file at \$ZSHDIR/\$HOSTNAME/zshrc to hold any host specific settings"
fi

source \$ZSHDIR/zshrc_compinstall
source \$ZSHDIR/zshrc_prompt
Endmarker

	echo "Done creating ~/.zshrc file that expects zsh script in $SCRIPTDIR"
fi
