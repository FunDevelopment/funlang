/* Fun Compiler and Runtime Engine
 * FunStandaloneServer.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.runtime;

/**
 * Interface for standalone Fun-programmable HTTP server
 *
 * This allows FunServer to avoid a dependency on a specifig implementation (e.g. Jetty)
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.4 $
 */

public interface FunStandaloneServer {

	public void setServer(FunServer funServer);

	public void startServer() throws Exception;

    public void stopServer() throws Exception;
    
    public boolean isRunning();

    /** Gets the setting of the files first option.  If true, the server looks for
     *  files before fun objects to satisfy a request.  If false, the server looks
     *  for fun objects first, and looks for files only when no suitable object by the
     *  requested name exists.
     */
    public boolean getFilesFirst();

    /** Set the files first option.  If this flag is present, then the server looks for
     *  files before fun objects to satisfy a request.  If not present, the server looks
     *  for fun objects first, and looks for files only when no suitable object by the
     *  requested name exists.
     */
    public void setFilesFirst(boolean filesFirst);

    /** Gets the optional virtual host name.
     */
    public String getVirtualHost();

    /** Sets the optional virtual host name.
     */
    public void setVirtualHost(String virtualHost);


}
