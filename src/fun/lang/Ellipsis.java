/* Fun Compiler and Runtime Engine
 * Ellipsis.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

/**
 * An ellipsis in an array definition.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */

public class Ellipsis extends SuperStatement {

    public Ellipsis() {
        super();
    }

    public String toString(String prefix) {
        return "...";
    }
}
