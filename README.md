# Environment

This repo uses the basic nvim version is v0.7.2.
All lua scripts are only developed and tested under Ubuntu20.04.

# How to install plugins for NeoVIM?

After nvim version 0.5, we are recommended to use lua packer.nvim as plugins manager.

References:
https://github.com/wbthomason/packer.nvim

# How to debug the lua script by unit tests?

Sorry, IDK! There is an only way for me to test the scripts run if what I want: `ln -s /home/<usr-name>/toyide /home/<usr-name>/.config/nvim`. Then it is only to use the lua `print()` function to output variables information.
