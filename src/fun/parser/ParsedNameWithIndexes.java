/* Fun Compiler and Runtime Engine
 * ParsedNameWithIndexes.java
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
 * @version $Revision: 1.5 $
 */
public class ParsedNameWithIndexes extends NameWithIndexes implements Initializable {
    public ParsedNameWithIndexes(int id) {
        super();
    }

    /** Accept the visitor. **/
    public Object jjtAccept(FunParserVisitor visitor, Object data) {
        return visitor.visit(this, data);
    }

    public void init() {
        int len = children.length;
        List<Index> indexes;
        if (len == 0) {
            indexes = new EmptyList<Index>();

        } else if (len == 1) {
            indexes = new SingleItemList<Index>((Index) children[0]);

        } else {
            indexes = new ArrayList<Index>(len);
            for (int i = 0; i < len; i++) {
                if (children[i] instanceof Index) {
                    indexes.add((Index) children[i]);
                }
            }
        }
        setIndexes(indexes);
    }
}
