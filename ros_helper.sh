#!/bin/bash
# Function to set the current directory as ROS_WORKSPACE
function my_ws() {
    export ROS_WORKSPACE=$(pwd)
    echo "ROS_WORKSPACE set to: $ROS_WORKSPACE"
}

# Function to clean, build, and source the workspace
function clean_build_source_my_ws() {
    if [ -z "$ROS_WORKSPACE" ]; then
        echo "ROS_WORKSPACE is not set. Use 'my_ws' to set it first."
        return 1
    fi

    echo "Cleaning workspace: $ROS_WORKSPACE"
    rm -rf "$ROS_WORKSPACE/build" "$ROS_WORKSPACE/install" "$ROS_WORKSPACE/log"

    echo "Making sure if valid Conda environment is active..."
    set_ros_python_path
    if [ $? -ne 0 ]; then
        echo "Failed to set PYTHONPATH. Aborting build."
        return 1
    fi
    
    echo "Building workspace..."
    # Check if specific packages are provided
    if [ $# -eq 0 ]; then
        echo "Building all packages ..."
        colcon build --base-paths "$ROS_WORKSPACE"
    else
        echo "Building selected packages: $@"
        colcon build --base-paths "$ROS_WORKSPACE" --packages-select "$@"
    fi

    if [ $? -ne 0 ]; then
        echo "Build failed. Please check the errors above."
        return 1
    fi

    echo "Sourcing install/setup.bash..."
    source "$ROS_WORKSPACE/install/setup.bash"
    echo "Workspace setup complete!"
}

# Function to perform debug build with symlinked install
function debug_build_python() {
    if [ -z "$ROS_WORKSPACE" ]; then
        echo "ROS_WORKSPACE is not set. Use 'my_ws' to set it first."
        return 1
    fi

    echo "Performing clean build with symlinked install in: $ROS_WORKSPACE"

    # Clean the workspace
    rm -rf "$ROS_WORKSPACE/build" "$ROS_WORKSPACE/install" "$ROS_WORKSPACE/log"

    echo "Making sure if valid Conda environment is active..."
    set_ros_python_path
    if [ $? -ne 0 ]; then
        echo "Failed to set PYTHONPATH. Aborting build."
        return 1
    fi

    # Check if specific packages are provided
    if [ $# -eq 0 ]; then
        echo "Building all packages with symlink install..."
        colcon build --symlink-install --base-paths "$ROS_WORKSPACE"
    else
        echo "Building selected packages: $@"
        colcon build --symlink-install --base-paths "$ROS_WORKSPACE" --packages-select "$@"
    fi

    if [ $? -ne 0 ]; then
        echo "Debug build failed. Please check the errors above."
        return 1
    fi

    echo "Sourcing install/setup.bash..."
    source "$ROS_WORKSPACE/install/setup.bash"
    echo "Debug build with symlinked install complete!"
}

# Function to set ROS PYTHONPATH dynamically based on current Conda environment
function set_ros_python_path() {
    if [ -z "$CONDA_DEFAULT_ENV" ]; then
        echo "No Conda environment is currently active."
        return 1
    fi

    echo "Current Conda environment: $CONDA_DEFAULT_ENV"
    PYTHONPATH=$(conda run -n "$CONDA_DEFAULT_ENV" python -c "import sys; print(':'.join(sys.path))" 2>/dev/null | tr ':' '\n' | grep site-packages | tr '\n' ':')
    if [ -n "$PYTHONPATH" ]; then
        export PYTHONPATH="${PYTHONPATH}$PYTHONPATH"
        echo "PYTHONPATH set for ROS: $PYTHONPATH"
    else
        echo "Failed to retrieve PYTHONPATH. Ensure the Conda environment has Python installed."
        return 1
    fi
}