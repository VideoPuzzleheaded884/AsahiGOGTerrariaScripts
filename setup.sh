#/usr/bin/env bash

# Find the GOG terraria installer
INSTALLER=terraria*.sh
ROOT=$PWD
GAME_FILES=$ROOT/terraria
EXE_DIR=$GAME_FILES/data/noarch/game
LIB_DIR=$EXE_DIR/lib-arm64

# Unzip the installer
mkdir -p $GAME_FILES
unzip $INSTALLER -d $GAME_FILES
rm $EXE_DIR/{System*.dll,monoconfig,monomachineconfig}
mkdir $LIB_DIR

# Clone the sources required for the two libraries we need
wget https://codeload.github.com/libsdl-org/SDL/zip/refs/tags/release-2.28.4
unzip release-2.28.4
rm release-2.28.4
git clone https://github.com/FNA-XNA/FNA3D.git --recurse-submodules
git clone https://github.com/FNA-XNA/FAudio

# Build SDL2
cd SDL-release-2.28.4
./configure
make
cp build/SDL.o $LIB_DIR/libSDL2-2.0.so.0

# Build FNA3D
cd $ROOT/FNA3D
git checkout fcfab155c129fde38f9fab957345759bcaf96454
mkdir build
cd build
cmake ../
make
cp libFNA3D.so.0.*.* $LIB_DIR/libFNA3D.so.0

# Build 
cd $ROOT/FAudio
git checkout 2cc9baafc7bf9ae524a61e9f8250883500a9820a
mkdir build
cd build
cmake ../
make
cp libFAudio.so.0 $LIB_DIR/libFAudio.so.0

# Make sure the libraries are executable
chmod +x $LIB_DIR/*

# Copy the scripts in
cd $ROOT
chmod +x scripts/*
cp scripts/* $EXE_DIR
