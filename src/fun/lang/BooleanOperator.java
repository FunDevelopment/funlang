/* Fun Compiler and Runtime Engine
 * BooleanOperator.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import fun.runtime.Context;

/**
 * Base class for boolean operators.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.6 $
 */

abstract public class BooleanOperator extends BinaryOperator {

    public BooleanOperator() {}

    abstract public boolean operate(boolean bool1, Value val2);

    public Value operate(Value firstVal, Value secondVal) {
        boolean bool = operate(firstVal.getBoolean(), secondVal);
        return new PrimitiveValue(bool);
    }

    /** Always returns boolean type */
    public Type getResultType(Type firstType, Type secondType, Context context) {
        return PrimitiveType.BOOLEAN;
    }
}
