/* Fun Compiler and Runtime Engine
 * ArrayReferenceException.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

/**
 *  Exception thrown on illegal array references (for example, a reference to
 *  a non-array object with an array index)
 */
public class ArrayReferenceException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public ArrayReferenceException() {
        super();
    }
    public ArrayReferenceException(String str) {
        super(str);
    }
}
