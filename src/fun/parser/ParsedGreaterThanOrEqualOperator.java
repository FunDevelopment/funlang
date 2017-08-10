/* Fun
 *
 * $Id: ParsedGreaterThanOrEqualOperator.java,v 1.4 2009/02/09 14:05:08 sthippo Exp $
 *
 * Copyright (c) 2002-2009 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.parser;

import fun.lang.*;

/**
 * Based on code generated by jjtree.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.4 $
 */
public class ParsedGreaterThanOrEqualOperator extends GreaterThanOrEqualOperator {
    public ParsedGreaterThanOrEqualOperator(int id) {
        super();
    }

    /** Accept the visitor. **/
    public Object jjtAccept(FunParserVisitor visitor, Object data) {
        return visitor.visit(this, data);
    }

    public void setIgnoreCase() {
        setIgnoreCase(true);
    }
}
