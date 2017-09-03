/* Fun Compiler and Runtime Engine
 * element_decorator.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
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


