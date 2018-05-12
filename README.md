# startupscript

This is just a script in progress I use to start my dev environment. Only tested on Ubuntu 16.04

I have it bound to an alias called <devstart> which takes a few parameters.

* -d | --default, will start the default line up. In my case, it's right now hard coded to swap to workspace 2, use my left screen, and place 4 terminals nicely next to each other. There are some functions for automatic funcionalities.
Takes no additional params.

* -t | --terminals, will give you a bunch of terminals of your choice (followed by an int between 1-9). The plan is to evenly distribute them accross your workspace.
Takes additional params.

* -s | --screen, is an additional param which you can select which screen to operate on. Starts from top left of your screen organization.

* -w | --workspace, is an additional param which you can select which workspace to operate on. Starts from top left of your most top left screen.
