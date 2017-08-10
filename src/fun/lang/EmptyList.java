/* Fun
 *
 * $Id: EmptyList.java,v 1.4 2011/08/12 21:17:59 sthippo Exp $
 *
 * Copyright (c) 2002-2011 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

import java.util.*;

/**
 * EmptyList is an implementation of List with no elements.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.4 $
 */

public class EmptyList<E> extends AbstractList<E> {

    public EmptyList() {
    }

    public int size() {
        return 0;
    }

    public E get(int index) {
        throw new IndexOutOfBoundsException("this list is empty");
    }
}
