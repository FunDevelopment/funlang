/* Fun
 *
 * $Id: FunDebugger.java,v 1.2 2010/11/29 14:20:05 sthippo Exp $
 *
 * Copyright (c) 2010 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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


