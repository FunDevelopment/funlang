/* Fun Compiler and Runtime Engine
 * ParsedSubConstruction.java
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
 * @version $Revision: 1.3 $
 */
public class ParsedSubConstruction extends SubStatement {
    public ParsedSubConstruction(int id) {
        super();
    }

    /** Accept the visitor. **/
    public Object jjtAccept(FunParserVisitor visitor, Object data) {
        return visitor.visit(this, data);
    }
}
