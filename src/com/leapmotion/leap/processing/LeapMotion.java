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
package com.leapmotion.leap.processing;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Listener;

import processing.core.PApplet;

/**
 * Leap Motion library for Processing.
 */
public final class LeapMotion
{
    private final PApplet applet;
    private static final Class<?>[] PARAM = new Class<?>[] { Controller.class };

    public LeapMotion(final PApplet applet)
    {
        checkNotNull(applet, "applet must not be null");
        this.applet = applet;
        new Controller().addListener(new Listener()
            {
                @Override
                public void onInit(final Controller controller)
                {
                    call("onInit", controller);
                }

                @Override
                public void onConnect(final Controller controller)
                {
                    call("onConnect", controller);
                }

                @Override
                public void onDisconnect(final Controller controller)
                {
                    call("onDisconnect", controller);
                }

                @Override
                public void onExit(final Controller controller)
                {
                    call("onExit", controller);
                }

                @Override
                public void onFrame(final Controller controller)
                {
                    call("onFrame", controller);
                }
            });
    }

    private void call(final String methodName, final Controller controller)
    {
        try
        {
            Method method = applet.getClass().getMethod(methodName, PARAM);
            method.invoke(applet, new Object[] { controller });
        }
        catch (IllegalAccessException e)
        {
            // ignore
        }
        catch (IllegalArgumentException e)
        {
            // ignore
        }
        catch (InvocationTargetException e)
        {
            // ignore
        }
        catch (NoSuchMethodException e)
        {
            // ignore
        }
        catch (SecurityException e)
        {
            // ignore
        }
    }

    private static void checkNotNull(final Object value, final String message)
    {
        if (value == null)
        {
            throw new NullPointerException(message);
        }
    }
}