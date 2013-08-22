/*

    Leap Motion library for Processing.
    Copyright (c) 2012-2013 held jointly by the individual authors.

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

import org.apache.commons.math.stat.descriptive.DescriptiveStatistics;

LeapMotion leapMotion;

static final int WINDOW = 60; // 60 frames is about 500 ms
int leftFingerCount = 0;
int rightFingerCount = 0;
DescriptiveStatistics rollingLeftFingerCount;
DescriptiveStatistics rollingRightFingerCount;

void setup()
{
  size(16*50, 9*50);
  background(20);
  frameRate(60);
  textAlign(CENTER);

  leapMotion = new LeapMotion(this);
  rollingLeftFingerCount = new DescriptiveStatistics(WINDOW);
  rollingRightFingerCount = new DescriptiveStatistics(WINDOW);
}

void draw()
{
  fill(20);
  rect(0, 0, width, height);

  fill(0, 0, 120);
  textSize(80);
  text(String.valueOf(rollingLeftFingerCount.getMean()), width/3.0, 2*height/5.0);
  text(String.valueOf(rollingRightFingerCount.getMean()), 2*width/3.0, 2*height/5.0);

  fill(80, 0, 0);
  textSize(10);
  text(String.valueOf(leftFingerCount), width/3.0, 4*height/5.0);
  text(String.valueOf(rightFingerCount), 2*width/3.0, 4*height/5.0);
}

void onFrame(final Controller controller)
{
  Frame frame = controller.frame();
  for (Hand hand : frame.hands())
  {
    if (isLeftHand(hand))
    {
      leftFingerCount = hand.fingers().count();
      rollingLeftFingerCount.addValue((double) leftFingerCount);
    }
    else if (isRightHand(hand))
    {
      rightFingerCount = hand.fingers().count();
      rollingRightFingerCount.addValue((double) rightFingerCount);
    }
  }
}

boolean isLeftHand(final Hand hand)
{
  return hand.sphereCenter().getX() > 0;
}

boolean isRightHand(final Hand hand)
{
  return hand.sphereCenter().getX() < 0;
}