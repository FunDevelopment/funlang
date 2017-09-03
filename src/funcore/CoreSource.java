/* Fun Compiler and Runtime Engine
 * CoreSource.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package funcore;


/**
 * This is a static convenience class for autoloading core source.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.6 $
 */
public final class CoreSource {
    public static String[] corePaths = { "core.fun", "core_ui.fun", "core_js.fun", "core_platform_java.fun", "core_sandbox.fun" };

    public static String[] getCorePaths() {
        return corePaths;
    }

}
