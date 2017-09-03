/* Fun Compiler and Runtime Engine
 * AnyAny.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

/**
 * Equivalant to one or more asterisks ("*.*.*").
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */
public class AnyAny extends RegExp {
    public AnyAny() {
        super("**");
    }

    public boolean matches(String str) {
        return (str != null);
    }

    public String toString() {
        return "**";
    }
}
