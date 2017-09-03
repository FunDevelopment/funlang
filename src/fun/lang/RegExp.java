/* Fun Compiler and Runtime Engine
 * RegExp.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;


/**
 * Base class for regexp nodes.  A regexp node holds a pattern matching string.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */
abstract public class RegExp extends NameNode {

    public RegExp(String regexp) {
        super(regexp);
    }

    abstract public boolean matches(String str);
}
