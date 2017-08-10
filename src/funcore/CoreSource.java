/* Fun
 *
 * $Id: CoreSource.java,v 1.6 2014/07/15 14:25:46 sthippo Exp $
 *
 * Copyright (c) 2002-2014 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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
