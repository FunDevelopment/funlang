/* Fun
 *
 * $Id: element_decorator.java,v 1.2 2012/04/18 18:26:46 sthippo Exp $
 *
 * Copyright (c) 2012 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

/**
 * When collections are instantiated, an site may want control over how
 * the individual elements are presented -- for instance, whether they 
 * are quoted or not.  This interface corresponds to the Fun definition
 * that specifies such a decorator.
 */
public interface element_decorator {

    /** Decorate a collection element. **/
    public String decorate_element(Object data);
}


