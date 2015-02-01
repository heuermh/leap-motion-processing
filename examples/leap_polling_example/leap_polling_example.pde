/*

    Leap Motion library for Processing.
    Copyright (c) 2012-2015 held jointly by the individual authors.

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
import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.processing.LeapMotion;

LeapMotion leapMotion;

void setup()
{
  size(16 * 50, 9 * 50);
  background(20);
  frameRate(60);
  textAlign(CENTER);

  leapMotion = new LeapMotion(this);
}

void draw()
{
  fill(20);
  rect(0, 0, width, height);

  fill(0, 0, 80);
  textSize(3 * height / 5.0);
  text(String.valueOf(countExtendedFingers()), width / 2.0, 6 * height / 9.0);
}

int countExtendedFingers()
{
  int fingers = 0;
  Controller controller = leapMotion.controller();
  if (controller.isConnected())
  {
    Frame frame = controller.frame();
    if (!frame.hands().isEmpty())
    {
      for (Hand hand : frame.hands())
      {
        int extended = 0;
        for (Finger finger : hand.fingers())
        {
          if (finger.isExtended())
          {
            extended++;
          }
        }
        fingers = Math.max(fingers, extended);
      }
    }
  }
  return fingers;
}
