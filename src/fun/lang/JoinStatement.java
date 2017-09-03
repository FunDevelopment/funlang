/* Fun Compiler and Runtime Engine
 * JoinStatement.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

/**
 * A join statement.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */

public class JoinStatement extends ComplexName {

    public JoinStatement() {
        super();
    }

    public String toString(String prefix) {
        return prefix + "join " + getName();
    }
}
