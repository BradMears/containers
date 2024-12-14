#!/bin/bash
# Creates bash functions that can be used to conveniently invoke containers

function openscad() {
    cd ~/containers/openscad
    ./runit.sh
    cd - > /dev/null
}

function pydev() {
    cd ~/containers/pydev
    ./runit.sh
    cd - > /dev/null
}

function pydev_hw() {
    cd ~/containers/pydev_hw
    ./runit.sh
    cd - > /dev/null
}

function labjack() {
    cd ~/containers/labjack
    ./runit.sh
    cd - > /dev/null
}

function digital-modes() {
    cd ~/containers/digital-modes
    ./digital-modes.sh
    cd - > /dev/null
}
