package fun.compiler.visitor;

import java.util.Iterator;

import fun.lang.AbstractNode;

abstract public class FunCompilerVisitor {
    abstract public void visit( AbstractNode target );
    public boolean done() {
        return false;
    }
    
    public void traverse( AbstractNode n ) {
        traverse( n.getChildren() );
    }
    
    void traverse( Iterator i ) {
        while ( i.hasNext() ) {
            if ( done() ) {
                return;
            }
            AbstractNode n = (AbstractNode)i.next();
            visit( n );
            traverse( n.getChildren() );
        }
    }
}
