/* Fun Compiler and Runtime Engine
 * LogicalOrOperator.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

/**
 * Logical Or operator.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.5 $
 */
public class LogicalOrOperator extends BooleanOperator {

    public boolean operate(boolean op1, Value val2) {
        if (op1) {
            return true;
        }
        return val2.getBoolean();
    }

    public String toString() {
        return " || ";
    }
}
