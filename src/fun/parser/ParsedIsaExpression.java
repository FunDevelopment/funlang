/* Fun
 *
 * $Id: ParsedIsaExpression.java,v 1.3 2005/06/30 04:20:55 sthippo Exp $
 *
 * Copyright (c) 2003-2005 by fundev.org
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
 * @version $Revision: 1.3 $
 */
public class ParsedIsaExpression extends IsaExpression {
    public ParsedIsaExpression(int id) {
        super();
    }

    /** Accept the visitor. **/
    public Object jjtAccept(FunParserVisitor visitor, Object data) {
        return visitor.visit(this, data);
    }
}
