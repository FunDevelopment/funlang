/* Fun
 *
 * $Id: UnaryOperator.java,v 1.5 2011/08/12 21:17:59 sthippo Exp $
 *
 * Copyright (c) 2002-2011 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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
