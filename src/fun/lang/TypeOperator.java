/* Fun
 *
 * $Id: TypeOperator.java,v 1.4 2015/05/04 16:16:44 sthippo Exp $
 *
 * Copyright (c) 2002-2015 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

/**
 * Class cast operator.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.4 $
 */
public class TypeOperator extends UnaryOperator {

    public Value operate(Value val) {
        Type type = (Type) getChild(0);
        return type.convert(val);
    }

    /** Ignore the passed type and return the type this
     *  operator casts to.
     */
    public Type getResultType(Type valType) {
        Type type = (Type) getChild(0);
        return type;
    }

    public String toString() {
        Type type = (Type) getChild(0);
        return "(" + type.getName() + ")\n";
    }
}
