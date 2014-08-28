# Description

This is a vim plugin for syncing clipboard content when it's running in a ssh session.

# Requirements

* Only for Mac OS X. If you are using Linux, `ssh -X hostname` should work perfectly. If you are using windows, I have no idea what to do with it, therefore cannot help.
* Python3 should be installed


# Install

* A plugin manager is recommended, e.g. Vundle. If you have vundle installed:
    * Add one line in your .vimrc: `Plugin 'kindlychung/sysclip'`, and save
    * In vim, execute `:PluginInstall` command

* You need to install a plist file for forwarding text to pbcopy, for this purpose do as instructed below:
    * `cd ~/.vim/bundle/sysclip`
    * `chmod u+x install.py`
    * `./install.py`

* Next configure ssh for port forwarding, add the following content in your `.ssh/config` (if non-existent, create it), replace `hostname` with the hostname of your ssh server :


    Host hostname
      RemoteForward 2224 localhost:2224


# Change log

# Todo

* Nothing at the moment
