/* Fun
 *
 * $Id: ParsedCollectionIndex.java,v 1.4 2007/10/08 15:36:59 sthippo Exp $
 *
 * Copyright (c) 2002-2007 by fundev.org
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
public class ParsedCollectionIndex extends CollectionIndex {
    public ParsedCollectionIndex(int id) {
        super();
    }

    /** Accept the visitor. **/
    public Object jjtAccept(FunParserVisitor visitor, Object data) {
        return visitor.visit(this, data);
    }
    
    public void setDynamic() {
        setDynamic(true);
    }
    
}
