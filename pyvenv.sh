# Credit: https://gitlab.msu.edu/av/av_24/-/blob/main/Setup/Control_Workstations.md?ref_type=heads
# Initialize my Python virtual environment helper functions
VENV_FOLDER=$HOME/venvs          # Change this as appropriate

# Command to activate selected virtual environment:
act() {
  if [ $# -eq 0 ] 
  then
    ls $VENV_FOLDER                       # If no arguments, display all virtual environments
  else
    cmd="source $VENV_FOLDER/${1}/bin/activate"   # Activate selected virtual environment
    echo $cmd
    eval $cmd
  fi
}

# The following will enable ROS nodes to access packages installed in a
# virtual environment.  Activating a virtual environment with the act 
# command is insufficient for ROS Python to use it.  Instead use: addpypath
addpypath() {
  if [ $# -eq 0 ] 
  then
    ls $VENV_FOLDER                       # If no arguments, display all virtual environments
  else
    pyversion=`/usr/bin/ls $VENV_FOLDER/${1}/lib`
    newpath=$VENV_FOLDER/${1}/lib/$pyversion/site-packages
    echo 'Appending $PYTHONPATH:'"$newpath"
    cmd="export PYTHONPATH=$PYTHONPATH:$newpath"   # Activate selected virtual environment
    eval $cmd
  fi
}
