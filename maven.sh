#!/bin/bash
set -e

# Variables
MAVEN_VERSION=3.9.9
INSTALL_DIR="/home/ansible/maven"

# Check if wget and tar are installed
if ! command -v wget &> /dev/null || ! command -v tar &> /dev/null; then
  echo "wget and/or tar are required but not installed. Exiting..."
  exit 1
fi

# Check if Maven is already installed
if command -v mvn &> /dev/null; then
  echo "Maven is already installed. Skipping installation."
  exit 0
fi

# Download and install Maven
echo "Installing Apache Maven $MAVEN_VERSION..."
wget https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -P /tmp
tar -zxvf /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /tmp
sudo mkdir -p $INSTALL_DIR
sudo mv /tmp/apache-maven-$MAVEN_VERSION $INSTALL_DIR

# Set environment variables
echo "Configuring Maven environment variables..."
echo "export M2_HOME=$INSTALL_DIR/apache-maven-$MAVEN_VERSION" | sudo tee -a /home/ansible/.bashrc
echo "export PATH=\$M2_HOME/bin:\$PATH" | sudo tee -a /home/ansible/.bashrc

# Make the environment variables executable by sourcing the profile
source /home/ansible/.bashrc

# Cleanup temporary files
rm -f /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz

# Verify Maven installation
echo "Verifying Maven installation:"
mvn -version
