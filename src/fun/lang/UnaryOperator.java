/* Fun Compiler and Runtime Engine
 * UnaryOperator.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import java.util.List;

/**
 * Base class for unary operators.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.5 $
 */

abstract public class UnaryOperator extends AbstractOperator {

    public UnaryOperator() {}

    public Value operate(List<Value> operands) {
        return operate((Value) operands.get(0));
    }

    abstract public Value operate(Value val);

    public Type getResultType(Type type) {
        return type;
    }
}
