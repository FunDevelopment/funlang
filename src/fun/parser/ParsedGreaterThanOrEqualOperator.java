/* Fun Compiler and Runtime Engine
 * ParsedGreaterThanOrEqualOperator.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
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
