#!/usr/bin/env bash

# discovery_client_setup.sh
#
# Usage:
#   ./discovery_client_setup.sh                  # Uses default Discovery Server settings
#   ./discovery_client_setup.sh --server-ip <IP> --server-port <PORT> --server-prefix <PREFIX>
#     Specify custom Discovery Server settings.

# Default configuration
DEFAULT_SERVER_IP="35.9.128.247"
DEFAULT_SERVER_PORT="11811"
DEFAULT_SERVER_PREFIX="44.53.00.5f.45.50.52.4f.53.49.4d.41"  # For server-id=0, this is typical
DEFAULT_SUPER_CLIENT_XML="$HOME/super_client_configuration_file.xml"

# Parse arguments
function parse_arguments() {
  # Default values
  SERVER_IP="$DEFAULT_SERVER_IP"
  SERVER_PORT="$DEFAULT_SERVER_PORT"
  SERVER_PREFIX="$DEFAULT_SERVER_PREFIX"
  SUPER_CLIENT_XML="$DEFAULT_SUPER_CLIENT_XML"

  # Parse arguments using getopt
  while [[ $# -gt 0 ]]; do
    case $1 in
      --server-ip)
        SERVER_IP="$2"
        shift 2
        ;;
      --server-port)
        SERVER_PORT="$2"
        shift 2
        ;;
      --server-prefix)
        SERVER_PREFIX="$2"
        shift 2
        ;;
      --output-xml)
        SUPER_CLIENT_XML="$2"
        shift 2
        ;;
      --help)
        print_help
        exit 0
        ;;
      *)
        echo "Unknown option: $1"
        print_help
        exit 1
        ;;
    esac
  done
}

function print_help() {
  echo "Usage: $0 [--server-ip <IP>] [--server-port <PORT>] [--server-prefix <PREFIX>] [--output-xml <FILE>]"
  echo ""
  echo "Options:"
  echo "  --server-ip <IP>          IP address of the Discovery Server (default: $DEFAULT_SERVER_IP)"
  echo "  --server-port <PORT>      Port of the Discovery Server (default: $DEFAULT_SERVER_PORT)"
  echo "  --server-prefix <PREFIX>  GUID prefix of the Discovery Server (default: $DEFAULT_SERVER_PREFIX)"
  echo "  --output-xml <FILE>       Path to the generated XML file (default: $DEFAULT_SUPER_CLIENT_XML)"
  echo ""
  echo "Example:"
  echo "  $0 --server-ip 192.168.1.100 --server-port 11811 --server-prefix 44.53.00.5f.45.50.52.4f.53.49.4d.41"
}

# Generate the super client XML configuration
function create_super_client_xml() {
  echo "Creating super_client XML configuration at: $SUPER_CLIENT_XML"
  cat <<EOF > "$SUPER_CLIENT_XML"
<?xml version="1.0" encoding="UTF-8"?>
<dds>
  <profiles xmlns="http://www.eprosima.com/XMLSchemas/fastRTPS_Profiles">
    <participant profile_name="super_client_profile" is_default_profile="true">
      <rtps>
        <builtin>
          <discovery_config>
            <!-- This participant will be a SUPER_CLIENT, receiving all discovery info -->
            <discoveryProtocol>SUPER_CLIENT</discoveryProtocol>
            <discoveryServersList>
              <RemoteServer prefix="$SERVER_PREFIX">
                <metatrafficUnicastLocatorList>
                  <locator>
                    <udpv4>
                      <address>$SERVER_IP</address>
                      <port>$SERVER_PORT</port>
                    </udpv4>
                  </locator>
                </metatrafficUnicastLocatorList>
              </RemoteServer>
            </discoveryServersList>
          </discovery_config>
        </builtin>
      </rtps>
    </participant>
  </profiles>
</dds>
EOF
}

# Set environment variables and restart ROS 2 daemon
function setup_super_client_env() {
  echo "Exporting environment variables for super client..."
  export FASTRTPS_DEFAULT_PROFILES_FILE="$SUPER_CLIENT_XML"
  export ROS_DISCOVERY_SERVER="${SERVER_IP}:${SERVER_PORT}"

  echo "Restarting ROS 2 daemon to pick up changes..."
  ros2 daemon stop
  ros2 daemon start

  echo
  echo "Done. Any ROS 2 commands in this shell will now join the Discovery Server at $SERVER_IP:$SERVER_PORT."
  echo "Example: ros2 topic list"
}

#############################
# Main Script Execution     #
#############################

# Parse arguments or use defaults
parse_arguments "$@"

# Generate the super client XML
create_super_client_xml

# Set up the environment
setup_super_client_env
