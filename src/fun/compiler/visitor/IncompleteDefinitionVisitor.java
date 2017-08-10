package fun.compiler.visitor;

import fun.lang.AbstractNode;
import fun.lang.NullValue;

public class IncompleteDefinitionVisitor extends FunCompilerVisitor {

    boolean foundIncompleteDefinition = false;

    public void visit( AbstractNode target ) {
        if ( target instanceof NullValue ) {
            NullValue nvTarget = (NullValue)target;
            foundIncompleteDefinition = nvTarget.isAbstract(null);
        }
    }
    
    public boolean isIncomplete() {
        return foundIncompleteDefinition;
    }

}
