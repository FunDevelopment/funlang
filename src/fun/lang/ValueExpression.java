/* Fun
 *
 * $Id: ValueExpression.java,v 1.8 2015/06/18 13:18:09 sthippo Exp $
 *
 * Copyright (c) 2002-2017 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

import fun.runtime.Context;

/**
 * A ValueExpression is a generic value container.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.8 $
 */
public class ValueExpression extends Expression {

    public ValueExpression() {
        super();
    }
    
    private ValueExpression(ValueExpression expression) {
        super(expression);
    }

    public Object generateData(Context context, Definition def) throws Redirection {
        // not the right logic, just to get things rolling
        int n = getNumChildren();
        for (int i = 0; i < n; i++) {
            FunNode node = getChild(i);
            if (node instanceof Value) {
                return node;
            } else if (node instanceof ValueGenerator) {
                Value value = ((ValueGenerator) node).getValue(context);
                if (value != null) {
                    return value;
                }
            }
        }
        return NullValue.NULL_VALUE;
    }

    public Type getType(Context context, boolean generate) {
        int n = getNumChildren();
        if (n > 0) {
            return getChildType(context, generate, 0);
        } else {
            return DefaultType.TYPE;
        }
    }

    public Expression resolveExpression(Context context) {
        ValueExpression resolvedExpression = new ValueExpression(this);
        resolvedExpression.resolveChildrenInPlace(context);
        return resolvedExpression;
    }
}