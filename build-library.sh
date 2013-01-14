#!/bin/bash

mkdir LeapMotion
mkdir LeapMotion/library
cp COPYING LeapMotion
cp README LeapMotion
cp library.properties LeapMotion
cp -R src LeapMotion
cp -R examples LeapMotion
cp -R lib/Leap* LeapMotion/library
cp -R lib/macosx LeapMotion/library
cp -R lib/windows LeapMotion/library
cp -R lib/windows64 LeapMotion/library
cd src
javac -source 1.6 -target 1.6 -classpath "../lib/processing-core-1.5.1.jar:../lib/LeapJava.jar" com/leapmotion/leap/processing/*.java
jar cvf ../LeapMotion/library/LeapMotion.jar com/leapmotion/leap/processing/*.class
cd ..
