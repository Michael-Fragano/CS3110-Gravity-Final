# Installation instructions for Spring 2022 CS3110 Final Project: Gravity Simulator

Here are instructions for installing and running our CS3110 Final Project, 
a Gravity Simulator on Windows using WSL.

These instructions assume that WSL and OCaml were installed using the 
instructions provided in the CS3110 textbook. These can be found at

https://cs3110.github.io/textbook/chapters/preface/install.html


Along with the above installation, we will need to install some extra libraries
and applications to run graphics through WSL. 



## Install X-server (VcXsrv)

In Windows, you will need to install an X-server for WSL to communicate with
and show graphics through, as there is not a native way to show graphics through
WSL alone.

We will use VcXsrv as our X-server. Visit 

https://sourceforge.net/projects/vcxsrv/ 

and click the green "Download" button. After a couple seconds, the installer 
for VcXsrv should begin to download. 

Open the installer. Windows should ask if the installer can make changes to your
device. Say yes, and then proceed through the default installation of VcXsrv.
(It should just be selecting "Next" and then "Install").

After VcXsrv has been installed, you should see a new desktop icon called
XLaunch. 



## Run X-server (XLaunch)

When you want to run the X-server (you have to have the server running before
you open WSL), open XLaunch.

The first screen should have "Multiple windows" selected, and "Display number"
set to -1. Select "Next".

The next screen should have "Start no client" selected. Select "Next".

On the third screen, make sure all checkboxes are checked, and select "Next".

From the final screen, you can save the configuration we just made, and run it
instead of repeating this process, but from this screen, press "Finish" to start
the X-server.

You should see an X-server icon appear in the System Tray (lower left on the
default Windows taskbar). To stop the X-server, right click the icon, and select
"Exit...". After exiting, you would need to repeat these steps or run the saved
configuration to re-run the X-server.



## Connecting WSL to X-server

Whenever you open a new WSL terminal (the X-server must be running), you will
need to set the DISPLAY variable in WSL to use the X-server.

Run the following command to set the DISPLAY variable in WSL

>`export DISPLAY=$(echo $(grep nameserver /etc/resolv.conf | sed 's/nameserver //'):0.0)`



## Package Installation in WSL

The main package needed to be installed is the OCaml graphics library.

#### Step 1: install pkg-config

>`sudo apt-get update -y`
>
>`sudo apt-get install -y pkg-config`

Run the above commands in WSL to install pkg-config.

#### Step 2: install graphics library

You can install the library in an opam switch of your choice, as long as the
switch is setup as instructed in the CS3110 Ocaml installation instructions 
mentioned previously.

>`opam update`
>
>`opam upgrade`
>
>`opam install graphics`

Run the above commands in WSL to install the graphics library.



## SETTING UP OUR CODE

Our submission will be a zip file you can bring into WSL and unzip into a folder
of your choice. There are a number of subfolders, notably a data folder, which
has a number of preset systems to show off the functionality of our project. 

In the root folder there is a makefile, which lists a number of make commands
you can use to build, test, and run our program. The individual commands are
documented in the make file, but some important ones are:

>`make build`: builds and compiles the program
>
>`make run`: executes the main program (run `make build` first)



## RUNNING OUR CODE

After running `make run`, the program will prompt you to enter a preset name. the
json files found in the data subfolder (except `system_schema.json`) are the
choices for presets, so the full list can be found there, as well as here

>`binary`
>
>`triple`
>
>`comet`
>
>`moon`

Once the simulation is running the following buttons have these effects:

Space Bar: Toggle through different views -your current focus will be typed in 
           the bottom left corner.
Click: play/pause the simulation
`<`: Slow down the simulation
`>`: Speed up the simulation
`w`: Zoom out
`s`: Zoom in 
`q`: Quit the simulation


Press the space bar to toggle through views, `<` and `>` to slow down or speed up the simulation, 

To create a system from scratch, type `new`. You will then be prompted to input 
how many seconds you want the steps of the simulation to be (smaller is more 
accurate, we find 0.001 works well), and and what you want to set the 
gravitational constant as (1000 usually works well). After this a window will 
open. To create bodies, click once to set a postion, click again to set 
radius/mass, then once more to set velocity. When setting radius, press the 
space bar to skip velocity, setting it to the default of zero. 

If you want to delete a body, place the mouse over the body you wish to delete,
and press `d`

Once you have created your bodies, press `k` to run a simulation. 

If you want to save your system to run later, press `s`, and you will be 
prompted to give a name to the system. Once you give this, it will be saved as 
a json file. Just use the name to run your system whenever you like. 

Press `q` to quit the editor. 

When you run a preset system, a window will pop up with the system running.
To close the system, simply use the X at the top of the window. The prompt will
again ask you to run a preset, so you can run another if you choose to, or you
can exit the program by typing `Q`.