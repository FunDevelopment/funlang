/* Fun Compiler and Runtime Engine
 * CollectionIndex.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
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
