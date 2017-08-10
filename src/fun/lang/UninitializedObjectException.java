/* Fun
 *
 * $Id: UninitializedObjectException.java,v 1.4 2011/08/12 21:17:59 sthippo Exp $
 *
 * Copyright (c) 2003-2011 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

/**
 *  Exception thrown when an attempt is made to perform an operation on an
 *  object which has not been properly initialized.
 */
public class UninitializedObjectException extends IllegalArgumentException {

    private static final long serialVersionUID = 1L;

    public UninitializedObjectException() {
        super();
    }
    public UninitializedObjectException(String str) {
        super(str);
    }
}
