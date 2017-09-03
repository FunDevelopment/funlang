/* Fun Compiler and Runtime Engine
 * FunTable.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;


/**
 * Interface for fun tables.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */

public interface FunTable {

    /** Returns an element in the table.  The return value may be a Chunk,
     *  a Value, another array or null.  Throws a NoSuchElementException if the
     *  table does not contain an entry for the specified key, nor a default
     *  entry.
     */
    public Object get(Object key);

    public int getSize();

    public boolean isGrowable();

    public void put(Object key, Object element);
}
