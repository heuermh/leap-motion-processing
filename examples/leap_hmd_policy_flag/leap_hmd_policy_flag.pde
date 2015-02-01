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
import com.leapmotion.leap.processing.LeapMotion;

boolean hmdPolicyFlag = false;
LeapMotion leapMotion;

void setup()
{
  size(16 * 30, 9 * 30);
  background(20);

  leapMotion = new LeapMotion(this);
}

void draw()
{
  fill(20);
  rect(0, 0, width, height);

  fill(0, 0, 120);
  textSize(36);
  textAlign(CENTER);
  text("HMD policy flag:  " + String.valueOf(hmdPolicyFlag), width/2.0, height/3.0);
}

void onInit(final Controller controller)
{
  println("Initialized");
}

void onConnect(final Controller controller)
{
  println("Connected");
  controller.setPolicyFlags(Controller.PolicyFlag.POLICY_OPTIMIZE_HMD);
}

void onFrame(final Controller controller)
{
  hmdPolicyFlag = Controller.PolicyFlag.POLICY_OPTIMIZE_HMD.equals(controller.policyFlags());
}