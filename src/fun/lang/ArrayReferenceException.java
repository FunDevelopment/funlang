/* Fun
 *
 * $Id: ArrayReferenceException.java,v 1.4 2011/08/29 19:29:58 sthippo Exp $
 *
 * Copyright (c) 2002-2011 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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
