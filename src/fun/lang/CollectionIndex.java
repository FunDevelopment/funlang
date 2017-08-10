/* Fun
 *
 * $Id: CollectionIndex.java,v 1.5 2012/04/26 13:41:17 sthippo Exp $
 *
 * Copyright (c) 2002-2012 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

import fun.runtime.Context;

/**
 * An CollectionIndex represents an index to a table or array.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.5 $
 */
public class CollectionIndex extends Index {

    public CollectionIndex() {
        super();
    }

    public CollectionIndex(Value value) {
        super(value);
    }

    public int getIndex(Context context) {
        return getIndexValue(context).getInt();
    }

    public String getKey(Context context) {
        return getIndexValue(context).getString();
    }

    public String toString() {
        return "[" + getChild(0).toString() + "]";
    }

    protected Index createIndex() {
        return new CollectionIndex();
    }
}
