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
package com.leapmotion.leap.processing;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import java.util.Map;
import java.util.HashMap;

import javax.swing.SwingUtilities;

import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Listener;

import processing.core.PApplet;

/**
 * Leap Motion library for Processing.
 *
 * <b>Usage</b>
 * <p>
 * Initialize the Leap Motion library in the <code>setup()</code> method in your sketch
 * </p>
 * <pre>
 * LeapMotion leapMotion;
 *
 * void setup()
 * {
 *   size(800, 450);
 *   leapMotion = new LeapMotion(this);
 * }
 * </pre>
 *
 * <p>
 * Then implement zero or more of the methods defined in
 * <a href="https://developer.leapmotion.com/documentation/skeletal/java/api/Leap.Listener.html">com.leapmotion.leap.Listener</a>
 * in your sketch; they will be called reflectively by the Leap Motion library. E.g.
 * </p>
 * <pre>
 * void onFrame(final Controller controller)
 * {
 *   Frame frame = controller.frame();
 *   for (Finger finger : frame.fingers())
 *   {
 *     // ...
 *   }
 * }
 * </pre>
 *
 * <p>
 * Alternatively, the controller may be polled in your <code>draw()</code> method, e.g.
 * </p>
 * <pre>
 * void draw()
 * {
 *   Controller controller = leapMotion.controller();
 *   if (controller.isConnected())
 *   {
 *     Frame frame = controller.frame();
 *     for (Finger finger : frame.fingers())
 *     {
 *       // ...
 *     }
 *   }
 * }
 * </pre>
 *
 * @author  Michael Heuer
 */
public final class LeapMotion
{
    /** Applet. */
    private final PApplet applet;

    /** Controller. */
    private final Controller controller = new Controller();

    /** Map of method name to method. */
    private final Map<String, Method> methods = new HashMap<String, Method>();

    /** Listener. */
    private final Listener listener = new Listener()
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
        };

    /** Reflective method call parameters. */
    private static final Class<?>[] PARAM = new Class<?>[] { Controller.class };

    /** Leap width, in mm. */
    private static float LEAP_WIDTH = 200.0f;

    /** Leap height, in mm. */
    private static float LEAP_HEIGHT = 700.0f;


    /**
     * Create a new LeapMotion library with the specified applet.
     *
     * @param applet applet, must not be null
     */
    public LeapMotion(final PApplet applet)
    {
        checkNotNull(applet, "applet must not be null");
        this.applet = applet;
        controller.addListener(listener);
    }


    /**
     * Return the controller for this LeapMotion library.
     *
     * <p>
     * May be polled in your <code>draw()</code> method, e.g.
     * </p>
     * <pre>
     * void draw()
     * {
     *   Controller controller = leapMotion.controller();
     *   if (controller.isConnected())
     *   {
     *     Frame frame = controller.frame();
     *     for (Finger finger : frame.fingers())
     *     {
     *       // ...
     *     }
     *   }
     * }
     * </pre>
     *
     * @since 1.20
     * @return the controller for this LeapMotion library
     */
    public Controller controller()
    {
        return controller;
    }

    /**
     * Return the specified x value in Leap Motion coordinates interpolated linearly to display coordindates.
     *
     * @param x x value in Leap Motion coordinates
     * @return the specified x value in Leap Motion coordinates interpolated linearly to display coordindates
     */
    public float leapToDisplayX(final float x)
    {
        float c = applet.displayWidth / 2.0f;
        if (x > 0.0f)
        {
            return applet.lerp(c, applet.displayWidth, x / LEAP_WIDTH);
        }
        else
        {
            return applet.lerp(c, 0.0f, -x / LEAP_WIDTH);
        }
    }

    /**
     * Return the specified y value in Leap Motion coordinates interpolated linearly to display coordindates.
     *
     * @param y y value in Leap Motion coordinates
     * @return the specified y value in Leap Motion coordinates interpolated linearly to display coordindates
     */
    public float leapToDisplayY(final float y)
    {
        return applet.lerp(applet.displayHeight, 0.0f, y / LEAP_HEIGHT);
    }

    /**
     * Return the specified x value in Leap Motion coordinates interpolated linearly to sketch coordindates.
     *
     * @param x x value in Leap Motion coordinates
     * @return the specified x value in Leap Motion coordinates interpolated linearly to sketch coordindates
     */
    public float leapToSketchX(final float x)
    {
        warnIfUsing3DGraphics("leapToSketchX", "leapToScreenX");
        float c = applet.width / 2.0f;
        if (x > 0.0f)
        {
            return applet.lerp(c, applet.width, x / LEAP_WIDTH);
        }
        else
        {
            return applet.lerp(c, 0.0f, -x / LEAP_WIDTH);
        }
    }

    /**
     * Return the specified y value in Leap Motion coordinates interpolated linearly to sketch coordindates.
     *
     * @param y y value in Leap Motion coordinates
     * @return the specified y value in Leap Motion coordinates interpolated linearly to sketch coordindates
     */
    public float leapToSketchY(final float y)
    {
        warnIfUsing3DGraphics("leapToSketchY", "leapToScreenY");
        return applet.lerp(applet.height, 0.0f, y / LEAP_HEIGHT);
    }

    /**
     * Return the specified Leap Motion coordinates interpolated linearly to an x value in screen coordindates.
     * Should only be called in a 3D graphics context.
     *
     * @param x x value in Leap Motion coordinates
     * @param y y value in Leap Motion coordinates
     * @param z z value in Leap Motion coordinates
     * @return the specified Leap Motion coordinates interpolated linearly to an x value in screen coordindates
     */
    public float leapToScreenX(final float x, final float y, final float z)
    {
        warnIfUsing2DGraphics("leapToScreenX", "leapToSketchX");
        return applet.screenX(leapToSketchX(x), leapToSketchY(y), z);
    }

    /**
     * Return the specified Leap Motion coordinates interpolated linearly to a y value in screen coordindates.
     * Should only be called in a 3D graphics context.
     *
     * @param x x value in Leap Motion coordinates
     * @param y y value in Leap Motion coordinates
     * @param z z value in Leap Motion coordinates
     * @return the specified Leap Motion coordinates interpolated linearly to a y value in screen coordindates
     */
    public float leapToScreenY(final float x, final float y, final float z)
    {
        warnIfUsing2DGraphics("leapToScreenY", "leapToSketchY");
        return applet.screenY(leapToSketchX(x), leapToSketchY(y), z);
    }

    /**
     * Print a warning if this method is called with a 2D graphics context.
     *
     * @param incorrectMethodName incorrect method name
     * @param correctMethodName correct method name
     */
    private void warnIfUsing2DGraphics(final String incorrectMethodName, final String correctMethodName)
    {
        if (applet.g == null)
        {
            applet.println("method " + incorrectMethodName + " was called using a null graphics context");
        }
        else if (applet.g.is2D())
        {
            applet.println("method " + incorrectMethodName + " was called using a 2D graphics context, perhaps you meant to call " + correctMethodName);
        }
    }

    /**
     * Print a warning if this method is called with a 3D graphics context.
     *
     * @param incorrectMethodName incorrect method name
     * @param correctMethodName correct method name
     */
    private void warnIfUsing3DGraphics(final String incorrectMethodName, final String correctMethodName)
    {
        if (applet.g == null)
        {
            applet.println("method " + incorrectMethodName + " was called using a null graphics context");
        }
        else if (applet.g.is3D())
        {
            applet.println("method " + incorrectMethodName + " was called using a 3D graphics context, perhaps you meant to call " + correctMethodName);
        }
    }

    /**
     * Reflective method call.
     *
     * @param methodName method name
     * @param controller controller
     */
    private void call(final String methodName, final Controller controller)
    {
        Runnable reflectiveMethodCall = new Runnable()
            {
                @Override
                public void run()
                {
                    try
                    {
                        Method method = lookup();
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

                private Method lookup() throws NoSuchMethodException
                {
                    if (!methods.containsKey(methodName))
                    {
                        methods.put(methodName, applet.getClass().getMethod(methodName, PARAM));
                    }
                    return methods.get(methodName);
                }
            };

        // be sure to invoke on the event dispatch thread
        if (SwingUtilities.isEventDispatchThread())
        {
            reflectiveMethodCall.run();
        }
        else
        {
            SwingUtilities.invokeLater(reflectiveMethodCall);
        }
    }

    /**
     * Check that the specified value is not null.
     *
     * @param value value
     * @param message message
     */
    private static void checkNotNull(final Object value, final String message)
    {
        if (value == null)
        {
            throw new NullPointerException(message);
        }
    }
}
