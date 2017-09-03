/* Fun Compiler and Runtime Engine
 * ParsedDefElementName.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.parser;

import fun.lang.*;

import java.util.*;

/**
 * Based on code generated by jjtree.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.4 $
 */
public class ParsedDefElementName extends NameWithDims implements Initializable {
    public ParsedDefElementName(int id) {
        super();
    }

    /** Accept the visitor. **/
    public Object jjtAccept(FunParserVisitor visitor, Object data) {
        return visitor.visit(this, data);
    }

    public void init() {
        int len = children.length;
        List<Dim> dims;
        if (len == 0) {
            dims = new EmptyList<Dim>();

        } else if (len == 1) {
            dims = new SingleItemList<Dim>((Dim) children[0]);

        } else {
            dims = Arrays.asList((Dim[]) children);
        }
        setDims(dims);
    }
}
