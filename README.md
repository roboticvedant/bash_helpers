# ROS Helper Scripts

This repository provides a set of helper scripts and aliases to simplify workspace management, ROS builds, and Python path setup for ROS2 projects.

---

## Prerequisites

1. **ROS2 Installed**: Ensure you have ROS2 installed and configured on your system.
2. **Conda Environment**: Have a Conda environment ready for Python path management if applicable.

---

## Setup

### Step 1: Either source my_aliases.sh or put it in bashrc

Add the following line to your `.bashrc` or `.zshrc` to load the aliases automatically:
```bash
source ~/bash_helpers/my_aliases.sh
```
Alternatively put the cmd in your ~/.bashrc

---

### Step 2: Call the helpers

Use the following alias to use the ros helpers
```bash
get_ros_helper
```

---

## Functionality

### 1. Set your ROS Workspace
Use `my_ws` to set the current directory as your `ROS_WORKSPACE`:
```bash
my_ws
```
Output:
```
ROS_WORKSPACE set to: /path/to/current/directory
```

### 2. Clean, Build, and Source the Workspace
Use `clean_build_source_my_ws` to clean, build, and source the workspace. Optionally, specify packages to build:
```bash
clean_build_source_my_ws [package_name1 package_name2 ...]
```

- Cleans `build`, `install`, and `log` directories.
- Validates the Conda environment and sets `PYTHONPATH`.
- Builds all packages if no specific package names are provided.

### 3. Debug Build with Symlink Install
Use `debug_build_python` for a debug build with a symlinked install. Optionally, specify packages to build:
```bash
debug_build_python [package_name1 package_name2 ...]
```

- Cleans the workspace.
- Validates the Conda environment and sets `PYTHONPATH`.
- Builds all packages or specific packages with `--symlink-install`.

### 4. Set Python Path for ROS
The `set_ros_python_path` function dynamically sets the `PYTHONPATH` for the active Conda environment:
```bash
set_ros_python_path
```

Output:
```
Current Conda environment: my_env
PYTHONPATH set for ROS: /path/to/conda/env/lib/python3.x/site-packages
```

---

## Example Workflow

```bash
# Step 1: Navigate to your ROS workspace
cd ~/my_ros_workspace

# Step 2: Set the workspace
my_ws

# Step 3: Perform a clean build
clean_build_source_my_ws

# Step 4: Debug build for specific packages
debug_build_python my_package another_package
```

---

## Troubleshooting

1. **No Conda Environment Active**:
   Ensure you activate a Conda environment before running ROS helper functions:
   ```bash
   conda activate my_ros_env
   ```

2. **PYTHONPATH Errors**:
   Verify the Conda environment has Python installed and `site-packages` paths available.
