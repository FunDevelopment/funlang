/* Fun Compiler and Runtime Engine
 * LiteralText.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
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

