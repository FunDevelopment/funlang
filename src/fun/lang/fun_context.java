/* Fun Compiler and Runtime Engine
 * fun_context.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import fun.runtime.Context;

import java.util.List;



/**
 * This interface corresponds to the fun_context object, defined in core and representing
 * a Fun construction context, which can be used to construct objects.
 */
public interface fun_context {

    /** Returns the name of the site at the top of this context. **/
    public String site_name();

    /** Returns the cached value, if any, for a particular name in this context. **/
    public Object get(String name) throws Redirection;

    /** Sets the cached value, if any, for a particular name in this context. **/
    public void put(String name, Object data) throws Redirection;

    /** Constructs a Fun object of a particular name.  **/
    public Object construct(String name) throws Redirection;

    /** Constructs a Fun object of a particular name, passing in particular arguments.  **/
    public Object construct(String name, List<Construction> args) throws Redirection;

    /** Returns the context associated with the container of the current context. **/
    public fun_context container_context() throws Redirection;
    
    /** Returns the internal context object corresponding to this context. **/
    public Context getContext();
}


