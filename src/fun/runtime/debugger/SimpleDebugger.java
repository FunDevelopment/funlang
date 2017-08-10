/* Fun
 *
 * $Id: SimpleDebugger.java,v 1.2 2014/11/10 20:43:04 sthippo Exp $
 *
 * Copyright (c) 2010-2014 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.runtime.debugger;

import fun.lang.Chunk;
import fun.runtime.FunDebugger;
import fun.runtime.Context;

public class SimpleDebugger implements FunDebugger {
	
	private SimpleDebuggerFrame frame;
	
	public SimpleDebugger() {}

	public void constructed(Chunk chunk, Context context, Object data) {
	}

	public void getting(Chunk chunk, Context context) {
	}

	public void retrievedFromKeep(String name, Context context, Object data) {
	}

	public void close() {
	}

	public void setFocus() {
	}

}
