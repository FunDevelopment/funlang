/* Fun Compiler and Runtime Engine
 * FunServer.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.runtime;

import fun.lang.*;
import fun.parser.Node;

import java.io.*;
import java.net.InetAddress;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Standalone Fun-programmable HTTP server
 *
 * This HTTP server is based on the Jetty HTTP server.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.83 $
 */

public class FunServer extends HttpServlet implements FunProcessor {
    private static final long serialVersionUID = 1L;

    public static final String NAME = "FunServer";
    public static final String MAJOR_VERSION = "1.0";
    public static final String MINOR_VERSION = "0";
    public static final String VERSION = MAJOR_VERSION + "." + MINOR_VERSION;
    public static final String NAME_AND_VERSION = NAME + " " + VERSION;

    public static final String REQUEST_STATE_ATTRIBUTE = "fun_request_state";

    /** Status codes **/
    
    public static final int OK = 200;
    public static final int NO_CONTENT = 204;
    public static final int BAD_REQUEST = 400;
    public static final int NOT_FOUND = 404;
    public static final int SERVER_ERROR = 500;
    public static final int TIMEOUT = 504;
    
    
    /** This enum signifies the stage in the lifecycle of the request 
     *  containing it.
     */
     
    public enum RequestState
    {
        STARTING,
        STARTED,
        COMPLETE,
        ERROR,
        EXPIRED
    }
    
    public static final String SERVER_STARTED = "STARTED";
    public static final String SERVER_STOPPED = "STOPPED";
    public static final String SERVER_FAILED = "FAILED";
    
    protected Exception exception = null;
    protected FunSite mainSite = null;
    protected Map<String, FunSite> sites = new HashMap<String, FunSite>();
    protected ServletContext servletContext = null;

    private String siteName = null;
    private String virtualHost = null;
    private String address = null;
    private String port = null;
    private boolean initedOk = false;
    private String stateFileName = null;
    private String logFileName = null;
    private boolean appendToLog = true;
    private PrintStream log = null;
    private String fileBase = ".";
    private boolean filesFirst = false;
    private boolean multithreaded = false;
    private String funPath = ".";
    private boolean recursive = false;
    private boolean customCore = false;
    private boolean shareCore = false;
    private Core sharedCore = null;
    private boolean debuggingEnabled = false;
    private HashMap<String, Object> properties = new HashMap<String, Object>();
    protected String fileHandlerName = null;
    private String contextPath = "";
    private long asyncTimeout = 0l;

    private FunStandaloneServer standaloneServer = null;
    private HashMap<String, FunServer> serverMap = new HashMap<String, FunServer>();
    private List<FunServerRunner> pendingServerRunners = null;
    private List<FunServerRunner> activeServerRunners = null;
    
    /** Main entry point, if FunServer is run as a standalone application.  The following
     *  flags are recognized (in any order).  All flags are optional.
     *  <table><tr><th>argument</th><th>default</th><th>effect</th></tr><tr>
     *
     *  <td>  -site <name>                    </td><td>  name defined elsewhere </td><td> Specifies the site name.  If present, this must correspond to the name of a site
     *                                                                                    defined in the fun code.  If not present, the site name must be defined
     *                                                                                    elsewhere, e.g. in site_config.fun. </td>
     *  <td>  -a <address>[:<port>]           </td><td>  localhost:80           </td><td> Sets the address and port which the server listens on.  </td>
     *  <td>  -p <port>                       </td><td>  80                     </td><td> Sets the port which the server listens on.  </td>
     *  <td>  -host <virtual host name>       </td><td>  all local hosts        </td><td> Name of virtual host.  </td>
     *  <td>  -filesfirst                     </td><td>  files last             </td><td> Files first option.  If this flag is present, then the server will look for
     *                                                                                    files before fun objects to satisfy a request. </td>
     *  <td>  -docbase <path or url>          </td><td>  current directory      </td><td> Base location for documents.  When a file needs to be retrieved, it is located
     *                                                                                    relative to this path or URL. </td>
     *  <td>  -funpath <path>[<sep><path>]* </td><td>  current directory      </td><td> Sets the initial funpath, which is a string of pathnames separated by the
     *                                                                                    platform-specific path separator character (e.g., colon on Unix and semicolon
     *                                                                                    on Windows).  Pathnames may specify either files or directories.  At startup,
     *                                                                                    for each pathname, the Fun server loads either the indicated file (if the
     *                                                                                    pathname specifies a file) or all the files with a .fun extension in the
     *                                                                                    indicated directory (if the pathname specifies a directory).
     *  <td>  -multithreaded                  </td><td>  not multithreaded      </td><td> Multithreaded compilation.  If this flag is present, then fun
     *                                                                                    files are compiled in independent threads.  </td>
     *  <td>  -recursive                      </td><td>  not recursive          </td><td> Recursive funpath option.  </td>
     *  <td>  -log <path>                     </td><td>  no logging             </td><td> All output messages are logged in the specified file.  The file is overwritten
     *                                                                                    if it already exists.  </td>
     *  <td>  -log.append <path>              </td><td>  no logging             </td><td> All output messages are logged in the specified file.  If the file exists, the
     *                                                                                    current content is preserved, and messages are appended to the end of the file.  </td>
     *  <td>  -verbose                        </td><td>  not verbose            </td><td> Verbose output messages for debugging.  </td>.
     *  <td>  -debug                          </td><td>  debugging not enabled  </td><td> Enable the built-in debugger.  </td>.
     *
     */
    public static void main(String[] args) {

        boolean noProblems = true;
        
        Map<String, String> initParams = paramsFromArgs(args);
        
        String problems = initParams.get("problems");
        if (problems != null && !problems.equals("0")) {
            noProblems = false;
        }
        
        if (noProblems) {
            FunServer server = new FunServer(initParams);
            if (server.initedOk) {
                try {
                    server.startServer();
                    
                } catch (Exception e) {
                    noProblems = false;
                }
            } else {
                noProblems = false;
            }
            if (server.exception != null) {
                noProblems = false;
            }
            
        } else {
            System.out.println("Usage:");
            System.out.println("          java -jar fun.jar [flags]\n");
            System.out.println("where the optional flags are among the following (in any order):\n");
            System.out.println("Flag                           Effect");
            System.out.println("----------------------------------------------------------------------------");
            System.out.println("-s, --site <name>              Specifies the site name.  If present, this must");
            System.out.println("                               correspond to the name of a site defined in the");
            System.out.println("                               fun code.  If not present, the site name must");
            System.out.println("                               be defined elsewhere, e.g. in site_config.fun.\n");
            System.out.println("-a, --address <addr>[:<port>]  Sets the address and port which the server");
            System.out.println("                               listens on.\n");
            System.out.println("-p, --port <port>              Sets the port which the server listens on.\n");
            System.out.println("-h, --host <hostname>          Name of virtual host; if not present, all local");
            System.out.println("                               hosts are handled.\n");
            System.out.println("-t, --timeout <millisecs>      Sets the length of time the server must process");
            System.out.println("                               a request by before returning a timeout error.");
            System.out.println("                               A zero or negative value means the request will");
            System.out.println("                               never time out.  The default value is zero.\n");
            System.out.println("-ff, --filesfirst              Files first option.  If this flag is present,");
            System.out.println("                               then the server looks for files before fun");
            System.out.println("                               objects to satisfy a request.  If not present,");
            System.out.println("                               the server looks for fun objects first, and");
            System.out.println("                               looks for files only when no suitable object by");
            System.out.println("                               the requested name exists.\n");
            System.out.println("--filebase <path or url>       Base location for documents.  When a file needs");
            System.out.println("                               to be retrieved, the server looks for it");
            System.out.println("                               relative to this path or URL.  If this flag is");
            System.out.println("                               not present, the docbase defaults to the current");
            System.out.println("                               directory.\n");
            System.out.println("-bp, --funpath <pathnames>   Sets the initial funpath, which is a string");
            System.out.println("                               of pathnames separated by the platform-specific");
            System.out.println("                               path separator character (e.g., colon on Unix");
            System.out.println("                               and semicolon on Windows).  Pathnames may");
            System.out.println("                               specify either files or directories.  At");
            System.out.println("                               startup, for each pathname, the Fun server");
            System.out.println("                               loads either the indicated file (if the pathname");
            System.out.println("                               specifies a file) or all the files with a .fun");
            System.out.println("                               extension in the indicated directory (if the");
            System.out.println("                               pathname specifies a directory).\n");
            System.out.println("-r, --recursive                Recursive funpath option.\n");
            System.out.println("-m, --multithreaded            Multithreaded compilation.  If this flag is");
            System.out.println("                               present, then fun files are compiled in");
            System.out.println("                               independent threads.\n");
            System.out.println("-cc, --customcore              Custom core definitions supplied in funpath;");
            System.out.println("                               core files will not be autoloaded from");
            System.out.println("                               fun.jar.\n");
            System.out.println("-sc, --sharecore               All sites should share a single core, supplied");
            System.out.println("                               by the first site loaded.\n");
            System.out.println("-sf, --statefile <filename>    Instructs the server to write state intormation");
            System.out.println("                               to a file.\n");
            System.out.println("-l, --log <path>               All output messages are logged in the specified");
            System.out.println("                               file.  The file is overwritten if it already");
            System.out.println("                               exists.\n");
            System.out.println("-la, --log.append <path>       All output messages are logged in the specified");
            System.out.println("                               file.  If the file exists, the current content");
            System.out.println("                               is preserved, and messages are appended to the");
            System.out.println("                               end of the file./n");
            System.out.println("-v, --verbose                  Verbose output messages for debugging.\n");
            System.out.println("--debug                       Enable the built-in debugger.\n");
            System.out.println("-?                           This screen.\n\n");
            System.out.println("Flags may be abbreviated to their initial letters, e.g. -a instead of -address,");
            System.out.println("or -la instead of -log.append.\n");
        }
    }

    /** Constructor used when Fun is run as a standalone server */
    public FunServer(Map<String, String> initParams) {
        initedOk = init(initParams);
    }
    
    /** Constructor used when Fun is run as a servlet */
    protected FunServer() {
        initedOk = false;   // force initialization in servlet init function
    }

    private static Map<String, String> paramsFromArgs(String[] args) {
        Map<String, String> initParams = new HashMap<String, String>();
        int numProblems = 0;
        for (int i = 0; i < args.length; i++) {
            String arg = args[i];
            String nextArg = (i + 1 < args.length ? args[i + 1] : null);
            boolean noNextArg = (nextArg == null || nextArg.startsWith("-"));
            if (arg.equals("--site") || arg.equals("-s")) {
                if (noNextArg) {
                    numProblems++;
                    String msg = "site name not provided";
                    initParams.put("problem" + numProblems, msg);
                    i++;
                } else {
                    initParams.put("site", nextArg);
                }

            } else if (arg.equals("--address") || arg.equals("-a")) {
                if (noNextArg) {
                    numProblems++;
                    String msg = "address not provided";
                    initParams.put("problem" + numProblems, msg);
                } else {
                    initParams.put("address", nextArg);
                    i++;
                }

            } else if (arg.equals("--port") || arg.equals("-p")) {
                if (noNextArg) {
                    numProblems++;
                    String msg = "port not provided";
                    initParams.put("problem" + numProblems, msg);
                } else {
                    initParams.put("port", nextArg);
                    i++;
                }

            } else if (arg.equals("--host") || arg.equals("-h")) {
                if (noNextArg) {
                    numProblems++;
                    String msg = "host not provided";
                    initParams.put("problem" + numProblems, msg);
                } else {
                    initParams.put("host", nextArg);
                    i++;
                }

            } else if (arg.equals("--timeout") || arg.equals("-t")) {
                if (noNextArg) {
                    numProblems++;
                    String msg = "timeout value not provided";
                    initParams.put("problem" + numProblems, msg);
                } else {
                    initParams.put("timeout", nextArg);
                    i++;
                }

            } else if (arg.equals("--filebase") || arg.equals("--docbase")) {
                if (noNextArg) {
                    numProblems++;
                    String msg = "filebase not provided";
                    initParams.put("problem" + numProblems, msg);
                } else {
                    initParams.put("filebase", nextArg);
                    i++;
                }

            } else if (arg.equals("--filesfirst") || arg.equals("-ff")) {
                initParams.put("filesfirst", "true");

            } else if (arg.equals("--funpath") || arg.equals("-bp")) {
                if (noNextArg) {
                    numProblems++;
                    String msg = "funpath not provided";
                    initParams.put("problem" + numProblems, msg);
                } else {
                    initParams.put("funpath", nextArg);
                    i++;
                }

            } else if (arg.equals("--recursive") || arg.equals("-r")) {
                initParams.put("recursive", "true");

            } else if (arg.equals("--multithreaded") || arg.equals("-m")) {
                initParams.put("multithreaded", "true");

            } else if (arg.equals("--customcore") || arg.equals("-cc")) {
                initParams.put("customcore", "true");

            } else if (arg.equals("--sharecore") || arg.equals("-sc")) {
                initParams.put("sharecore", "true");

            } else if (arg.equals("--statefile") || arg.equals("-sf")) {
                if (noNextArg) {
                    numProblems++;
                    String msg = "state filename not provided";
                    initParams.put("problem" + numProblems, msg);
                } else {
                    initParams.put("statefile", nextArg);
                    i++;
                }

            } else if (arg.equals("--log") || arg.equals("-l")) {
                if (noNextArg) {
                    numProblems++;
                    String msg = "log file not provided";
                    initParams.put("problem" + numProblems, msg);
                } else {
                    initParams.put("log", nextArg);
                    i++;
                }

            } else if (arg.equals("--log.append") || arg.equals("-la")) {
                if (noNextArg) {
                    numProblems++;
                    String msg = "log.append file not provided";
                    initParams.put("problem" + numProblems, msg);
                } else {
                    initParams.put("log", nextArg);
                    initParams.put("log.append", "true");
                    i++;
                }

            } else if (arg.equals("--verbose") || arg.equals("-v")) {
                initParams.put("verbose", "true");

            } else if (arg.equals("--debug")) {
                initParams.put("debug", "true");

            } else {
                numProblems++;
                String msg = "unrecognized option: " + arg;
                initParams.put("problem" + numProblems, msg);
            }
        }
        initParams.put("problems", Integer.toString(numProblems));
        
        return initParams;
    }
       
    private boolean init(Map<String, String> initParams) {
        try {    
            initGlobalSettings(initParams);
        } catch (Exception e) {
            exception = e;
            return false;
        }
        return true;
    }

    private static FunServerRunner launchServer(Map<String, String> params) {
        FunServer server = new FunServer(params);
        if (server.initedOk) {
            return new FunServerRunner(server);
        }
        return null;
    }

    /** Launches a new Fun server, initialized with the passed parameters, unless a server
     *  with the passed name has been launched already.
     */
    public fun_server launch_server(String name, Map<String, String> params) {
        FunServer server = serverMap.get(name);
        if (server == null) {
            return handleLaunch(name, params);
        }
        return server;
    }
    
    public fun_server relaunch_server(String name, Map<String, String> params) {
        FunServer server = serverMap.get(name);
        if (server != null) {
            server.stopServer();
        }
        return handleLaunch(name, params);
    }        
        
    private fun_server handleLaunch(String name, Map<String, String> params) {
        FunServerRunner runner = launchServer(params);
        FunServer server = runner.getServer();
        serverMap.put(name, server);
        if (pendingServerRunners == null) {
            pendingServerRunners = new ArrayList<FunServerRunner>();
        }
        pendingServerRunners.add(runner);
        return server;
    }
    
    public fun_server get_server(String name) {
        return serverMap.get(name);
    }
    
    protected void initGlobalSettings(Map<String, String> initParams) throws Exception {

        String param;
        
        param = initParams.get("verbose");
        if ("true".equalsIgnoreCase(param)) {
            SiteBuilder.verbosity = SiteBuilder.VERBOSE;
        }

        siteName = initParams.get("site");
        if (siteName == null) {
            siteName = fun.lang.Name.DEFAULT;
        }

        address = initParams.get("address");
        port = initParams.get("port");
        String timeout = initParams.get("timeout");
        if (timeout != null) {
            asyncTimeout = Long.parseLong(timeout);
        } else {
            asyncTimeout = 0L;
        }
        
        stateFileName = initParams.get("statefile");
        
        logFileName = initParams.get("log");
        String appendLog = initParams.get("log.append");
        appendToLog = isTrue(appendLog);
        if (logFileName != null) {
            SiteBuilder.setLogFile(logFileName, appendToLog);
        }

        funPath = initParams.get("funpath");
        if (funPath == null) {
            funPath = ".";
        }

        fileBase = initParams.get("filebase");
        if (fileBase == null) {
            fileBase = ".";
        }

        recursive = isTrue(initParams.get("recursive"));
        multithreaded = isTrue(initParams.get("multithreaded"));
        shareCore = isTrue(initParams.get("sharecore"));
        filesFirst = isTrue(initParams.get("filesfirst"));
        fileHandlerName = initParams.get("filehandler");
        debuggingEnabled = isTrue(initParams.get("debug"));
    }

    /** Returns true if the passed string is a valid servlet parameter representation
     *  of true.
     */
    private static boolean isTrue(String param) {
        return ("true".equalsIgnoreCase(param) || "yes".equalsIgnoreCase(param) || "1".equalsIgnoreCase(param));
    }

    public void recordState(String state) {
        if (stateFileName != null) {
            try {
                PrintStream ps = new PrintStream(new FileOutputStream(stateFileName, false));
                Date now = new Date();
                ps.println(state + " " + now.toString());
                ps.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    
    private void startServer() {
        try {
            loadSite();

            Class<?> serverClass = Class.forName("fun.runtime.FunJettyServer");
            standaloneServer = (FunStandaloneServer) serverClass.newInstance();
            
            standaloneServer.setServer(this);
            standaloneServer.setFilesFirst(filesFirst);
            standaloneServer.setVirtualHost(virtualHost);
            
            standaloneServer.startServer();
            
        } catch (Exception e) {
            recordState("FAILED");

            System.err.println("Exception starting FunServer: " + e);
            exception = e;
            e.printStackTrace(System.err);
        }
    }
    
    private void stopServer() {
        if (standaloneServer == null) {
            System.err.println("Unable to stop server; server doesn't exist");
            return;
        }
        try {
            standaloneServer.stopServer();
        } catch (Exception e) {
            System.err.println("Exception stopping FunServer: " + e);
            exception = e;
            e.printStackTrace(System.err);
        }
    }
        
    protected void loadSite() throws Exception {    
        // Load and compile the fun code
        mainSite = load(siteName, funPath, recursive);
        if (mainSite == null) {
            System.err.println("Unable to load site " + siteName + "; FunServer not started.");
            return;
        } else if (mainSite.getException() != null) {
            throw mainSite.getException(); 
        }
        mainSite.siteInit();
        siteName = mainSite.getName();

        mainSite.addExternalObject(contextPath, "context_path", null);
        
        if (mainSite.isDefined("file_base")) {
            String newFileBase = mainSite.getProperty("file_base", "");
            if (!fileBase.equals(newFileBase)) {
                fileBase = newFileBase;
                slog("file_base set by site to " + fileBase);
            }
        } else {
            slog("file_base not set by site.");
            mainSite.addExternalObject(fileBase, "file_base", null);
        }
        if (mainSite.isDefined("files_first")) {
            boolean newFilesFirst = mainSite.getBooleanProperty("files_first");
            if (newFilesFirst ^ filesFirst) {
                filesFirst = newFilesFirst;
                slog("files_first set by site to " + filesFirst);
            }
        } else {
            slog("files_first not set by site.");
            mainSite.addExternalObject(new Boolean(filesFirst), "files_first", "boolean");
        }
        if (mainSite.isDefined("share_core")) {
            shareCore = mainSite.getBooleanProperty("share_core");
        }

        if (shareCore) {
            sharedCore = mainSite.getCore();
        }
        Object[] all_sites = mainSite.getPropertyArray("all_sites");
        if (all_sites != null && all_sites.length > 0) {
            for (int i = 0; i < all_sites.length; i++) {
                site_config sc = new site_config_wrapper((FunObjectWrapper) all_sites[i]);
                String nm = sc.name();
                if (nm.equals(siteName)) {
                    continue;
                }
                String bp = null;
                if (shareCore) {
                    bp = sc.sitepath();
                }
                if (bp == null || bp.length() == 0) {
                    bp = sc.funpath();
                }
                boolean r = sc.recursive();
                FunSite s = load(nm, bp, r);
                sites.put(nm, s);
            }
            
            // have to relink to catch intersite references
            SiteBuilder.log("--- SUPERLINK PASS ---");
            link(mainSite.getParseResults());
            Iterator<FunSite> it = sites.values().iterator();
            while (it.hasNext()) {
                link(it.next().getParseResults());
            }
        }

        String showAddress = getNominalAddress();
        slog("             site = " + (siteName == null ? "(no name)" : siteName));
        slog("             funpath = " + funPath);
        slog("             recursive = " + recursive);
        slog("             state file = " + (stateFileName == null ? "(none)" : stateFileName));
        slog("             log file = " + SiteBuilder.getLogFile());
        slog("             multithreaded = " + multithreaded);
        slog("             autoloadcore = " + !customCore);
        slog("             sharecore = " + shareCore);
        slog("             current directory = " + (new File(".")).getAbsolutePath());
        slog("             files_first = " + filesFirst);
        slog("             file_base = " + fileBase);
        slog("             address = " + showAddress + (port == null ? "" : (":" + port)));
        slog("             timeout = " + (asyncTimeout > 0 ? Long.toString(asyncTimeout) : "none"));
        slog("             debuggingEnabled = " + debuggingEnabled);
        slog("Site " + siteName + " launched at " + (new Date()).toString());
    }


    /** Returns the server address used to identify this server to other
     *  servers.
     */
    public String nominal_address() {
        return getNominalAddress();
    }
    
    String getNominalAddress() {
        String showAddress = address;
        if (showAddress == null) {        
            Object serverAddr[] = mainSite.getPropertyArray("listen_to");
            if (serverAddr != null && serverAddr.length > 0) {
                for (int i = 0; i < serverAddr.length; i++) {
                    String addr = serverAddr[i].toString();
                    if (showAddress == null) {
                        showAddress = addr;
                    } else {
                        showAddress = showAddress + ", " + addr;
                    }
                }
            }
        }
        return showAddress;
    }
    
    
    static void link(Node[] parseResults) {
        for (int i = 0; i < parseResults.length; i++) {
            parseResults[i].jjtAccept(new SiteLoader.Linker(true), null);
        }
    }

    //
    // FunProcessor interface
    //

    /** Returns the name of this processor. **/
    public String name() {
        return NAME;
    }

    /** The highest Fun version number supported by this processor. **/
    public String version() {
        return VERSION;
    }

    public FunSite getMainSite () {
        return mainSite;
    }
    
    public Map<String, FunSite> getSiteMap() {
        return sites;
    }
    
    /** Properties associated with this processor. **/
    public Map<String, Object> props() {
        return properties;
    }

    String getSpecifiedAddress() {
        if (address != null && port != null) {
            return address + ":" + port;
        } else {
            return address;
        }
    }
  
    /** Compile the Fun source files found at the locations specified in <code>funpath</code>
     *  and return a FunDomain object.  If a location is a directory and <code>recursive</code>
     *  is true, scan subdirectories recursively for Fun source files.  If <code>autoloadCore</code>
     *  is true, and the core definitions required by the system cannot be found in the files
     *  specified in <code>funpath</code>, the processor will attempt to load the core
     *  definitions automatically from a known source (e.g. from the same jar file that the
     *  processor was loaded from).
     */
    public fun_domain compile(String siteName, String funpath, boolean recursive, boolean autoloadCore) {
        FunSite site = new FunSite(siteName, this);
        site.load(funpath, "*.fun", recursive, multithreaded, autoloadCore, sharedCore);
        return site;
    }

    /** Compile Fun source code passed in as a string and return a fun_domain object.  If
     *  <code>autoloadCore</code> is true, and the core definitions required by the system cannot
     *  be found in the files specified in <code>funpath</code>, the processor will attempt to
     *  load the core definitions automatically from a known source (e.g. from the same jar file
     *  that the processor was loaded from).
     */
    public fun_domain compile(String siteName, String funtext, boolean autoloadCore) {
        return null;
    }

    /** Compile Fun source code passed in as a string and merge the result into the specified
     *  fun_domain.  If there is a fatal error in the code, the result is not merged and
     *  a Redirection is thrown.
     */
    public void compile_into(fun_domain domain, String funtext) throws Redirection {
        ;
    }

    /** Load the site files */
    public FunSite load(String sitename, String funPath, boolean recurse) throws Exception {
        FunSite site = null;

        slog(NAME_AND_VERSION);
        slog("Loading site " + (sitename == null ? "(no name yet)" : sitename));
        site = (FunSite) compile(sitename, funPath, recurse, !customCore);
        Exception e = site.getException();
        if (e != null) {
            slog("Exception loading site " + site.getName() + ": " + e);
            throw e;
        }
        return site;
    }

    public String getFunPath() {
        return funPath;
    }
    
    /** Returns true if this server was successfully started and has not yet been stopped. */
    public boolean is_running() {
        return (standaloneServer != null && standaloneServer.isRunning());
    }
    
    /** Gets the setting of the files first option.  If true, the server looks for
     *  files before fun objects to satisfy a request.  If false, the server looks
     *  for fun objects first, and looks for files only when no suitable object by the
     *  requested name exists.
     */
    public boolean files_first() {
        return filesFirst;
    }

    /** Set the files first option.  If this flag is present, then the server looks for
     *  files before fun objects to satisfy a request.  If not present, the server looks
     *  for fun objects first, and looks for files only when no suitable object by the
     *  requested name exists.
     */
    public void setFilesFirst(boolean filesFirst) {
        this.filesFirst = filesFirst;
    }

    /** Returns the base directory on the local system where this server accesses data
     *  files.  File names in requests are relative to this directory.
     */
    public String file_base() {
        return fileBase;
    }

    /** Sets the base directory where the server should read and write files. **/
    public void setFileBase(String fileBase) {
        this.fileBase = fileBase;
    }


    /** Returns the URL prefix that this server uses to filter requests.  This allows
     *  an HTTP server to dispatch requests among multiple Fun servers, using the
     *  first part of the URL to differentiate among them.
     *
     *  If null, this server accepts all requests.
     */
    public String base_url() {
        return null;
    }

    public Map<String, String> site_paths() {
        return new HashMap<String, String>(0);
    }

    public String domain_type() {
        return Name.SITE;
    }
    
    
    /** Writes to log file and system out. **/
    static void slog(String msg) {
        SiteBuilder.log(msg);
        // avoid redundant echo
        if (!SiteBuilder.echoSystemOut) {
            System.out.println(msg);
        }
    }


    /**Clean up resources*/
    public void destroy() {
        if (log != null) {
            log.close();
        }
    }

    public void setSites(FunSite mainSite, Map<String, FunSite> sites) {
        this.mainSite = mainSite;
        this.sites = sites;
    }

    public boolean addSite(FunSite site) {
        String siteName = site.getName();
        if (sites.get(siteName) == null) {
            slog("FunServer.addSite(" + siteName + ")");
            sites.put(siteName, site);
            return true;
        } else {
            return false;
        }
    }
    
    public void removeSite(FunSite site) {
        FunSite existingSite = (FunSite) sites.get(site.getName());
        if (existingSite != null && existingSite.equals(site)) {
            sites.put(site.getName(), null);
        }
    }
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servletContext = config.getServletContext();
        contextPath = servletContext.getContextPath();
    }
    
    private String newSessionId() {
        String hostname = null;
        if (virtualHost != null) {
            hostname = virtualHost;
        } else {
            try {
                InetAddress addr = InetAddress.getLocalHost();
                byte[] ipAddr = addr.getAddress();
                hostname = addr.getHostName();
            } catch (Exception e) {
                ;
            }
            if (hostname == null) {
                hostname = getNominalAddress();
                if (hostname == null) {
                    hostname = "--";                    
                }
            }
        }
        String uniqueString = getUniqueString();
        String id = siteName + ":" + hostname + ":" + uniqueString;
        slog("creating new session id: " + id);
        return id;
    }
    
    /** Request data from the server.  **/
    public String get(Context context, String requestName) throws Redirection {
        return get(context, requestName, null);
    }
    
    /** Request data from the server.  **/
    public String get(Context context, String requestName, Map<String, String> requestParams) throws Redirection {
        FunSite site = mainSite;
        
        Session session = context.getSession();
        if (session == null) {
            session = new Session(newSessionId());
            context.setSession(session);
        }
        
        Request request = new Request(session, requestParams);
        
        StringWriter serialDataWriter = new StringWriter();

        try {
            PrintWriter writer = new PrintWriter(serialDataWriter);
            respond(site, requestName, request, session, writer);
            
        } catch (Exception e) {
            throw new Redirection(Redirection.STANDARD_ERROR, "Exception getting " + requestName + ": " + e.toString());
        }
        
        return serialDataWriter.toString();
    }

    /** Process the HTTP Get request **/
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        respond(request, response);
    }

    /** Process the HTTP Post request **/
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        respond(request, response);
    }

    protected void respond(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String contextPath = request.getContextPath();
        String ru = request.getRequestURI();
        
        RequestState state = (RequestState) request.getAttribute(REQUEST_STATE_ATTRIBUTE);
        if (state != null && state == RequestState.EXPIRED) {
            response.sendError(504, "Unable to process request in a timely manner");
            return;
        }
        request.setAttribute(REQUEST_STATE_ATTRIBUTE, RequestState.STARTING);

        if (contextPath != null && ru != null && ru.startsWith(contextPath)) {
            ru = ru.substring(contextPath.length());
        }

        if (ru == null || ru.length() == 0) {
            response.sendRedirect(response.encodeRedirectURL("index.html"));
            return;
        }

        FunSite site = mainSite; 
        if (sites != null) {
            int ix = ru.indexOf('/');
            while (ix == 0) {
                ru = ru.substring(1);
                ix = ru.indexOf('/');
            }
            if (ix < 0) {
                if (sites.containsKey(ru)) {
                    site = (FunSite) sites.get(ru);
                }
            } else if (ix > 0) {
                String siteName = ru.substring(0, ix);
                if (sites.containsKey(siteName)) {
                    site = (FunSite) sites.get(siteName);
                }
            }
        }
        
        continueResponse(site, request, response);
    }
        
    private void continueResponse(final FunSite site, final HttpServletRequest request, final HttpServletResponse response) throws IOException {    
        final AsyncContext async = request.startAsync(request, response); //Start Async Processing
        
        async.setTimeout(asyncTimeout);
        async.addListener(new AsyncEventListener());
        
        async.start(new Runnable() {
            public void run() {
                try {
                    String qstring = (request.getQueryString() == null ? "" : "?" + request.getQueryString());
                    log("Request: " + request.getRequestURI() + qstring);
                    int status = respond(site, request, response, servletContext);
                    if (status >= 400) {
                        response.sendError(status);
                    }
                    RequestState state = (RequestState) request.getAttribute(REQUEST_STATE_ATTRIBUTE);
                    if (state == null) {
                        slog("Request state is null");
                    } else if (state == RequestState.EXPIRED) {
                        slog("Request timed out");
                    } else if (state == RequestState.COMPLETE) {
                        slog("Request already complete");
                    } else if (state == RequestState.STARTED) {
                        slog("Request started; calling complete()");
                        async.complete();
                    } else if (state == RequestState.STARTING) {
                        slog("Request starting; calling complete()");
                        async.complete();
                    } else {
                        slog("Request error");
                    }
                } catch (Exception e) {
                    log("Exception in response continuation: " + e.toString());
                    e.printStackTrace();
                }
            }
        });
    }

    public static class AsyncEventListener implements AsyncListener {
        public void onStartAsync(AsyncEvent asyncEvent) throws IOException {
            AsyncContext asyncContext = asyncEvent.getAsyncContext();
            ServletRequest request = asyncContext.getRequest();
            request.setAttribute(REQUEST_STATE_ATTRIBUTE, RequestState.STARTED);
            //System.out.println("--> onStartAsync");
        }

        public void onComplete(AsyncEvent asyncEvent) throws IOException {
            AsyncContext asyncContext = asyncEvent.getAsyncContext();
            ServletRequest request = asyncContext.getRequest();
            request.setAttribute(REQUEST_STATE_ATTRIBUTE, RequestState.COMPLETE);
            //System.out.println("--> onComplete");
        }

        public void onTimeout(AsyncEvent asyncEvent) throws IOException {
            AsyncContext asyncContext = asyncEvent.getAsyncContext();
            ServletRequest request = asyncContext.getRequest();
            request.setAttribute(REQUEST_STATE_ATTRIBUTE, RequestState.EXPIRED);
            //System.out.println("--> onTimeout");
            asyncContext.dispatch();
        }

        public void onError(AsyncEvent asyncEvent) throws IOException {
            AsyncContext asyncContext = asyncEvent.getAsyncContext();
            ServletRequest request = asyncContext.getRequest();
            request.setAttribute(REQUEST_STATE_ATTRIBUTE, RequestState.ERROR);
            //System.out.println("--> onError");
        }        
    }
    
    /**Process the HTTP Put request*/
    public void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        respond(request, response);
    }

    /**Process the HTTP Delete request*/
    public void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        respond(request, response);
    }
    
    
    public static String getPageName(FunSite site, HttpServletRequest request) {
        // this works on Resin
        String requestName = request.getPathInfo();

        // this is for Tomcat
        if (requestName == null) {
            requestName = request.getServletPath();
            if (requestName == null) {
                requestName = "";
            }
        }
        return site.getPageName(requestName);
    }

    private static Construction createParamsArg(FunSite site, Map<String, String> params) {
        Definition parent = site.getMainOwner();
        FunNode owner = (FunNode) parent;
        ExternalDefinition def = new ExternalDefinition("params", owner, parent, null, Definition.PUBLIC_ACCESS, Definition.IN_CONTEXT, params, null);
        return new Instantiation(def);
    }

    private static Construction createRequestArg(FunSite site, Request request) {
        Definition requestDef = site.getDefinition("request");
        if (requestDef == null) {
            throw new RuntimeException("core not loaded (can't find definition for 'request')");
        }
        Definition parent = site.getMainOwner();
        FunNode owner = (FunNode) parent;
        ExternalDefinition def = new ExternalDefinition("request", owner, parent, requestDef.getType(), requestDef.getAccess(), requestDef.getDurability(), request, null);
        return new Instantiation(def);
    }

    private static Construction createSessionArg(FunSite site, Session session) {
        Definition sessionDef = site.getDefinition("session");
        if (sessionDef == null) {
            throw new RuntimeException("core not loaded (can't find definition for 'session')");
        }
        Definition parent = site.getMainOwner();
        FunNode owner = (FunNode) parent;
        ExternalDefinition def = new ExternalDefinition("session", owner, parent, sessionDef.getType(), sessionDef.getAccess(), sessionDef.getDurability(), session, null);
        return new Instantiation(def);
    }

    public static boolean canRespond(FunSite site, HttpServletRequest request) {
        String pageName = getPageName(site, request);
        return site.canRespond(pageName);
    }

    public int respond(FunSite site, HttpServletRequest httpRequest, HttpServletResponse response, ServletContext servletContext) throws IOException {
        // contexts are stored under a name that is not a legal name
        // in Fun, so that it won't collide with cached Fun values.
        String pageName = getPageName(site, httpRequest);
        Request request = new Request(httpRequest);
        Session session = new Session(httpRequest.getSession());

        String mimeType = servletContext.getMimeType(pageName);
        if (mimeType == null) {
            mimeType = servletContext.getMimeType(pageName.toLowerCase());
            if (mimeType == null) {
                mimeType = "text/html";
            }
        }
        response.setContentType(mimeType);

        int status = 0;
        try {
            status = respond(site, pageName, request, session, response.getWriter());
        } catch (Redirection r) {
            status = r.getStatus();
            String location = r.getLocation();
            String message = r.getMessage();
            if (location != null) {
                if (isStatusCode(location)) {
                    status = Integer.parseInt(location);
                }
                if (status >= 400) {
                    if (message != null) {
                        response.sendError(status, message);
                    } else {
                        response.sendError(status);
                    }
                } else {
                    if (message != null) {
                        location = location + "?message=" + message; 
                    }
                    String newLocation = response.encodeRedirectURL(location);
                    response.sendRedirect(newLocation);
                }
            }
        }

        handlePendingServerRunners();
        
        return status;
    }

    public int respond(FunSite site, String name, Request request, Session session, PrintWriter writer) throws IOException, Redirection {
        
        Construction funRequest = createRequestArg(site, request);
        Construction funSession = createSessionArg(site, request.getSession());
        Construction requestParams = createParamsArg(site, request.params());

        FunContext funContext = (FunContext) session.getAttribute("@");
        
        // if the FunContext for this session is null, then it's a new
        // session; create a new context, save it in the current session
        // and call session_init. 
        //
        // Otherwise, this is an existing session.  Use the saved context
        // if it's not in use; otherwise create a new context and use that.
        
        if (funContext == null) {
            funContext = (FunContext) site.context();
            site.getPropertyInContext("session_init", funContext.getContext());
            session.setAttribute("@", funContext);
        }

        funContext = new FunContext(funContext);
        
        Context context = null;
        synchronized (funContext) {
            funContext.setInUse(true);
            context = funContext.getContext();
        }
        
        int status = 0;
        try {
            synchronized (context) {
                status = site.respond(name, requestParams, funRequest, funSession, context, writer);
            }

//        } catch (Redirection r) {
//            status = r.getStatus();
//
        } catch (Exception e) {
            status = FunServer.SERVER_ERROR;

        } finally {
            synchronized (funContext) {
                funContext.setInUse(false);
            }
        }

        return status;
    }
    
    /** Respond to a service request from another FunServer **/
    public int respond(Context context, String requestName, Map<String, String> params, PrintWriter writer) {
        FunSite site = mainSite;

        Construction requestParams = createParamsArg(site, params);
        int status = 0;
        try {
            synchronized (context) {
                status = site.respond(requestName, requestParams, null, null, context, writer);
            }

        } catch (Redirection r) {
            status = r.getStatus();
            String location = r.getLocation();
            String message = r.getMessage();
            params = null;
            if (location != null) {
                if (message != null) {
                    params = new HashMap<String, String>(1);
                    params.put("message", message); 
                }
                requestParams = createParamsArg(site, params);
                try {
                    synchronized (context) {
                        status = site.respond(location, requestParams, null, null, context, writer);
                    }
                } catch (Redirection rr) {
                    ;
                }
            }
        }
        
        handlePendingServerRunners();
        
        return status;
        
    }
    
    private void handlePendingServerRunners() {
        if (pendingServerRunners != null && !pendingServerRunners.isEmpty()) {
            synchronized (pendingServerRunners) {
                for (FunServerRunner runner: pendingServerRunners) {
                    runner.start();
                }
                pendingServerRunners.clear();
            }
        }
    }
    
    //
    // Unique string generator.
    //
    // The strategy is to use millisecond-based timestamps, with an additional
    // set of digits to accommodate multiple session ids created in the same
    // millisecond.  If more unique strings are needed than the number of extra
    // digits can accommodate, an IllegalStateException is thrown.
    //
    //
    
    private static final int NUM_COUNTER_DIGITS = 4;
    private static final int UNIQUE_COUNTER_MODULO = (int) Math.pow(16, NUM_COUNTER_DIGITS);
    private static final int NUM_TIMESTAMP_DIGITS = 11;   // least significant digits 
    private int uniqueStringCounter = 0;
    private int lastStartCounter = 0;
    private long lastTime = 0L;
    
    private String getUniqueString() {
        long now = System.currentTimeMillis();
        int counter = uniqueStringCounter;
        uniqueStringCounter = ++uniqueStringCounter % UNIQUE_COUNTER_MODULO;
        if (now == lastTime) {
            if (uniqueStringCounter == lastStartCounter) {
                throw new IllegalStateException("Unable to create session id; max ids per millisecond exceeded");
            }
        } else {
            lastTime = now;
            lastStartCounter = uniqueStringCounter;
        }
        
        return getHexDigits(now, NUM_TIMESTAMP_DIGITS) + "-" + getHexDigits(counter, NUM_COUNTER_DIGITS);
    }
    
    private String getHexDigits(int val, int len) {
        String str = Integer.toHexString(val);
        int n = str.length();
        if (n > len) {
            str = str.substring(n - len);
        } else {
            while (n++ < len) {
                str = "0" + str;
            }
        }
        return str;
    }
    
    private String getHexDigits(long val, int len) {
        String str = Long.toHexString(val);
        while (str.length() < len) {
            str = "0" + str;
        }
        return str;
    }

    private static boolean isStatusCode(String str) {
        if (str == null) {
            return false;
        }
        int length = str.length();
        if (length != 3) {
            return false;
        }
        char c = str.charAt(0);
        if (c < '1' || c > '5') {
            return false;
        }
        c = str.charAt(1);
        if (c < '0' || c > '9') {
            return false;
        }
        c = str.charAt(2);
        if (c < '0' || c > '9') {
            return false;
        }
        return true;
    }
    

    /** Class to provide Java access to Fun site_config object. **/
    public static class site_config_wrapper implements site_config {
        FunObjectWrapper site_config;
        
        public site_config_wrapper(FunObjectWrapper site_config) {
            this.site_config = site_config;
        }

        /** Returns the name of the site. **/
        public String name() {
            return site_config.getChildText("name");
        }
        
        /** The directories and/or files containing the Fun source
         *  code for this site.
         **/
        public String funpath() {
            return site_config.getChildText("funpath");
            
        }

        /** The directories and/or files containing the Fun source
         *  code for core.
         **/
        public String corepath() {
            return site_config.getChildText("corepath");
        }
        
        /** The directories and/or files containing the Fun source
         *  code specific to this site (not including core).
         **/
        public String sitepath() {
            return site_config.getChildText("sitepath");
            
        }
        
        /** If true, directories found in funpath are searched recursively
         *  for Fun source files.
         **/
        public boolean recursive() {
            return site_config.getChildBoolean("recursive");
        }
        
        /** The base directory for file-based resources. **/
        public String filepath() {
            return site_config.getChildText("filepath");
        }

        /** The files first setting.  If true, the server should look for files 
         *  before Fun objects to satisfy a request.  If false, the server 
         *  should look for Fun objects first, and look for files only when no 
         *  suitable Fun object by the requested name exists.
         */
        public boolean files_first() {
            return site_config.getChildBoolean("files_first");
        }
       
    }
    
    public static class FunServerRunner {
        
        private FunServer server;
        
        public FunServerRunner(FunServer server) {
            this.server = server;
        }
        
        public FunServer getServer() {
            return server;
        }

        public void start() {
            Thread t = new Thread(new Runnable() {
                    public void run() {
                        try {
                            server.startServer();
                        } catch (Exception e) {
                            slog("Exception running FunServer: " + e.toString());
                            e.printStackTrace();
                        }
                    }
                });
            t.start();
        }            
                
    }

}
