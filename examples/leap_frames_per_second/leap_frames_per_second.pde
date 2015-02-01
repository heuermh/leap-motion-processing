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

import org.apache.commons.math.stat.descriptive.DescriptiveStatistics;
import org.apache.commons.math.stat.descriptive.SummaryStatistics;

LeapMotion leapMotion;

// data statistics
long lastTimestamp;
SummaryStatistics summary;
DescriptiveStatistics rolling;

// render statistics
long drawLastTimestamp;
SummaryStatistics drawSummary;
DescriptiveStatistics drawRolling;

void setup()
{
  size(16 * 50, 9 * 50);
  background(20);
  frameRate(60);

  leapMotion = new LeapMotion(this);
  summary = new SummaryStatistics();
  rolling = new DescriptiveStatistics(100);
  drawSummary = new SummaryStatistics();
  drawRolling = new DescriptiveStatistics(100);
}

void draw()
{
  fill(20);
  rect(0, 0, width, height);

  fill(210);
  textSize(24);

  text(String.format("Render fps (summary): %8.2f", 1.0E09 / drawSummary.getMean()), width / 7, height / 5);
  text(String.format("Render fps (rolling): %8.2f", 1.0E09 / drawRolling.getMean()), width / 7, 2 * height / 5);
  text(String.format("Data fps (summary): %8.2f", 1.0E09 / summary.getMean()), width / 7, 3 * height / 5);
  text(String.format("Data fps (rolling): %8.2f", 1.0E09 / rolling.getMean()), width / 7, 4 * height / 5);

  updateRenderStatistics(System.nanoTime());
}

void onFrame(final Controller controller)
{
  updateDataStatistics(controller.frame().timestamp());
}

void updateRenderStatistics(final long drawTimestamp)
{
  if (drawLastTimestamp > 0)
  {
    double elapsed = (drawTimestamp - drawLastTimestamp);
    drawSummary.addValue(elapsed);
    drawRolling.addValue(elapsed);
  }
  drawLastTimestamp = drawTimestamp;
}

void updateDataStatistics(final long dataTimestamp)
{
  if (lastTimestamp > 0)
  {
    double elapsed = (dataTimestamp - lastTimestamp) * 1000.0;
    summary.addValue(elapsed);
    rolling.addValue(elapsed);
  }
  lastTimestamp = dataTimestamp;
}
