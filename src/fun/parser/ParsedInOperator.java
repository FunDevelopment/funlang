/* Fun Compiler and Runtime Engine
 * ParsedInOperator.java
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
 * @version $Revision: 1.1 $
 */
public class ParsedInOperator extends InOperator {

    public ParsedInOperator(int id) {
        super();
    }

    /** Accept the visitor. **/
    public Object jjtAccept(FunParserVisitor visitor, Object data) {
        return visitor.visit(this, data);
    }
}
