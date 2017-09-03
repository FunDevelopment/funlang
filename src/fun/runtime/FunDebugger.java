/* Fun Compiler and Runtime Engine
 * FunDebugger.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.runtime;

import fun.lang.*;

/**
 * This interface defines a debugging api for Fun.  All of the methods in this
 * interface are callback methods, called by the Fun server before and after 
 * various steps in its operation.  
 */
public interface FunDebugger {
      public void getting(Chunk chunk, Context context);
      public void constructed(Chunk chunk, Context context, Object data);
      public void retrievedFromKeep(String name, Context context, Object data);

      public void setFocus();
      public void close();
}


