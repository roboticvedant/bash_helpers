# Credit: https://gitlab.msu.edu/av/av_24/-/blob/main/Setup/Control_Workstations.md
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

mkvenv() {
  if [ $# -eq 0 ]
  then
    echo "Error: Please provide a name for the virtual environment."
    echo "Usage: mkvenv <venv_name> [--system-site-packages]"
  else
    VENV_NAME=$1
    VENV_PATH=$VENV_FOLDER/$VENV_NAME
    if [ -d "$VENV_PATH" ]; then
      echo "Error: Virtual environment '$VENV_NAME' already exists in $VENV_FOLDER."
    else
      echo "Creating virtual environment: $VENV_NAME in $VENV_FOLDER..."
      if [ "$2" == "--system-site-packages" ]; then
        python -m venv $VENV_PATH --system-site-packages
      else
        python -m venv $VENV_PATH
      fi
      echo "Virtual environment '$VENV_NAME' created successfully."
    fi
  fi
}
