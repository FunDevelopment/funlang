/* Fun
 *
 * $Id: FunTable.java,v 1.3 2005/06/30 04:20:53 sthippo Exp $
 *
 * Copyright (c) 2002-2005 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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
