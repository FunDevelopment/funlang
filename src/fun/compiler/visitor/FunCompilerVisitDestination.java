package fun.compiler.visitor;

import fun.lang.AbstractNode;

public class FunCompilerVisitDestination {
    
    public void visit( FunCompilerVisitor visitor ) {
        visitor.visit( (AbstractNode)this );
    }

}
