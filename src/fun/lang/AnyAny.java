/* Fun
 *
 * $Id: AnyAny.java,v 1.3 2005/06/30 04:20:52 sthippo Exp $
 *
 * Copyright (c) 2002-2005 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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
