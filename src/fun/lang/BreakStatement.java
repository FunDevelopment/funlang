/* Fun Compiler and Runtime Engine
 * BreakStatement.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;


/**
 * A <code>break</code> statement
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */

public class BreakStatement extends FunStatement {

    public BreakStatement() {
        super();
    }

    public boolean isDynamic() {
        return false;
    }
}
