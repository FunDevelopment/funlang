/* Fun
 *
 * $Id: LogicalAndOperator.java,v 1.6 2008/08/15 21:28:05 sthippo Exp $
 *
 * Copyright (c) 2002-2008 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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
