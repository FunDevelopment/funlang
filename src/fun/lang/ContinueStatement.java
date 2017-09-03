/* Fun Compiler and Runtime Engine
 * ContinueStatement.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;


/**
 * A directive to continue with a construction after another
 * construction completes.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.4 $
 */

public class ContinueStatement extends FunStatement {

    public ContinueStatement() {
        super();
    }

    public boolean isDynamic() {
        return false;
    }
}
