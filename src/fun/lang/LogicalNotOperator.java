/* Fun Compiler and Runtime Engine
 * LogicalNotOperator.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

/**
 * Logical Not operator.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.5 $
 */
public class LogicalNotOperator extends UnaryOperator {

    public Value operate(Value val) {
        boolean result = !val.getBoolean();
        return new PrimitiveValue(result);
    }

    /** Always returns boolean type */
    public Type getResultType(Type type) {
        return PrimitiveType.BOOLEAN;
    }

    public String toString() {
        return "!";
    }
}
