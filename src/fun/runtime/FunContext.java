/* Fun
 *
 * $Id: FunContext.java,v 1.19 2014/12/31 14:03:17 sthippo Exp $
 *
 * Copyright (c) 2003-2015 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.runtime;

import java.util.List;
import java.util.Map;

import fun.lang.ArgumentList;
import fun.lang.ComplexName;
import fun.lang.Construction;
import fun.lang.Definition;
import fun.lang.Instantiation;
import fun.lang.NameNode;
import fun.lang.Redirection;
import fun.lang.Site;
import fun.lang.fun_context;

/**
 * This object wraps a Context and implements a Fun fun_context object, defined in core and representing
 * a Fun construction context, which can be used to construct objects.
 */
public class FunContext implements fun_context {

    /** Returns the internal context object associated with this context. **/
    private Context context;
    private Site site;
    private boolean initialized;
    private boolean inUse = false;

    public FunContext(FunDomain funSite) {
        site = (Site) funSite.getMainOwner();
        context = funSite.getNewContext();
        initialized = true;
    }
 
    public FunContext(Site site, Context context) {
        this.site = site;
        this.context = context;
        initialized = false;
    }
    
    public FunContext(FunContext funContext) {
        site = funContext.site;
        context = new Context(funContext.context, false);
        context.setTop(context.getRootEntry());
        initialized = true;
    }
    
    private void init() {
        initialized = true;
        context = new Context(context, false);
    }
    
    public boolean isInUse() {
        return inUse;
    }
    
    public void setInUse(boolean inUse) {
        this.inUse = inUse;
    }
    
    /** Returns the name of the site at the top of this context. **/
    public String site_name() {
        return site.getName();
    }
    
    /** Returns the cached value, if any, for a particular name in this context. **/
    public Object get(String name) throws Redirection {
        if (!initialized) {
            init();
        }
        return context.getData(null, name, null, null);
    }

    /** Sets the cached value, if any, for a particular name in this context. **/
    public void put(String name, Object data) throws Redirection {
        if (!initialized) {
            init();
        }
        // find the definition if any corresponding to this name
        Instantiation instance = new Instantiation(new NameNode(name), context.peek().def);
        Definition def = instance.getDefinition(context);
        
        context.putData(def, null, null, name, data);
    }

    /** Constructs a Fun object of a particular name.  **/
    public Object construct(String name) throws Redirection {
        return construct(name, null);
    }

    /** Constructs a Fun object of a particular name, passing in particular arguments.  **/
    public Object construct(String name, List<Construction> args) throws Redirection {
        if (!initialized) {
            init();
        }
        NameNode nameNode = (name.indexOf('.') > 0 ? new ComplexName(name) : new NameNode(name));
        Instantiation instance;
        if (args != null) {
            ArgumentList argList = (args instanceof ArgumentList ? (ArgumentList) args : new ArgumentList(args));
            instance = new Instantiation(nameNode, argList, null, context.peek().def);
        } else {
            instance = new Instantiation(nameNode, context.peek().def);
        }
        return instance.getData(context);
    }
    
    public FunContext container_context() {
        if (context.size() <= 1) {
            return null;
        }
        context.unpush();            
        try {
            FunContext containerContext = new FunContext(site, context);
            // force the copy before unpopping
            containerContext.init();
            return containerContext;
        } finally {
            context.repush();
        }        
    }

    public Object get(Definition def) throws Redirection {
        return def.get(getContext());
    }

    public Object get(Definition def, ArgumentList args) throws Redirection {
        return def.get(getContext(), args);
    }

    public List<Object> get_array(Definition def) throws Redirection {
        return def.get_array(getContext());
    }
    
    public Map<String, Object> get_table(Definition def) throws Redirection {
        return def.get_table(getContext());
    }

    
    
    /** Returns the internal context object associated with this context. **/
    public Context getContext() {
        // don't return the uninitialized context, to prevent it being altered
        if (!initialized) {
            init();
        }
        return context;
    }
    
    public String toString() {
        return context.toHTML();
    }
}


