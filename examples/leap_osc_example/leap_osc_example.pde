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
import com.leapmotion.leap.HandList;
import com.leapmotion.leap.Controller;
import com.leapmotion.leap.processing.LeapMotion;

import oscP5.OscMessage;
import oscP5.OscP5;

LeapMotion leapMotion;

OscP5 oscP5;
String host = "localhost";
int sendPort = 6449;

void setup()
{
  size(16 * 50, 9 * 50);
  background(20);

  leapMotion = new LeapMotion(this);

  oscP5 = new OscP5(this, 6450); // receive port is not used
}

void draw()
{
  fill(20);
  rect(0, 0, width, height);
}

void onFrame(final Controller controller)
{
  Frame frame = controller.frame();
  HandList hands = frame.hands();
  if (!hands.isEmpty())
  {
    Hand leftHand = hands.leftmost();
    sendHand("/hand0", leftHand);

    for (int i = 0, size = leftHand.fingers().count(); i < size; i++)
    {
      sendFinger("/finger0-" + i, leftHand.fingers().get(i));
    }

    if (hands.count() > 1)
    {
      Hand rightHand = hands.rightmost();
      sendHand("/hand1", rightHand);

      for (int i = 0, size = rightHand.fingers().count(); i < size; i++)
      {
        sendFinger("/finger1-" + i, rightHand.fingers().get(i));
      }
    }
  }
}

void sendHand(final String address, final Hand hand)
{
  OscMessage message = new OscMessage(address);
  message.add(hand.id());
  message.add(0);
  message.add(hand.stabilizedPalmPosition().getX());
  message.add(hand.stabilizedPalmPosition().getY());
  message.add(hand.stabilizedPalmPosition().getZ());
  oscP5.send(message, host, sendPort);
}

void sendFinger(final String address, final Finger finger)
{
  OscMessage message = new OscMessage(address);
  message.add(finger.hand().id());
  message.add(finger.id());
  message.add(finger.stabilizedTipPosition().getX());
  message.add(finger.stabilizedTipPosition().getY());
  message.add(finger.stabilizedTipPosition().getZ());
  oscP5.send(message, host, sendPort);
}