/* Fun Compiler and Runtime Engine
 * EmptyList.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
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
