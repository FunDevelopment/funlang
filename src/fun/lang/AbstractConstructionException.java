/* Fun
 *
 * $Id: AbstractConstructionException.java,v 1.4 2011/08/12 21:17:59 sthippo Exp $
 *
 * Copyright (c) 2002-2011 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

/**
 *  Exception thrown when an attempt is made to instantiate an abstract
 *  definition.
 */
public class AbstractConstructionException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public AbstractConstructionException() {
        super();
    }
    public AbstractConstructionException(String str) {
        super(str);
    }
}
