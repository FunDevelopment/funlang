/* Fun Compiler and Runtime Engine
 * SimpleDebugger.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
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
