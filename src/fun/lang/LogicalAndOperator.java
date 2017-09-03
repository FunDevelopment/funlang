/* Fun Compiler and Runtime Engine
 * LogicalAndOperator.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;


/**
 * Logical And operator.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.6 $
 */

public class LogicalAndOperator extends BooleanOperator {

    public boolean operate(boolean op1, Value val2) {
        if (!op1) {
            return false;
        }
        return val2.getBoolean();
    }

    public String toString() {
        return " && ";
    }
}
