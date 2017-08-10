/* Fun
 *
 * $Id: LiteralText.java,v 1.5 2015/04/20 12:50:41 sthippo Exp $
 *
 * Copyright (c) 2002-2015 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;


/**
 * Subclass of StaticText which avoids cleaning up the string.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.5 $
 */
public class LiteralText extends StaticText {

    public LiteralText() {}

    /** Returns the passed string unchanged.
     */
    public String clean(String str) {
        return str;
    }

    /** Returns the passed string unchanged.
     */
    protected String trim(String str) {
        return str;
    }
}

