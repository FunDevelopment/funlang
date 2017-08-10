/* Fun
 *
 * $Id: Index.java,v 1.10 2014/05/21 13:21:00 sthippo Exp $
 *
 * Copyright (c) 2002-2015 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

import fun.runtime.Context;

/**
 * Base class for CollectionIndex and TableIndex classes; refers to a
 * location (offset or key) in a collection.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.10 $
 */
abstract public class Index extends AbstractNode {

    private boolean dynamic = false;

    public Index() {
        super();
    }

    public Index(Value value) {
        super();
        setChild(0, (AbstractNode) value);
    }

    /** Returns <code>false</code> */
    public boolean isPrimitive() {
        return false;
    }

    /** Returns <code>false</code> */
    public boolean isStatic() {
        return false;
    }

    /** Returns <code>false</code> */
    public boolean isDynamic() {
        return dynamic;
    }

    protected void setDynamic(boolean dynamic) {
        this.dynamic = dynamic;
    }

    /** Returns <code>false</code> */
    public boolean isDefinition() {
        return false;
    }

    public boolean isNumericIndex(Context context) {
        Value val = getIndexValue(context);
        Class<?> type = val.getValueClass();
        if (type == Byte.TYPE || type == Short.TYPE || type == Integer.TYPE || type == Long.TYPE || type == Character.TYPE ||
              type == Byte.class || type == Short.class || type == Integer.class || type == Long.class || type == Character.class) {

        	return true;
        } else {
        	return false;
        }
    }

    public Value getIndexValue(Context context) {
        FunNode node = getChild(0);
        if (node instanceof Value) {
            return (Value) node;
        } else {
            try {
                return ((ValueGenerator) node).getValue(context);
            } catch (Redirection r) {
                return new PrimitiveValue();
            }
        }
    }
    
    public Index instantiateIndex(Context context) {
        Index instantiatedIndex = createIndex();
        instantiatedIndex.setChild(0, (AbstractNode) getIndexValue(context));
        return instantiatedIndex;
    }
    
    public Index resolveIndex(Context context) {
        Index resolvedIndex = (Index) clone();
        AbstractNode node = (AbstractNode) resolvedIndex.getChild(0);
        if (node instanceof Instantiation) {
            try {
                node = AbstractConstruction.resolveInstance((Instantiation) node, context, false);
            } catch (Redirection r) {
                ;
            }
        }
        resolvedIndex.setChild(0, node);
        return resolvedIndex;
    }
    
    public String getModifierString(Context context) {
        String str = toString();
        
        // find loop parameters
        AbstractNode node = (AbstractNode) getChild(0);
        if (node instanceof Instantiation) {
            int kind = ((Instantiation) node).getKind();
            if (kind == Instantiation.FOR_PARAMETER || kind == Instantiation.FOR_PARAMETER_CHILD) {
                Context resolutionContext = ((node instanceof ResolvedInstance) ? ((ResolvedInstance)node).getResolutionContext() : context);
                str = str + "#" + resolutionContext.getLoopIndex();                  
            }
        }
        
        return str;
    }
    
    abstract protected Index createIndex(); 
    
    abstract public String toString();
}
