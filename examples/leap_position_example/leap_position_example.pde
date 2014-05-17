/*

    Leap Motion library for Processing.
    Copyright (c) 2012-2014 held jointly by the individual authors.

    This file is part of Leap Motion library for Processing.

    Leap Motion library for Processing is free software: you can redistribute it and/or
    modify it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Leap Motion library for Processing is distributed in the hope that it will be
    useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Leap Motion library for Processing.  If not, see
    <http://www.gnu.org/licenses/>.

*/
import java.util.Map;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentHashMap;

import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.Tool;
import com.leapmotion.leap.Vector;
import com.leapmotion.leap.processing.LeapMotion;

LeapMotion leapMotion;

ConcurrentMap<Integer, Integer> fingerColors;
ConcurrentMap<Integer, Integer> toolColors;
ConcurrentMap<Integer, Vector> fingerPositions;
ConcurrentMap<Integer, Vector> toolPositions;

void setup()
{
  size(16 * 50, 9 * 50);
  background(20);
  frameRate(60);
  ellipseMode(CENTER);

  leapMotion = new LeapMotion(this);
  fingerColors = new ConcurrentHashMap<Integer, Integer>();
  toolColors = new ConcurrentHashMap<Integer, Integer>();
  fingerPositions = new ConcurrentHashMap<Integer, Vector>();
  toolPositions = new ConcurrentHashMap<Integer, Vector>();
}

void draw()
{
  fill(20);
  rect(0, 0, width, height);

  for (Map.Entry entry : fingerPositions.entrySet())
  {
    Integer fingerId = (Integer) entry.getKey();
    Vector position = (Vector) entry.getValue();
    fill(fingerColors.get(fingerId));
    noStroke();
    ellipse(leapMotion.leapToSketchX(position.getX()), leapMotion.leapToSketchY(position.getY()), 24.0, 24.0);
  }
  for (Map.Entry entry : toolPositions.entrySet())
  {
    Integer toolId = (Integer) entry.getKey();
    Vector position = (Vector) entry.getValue();
    fill(toolColors.get(toolId));
    noStroke();
    ellipse(leapMotion.leapToSketchX(position.getX()), leapMotion.leapToSketchY(position.getY()), 24.0, 24.0);
  }
}

void onFrame(final Controller controller)
{
  Frame frame = controller.frame();
  fingerPositions.clear();
  for (Finger finger : frame.fingers())
  {
    int fingerId = finger.id();
    color c = color(random(0, 255), random(0, 255), random(0, 255));
    fingerColors.putIfAbsent(fingerId, c);
    fingerPositions.put(fingerId, finger.tipPosition());
  }
  toolPositions.clear();
  for (Tool tool : frame.tools())
  {
    int toolId = tool.id();
    color c = color(random(0, 255), random(0, 255), random(0, 255));
    toolColors.putIfAbsent(toolId, c);
    toolPositions.put(toolId, tool.tipPosition());
  }
}

