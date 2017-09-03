/* Fun Compiler and Runtime Engine
 * FunSite.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.runtime;

import fun.lang.*;
import fun.parser.Token;
import fun.parser.FunParserConstants;
import fun.runtime.debugger.SimpleDebugger;

import java.io.*;
import java.util.*;

/**
 * @author Michael St. Hippolyte
 * @version $Revision: 1.110 $
 */

public class FunSite extends FunDomain {

    private static void log(String string) {
        SiteBuilder.log(string);
    }

    private static void vlog(String string) {
        SiteBuilder.vlog(string);
    }

    private static boolean LOG_MEMORY = false;
    private static String currentSiteName = "(unknown)";
    private static PrintStream mps = null;
    private static void mlog(String string) {
        SiteBuilder.mlog(string);
        if (LOG_MEMORY) {
        if (mps == null) {
            try {
                mps = new PrintStream(new FileOutputStream("fun_mem.log", true));
            } catch (FileNotFoundException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
                mps = System.err;
            }
            Date now = new Date();
            mps.println("\n=========== begin logging for site " + currentSiteName + " on " + now.toString() + " ============");
        }
        mps.println(string);
        }
    }

    private long startingConsumedMemory;
    private long loadedConsumedMemory;


    private String siteName;
    private String funPath = null;

    private int errorThreshhold = Context.EVERYTHING;

    private Map<String, Integer> pageTracker;
    private Map<String, Integer> fileTracker;
    private Map<String, Integer> redirectTracker;
    private long loadTime;
    private boolean hasGeneralResponse = false;
    private Set<String> ignoreExtensions = null;
    private Set<String> handleAsObjectExtensions = null;

    private boolean debuggingEnabled = false;

    /** Constructs a new FunSite object, which can load and compile Fun source code
     *  defining a group of related site objects and respond to queries.
     *
     *  The name parameter specifies the main site, which is the site queried for names
     *  that do not explicitly specify a site.  The sitename may be null or an empty string,
     *  in which case the name of the site is obtained from the main_site Fun object,
     *  loaded from the default site.
     */
    public FunSite(String name, fun_processor processor) {
        super(name, processor);

        siteName = name;
        currentSiteName = siteName;
        Runtime runtime = Runtime.getRuntime();
        runtime.gc();
        startingConsumedMemory = runtime.totalMemory() - runtime.freeMemory();
    }

    
    public String toString() {
        String str = "Fun Site " + (siteName != null ? siteName : "(no name)") + '\n';
        if (getSite() != null) {
            str += getSite().toString();
        } else {
            str += "(empty)";
        }
        str += '\n';
        return str;
    }
    


    public boolean load(String funPath, String inFilter, boolean recursive, boolean multiThreaded, boolean autoLoadCore, Core sharedCore) {
        this.funPath = funPath;
        
        SiteLoader.LoadOptions options = SiteLoader.getDefaultLoadOptions();
        options.multiThreaded = multiThreaded;
        options.autoLoadCore = autoLoadCore;

        clearStats();
        if (load(funPath, inFilter, recursive, sharedCore, options)) {
            loadTime = System.currentTimeMillis();
            Runtime runtime = Runtime.getRuntime();
            runtime.gc();
            loadedConsumedMemory = runtime.totalMemory() - runtime.freeMemory();
            log("Loading site consumed " + (loadedConsumedMemory - startingConsumedMemory) + " bytes.");
            return true;
        } else {
            return false;
        }
    }


    void globalInit() {
        super.globalInit();
    }
    
    void siteInit() {
        hasGeneralResponse = isDefined("general_response");
        List<? extends Object> exts = getPropertyList("ignore_extensions");
        if (exts != null && exts.size() > 0) {
            ignoreExtensions = new TreeSet<String>();
            Iterator<? extends Object> it = exts.iterator();
            while (it.hasNext()) {
                ignoreExtensions.add(it.next().toString());
            }
            
        }
        exts = getPropertyList("always_handle_extensions");
        if (exts != null && exts.size() > 0) {
            handleAsObjectExtensions = new TreeSet<String>();
            Iterator<? extends Object> it = exts.iterator();
            while (it.hasNext()) {
                handleAsObjectExtensions.add(it.next().toString());
            }
        }
    }
    
    public boolean isDebuggingEnabled() {
        return debuggingEnabled;
    }

    public void enableDebugging(boolean enabled) {
        debuggingEnabled = enabled;
    }

    public int getErrorThreshhold() {
        return errorThreshhold;
    }

    public void setErrorThreshhold(int threshhold) {
        errorThreshhold = threshhold;
    }

    public void clearStats() {
        pageTracker = new TreeMap<String, Integer>();
        fileTracker = new TreeMap<String, Integer>();
        redirectTracker = new TreeMap<String, Integer>();
    }

    public String getPageName(String requestName) {

        String pageName = requestName;
        if (pageName.length() > 0) {
            // strip off leading separator
            char c = pageName.charAt(0);
            if (c == '/' || c == '\\') {
                pageName = pageName.substring(1);
            }
            
            // strip off leading site name
            if (site != null && site.getName() != null) {
                String siteNamePrefix = site.getName() + ".";
                if (pageName.startsWith(siteNamePrefix)) {
                    pageName = pageName.substring(siteNamePrefix.length());
                }
            }

            // strip off html extension
            if (pageName.endsWith(".html") || pageName.endsWith(".HTML")) {
                pageName = pageName.substring(0, pageName.length() - 5);
            }

            // turn separators into dots
            pageName = pageName.replace('/', '.').replace('\\', '.');
            if (pageName.endsWith(".")) {
                pageName = pageName + "index";
            }
        }

        // if that leaves us with nothing, default to "index"
        if (pageName.length() == 0) {
            pageName = "index";
        }

        return pageName;
    }


    public Instantiation getPageInstance(String pageName, ArgumentList[] argLists, Context argContext) {
        return getInstance("response", pageName, argLists, argContext);
    }

    public Instantiation getGeneralResponseInstance(ArgumentList[] argLists, Context argContext) {
        return getInstance(null, "general_response", argLists, argContext);
    }


    public ArgumentList[] getGeneralResponseArgumentLists(String name, Construction requestParams, Construction funRequest, Construction funSession) {
        ArgumentList[] args = new ArgumentList[4];

        StaticText nameArg = new StaticText(name);

        List<Construction> nameRequestAndSession = new ArrayList<Construction>(3);
        nameRequestAndSession.add(nameArg);
        nameRequestAndSession.add(funRequest);
        nameRequestAndSession.add(funSession);
        args[0] = new ArgumentList(nameRequestAndSession);

        List<Construction> nameAndRequest = new ArrayList<Construction>(2);
        nameAndRequest.add(nameArg);
        nameAndRequest.add(funRequest);
        args[1] = new ArgumentList(nameAndRequest);

        List<Construction> nameAndParams = new ArrayList<Construction>(2);
        nameAndParams.add(nameArg);
        nameAndParams.add(requestParams);
        args[2] = new ArgumentList(nameAndParams);

        List<Construction> nameOnly = new SingleItemList<Construction>(nameArg);
        args[3] = new ArgumentList(nameOnly);

        return args;
    }

    public ArgumentList[] getArgumentLists(Construction requestParams, Construction funRequest, Construction funSession) {
        ArgumentList[] args = new ArgumentList[4];

        List<Construction> requestAndSession = new ArrayList<Construction>(2);
        requestAndSession.add(funRequest);
        requestAndSession.add(funSession);
        args[0] = new ArgumentList(requestAndSession);

        List<Construction> paramsOnly = new SingleItemList<Construction>(requestParams);
        args[1] = new ArgumentList(paramsOnly);
        
        List<Construction> requestOnly = new SingleItemList<Construction>(funRequest);
        args[2] = new ArgumentList(requestOnly);

        args[3] = null;

        return args;
    }


    public boolean canRespond(String pageName) {
        if (getDefinition(pageName) != null) {
            return true;

        } else if (pageName == null || pageName.charAt(0) == '$') {
            return true;

        // there might be a site prefix before the item request
        } else if (pageName.indexOf(".$") > -1) {
            return true;

        } else if (hasGeneralResponse && !ignoreRequest(pageName)) {
            return true;
        }
        
        return false;
    }

    public boolean ignoreRequest(String name) {
        if (ignoreExtensions != null && name.lastIndexOf('.') > -1) {
            String ext = name.substring(name.lastIndexOf('.') + 1);
            return ignoreExtensions.contains(ext);
        }
        
        return false;
    }
    
    public boolean handleAsObject(String name) {
        if (handleAsObjectExtensions != null && name.lastIndexOf('.') > -1) {
            String ext = name.substring(name.lastIndexOf('.') + 1);
            return handleAsObjectExtensions.contains(ext);
        }
        
        return false;
    }

    /** Remove or switch characters that are illegal in a Fun name. */
    private String cleanForFun(String name) {
        StringBuffer sb = new StringBuffer(name);
        for (int i = 0; i < sb.length(); i++) {
            char c = sb.charAt(i);
            if (c <= ' ' || c == '-') {
                sb.setCharAt(i, '_');
            }
        }
        return sb.toString();
    }
    
    
    public int respond(String pageName, Construction paramsArg, Construction requestArg, Construction sessionArg, Context context, PrintWriter out) throws Redirection {
        ArgumentList[] argLists = getArgumentLists(paramsArg, requestArg, sessionArg);
        Instantiation page = getPageInstance(cleanForFun(pageName), argLists, context);
        boolean respondWithPage = true;
        
        if (page != null) {
            return respond(page, context, out);

        } else {
            if (pageName == null) {
                return FunServer.BAD_REQUEST;
            }
            
            boolean handleAsObj = (pageName.charAt(0) == '$' || handleAsObject(pageName));

            if (pageName.equalsIgnoreCase("$debug")) {
                FunDebugger debugger = context.getDebugger();
                if (debugger == null) {
                    debugger = createDebugger();
                }
            
            } else if (pageName.equalsIgnoreCase("$stat")) {
                recordRequest("$stat", pageTracker);
                printStatus(out);

            } else if (pageName.equalsIgnoreCase("$source")) {
                recordRequest("$source", pageTracker);
                //response.setContentType("text/plain");
                printSource(out);

            } else if (hasGeneralResponse || handleAsObj || pageName.indexOf(".$") > -1) {
                respondWithPage = false;
                Instantiation instance = null;
                String objName = null;
                if (handleAsObj) {
                    if (pageName.charAt(0) == '$') {
                        objName = pageName.substring(1);
                    } else {
                        objName = pageName;
                    }
                    instance = getInstance("", objName, argLists, context);

                } else if (pageName.indexOf(".$") > -1) {
                    int ix = pageName.indexOf(".$");
                    objName = pageName.substring(ix + 2);
                    String ownerName = pageName.substring(0, ix + 1);
                    instance = getInstance("", ownerName + objName, argLists, context);
                    
                } else {
                    objName = pageName;
                    argLists = getGeneralResponseArgumentLists(pageName, paramsArg, requestArg, sessionArg);
                    instance = getGeneralResponseInstance(argLists, context);
                }
                if (instance == null) {
                    log("Object " + pageName + " is undefined.");
                    return FunServer.NOT_FOUND;
                }
                // record the page name (which has the $ prefix) rather than the
                // object name in order to preserve the differentiation between
                // pages and objects.
                recordRequest(pageName, pageTracker);
                try {

                    String scopeName = null;
                    if (objName.indexOf('.') > 0) {
                        scopeName = objName.substring(0, objName.indexOf('.'));;
                    }
                    
                    Definition instanceDef = instance.getDefinition(context);
                    if (instanceDef == null || instanceDef.getAccess() != Definition.PUBLIC_ACCESS) {
                        log("Object " + pageName + " is not public.");
                        return FunServer.NOT_FOUND;
                    }
                    
                    Site instanceSite = instanceDef.getSite();
                    Object data = null;
                    if (!instanceSite.equals(context.peek().def) && !(instanceSite instanceof Core)) {
                        context.push(instanceSite, null, null, true);
                        Instantiation pageInstance = null;
                        if (scopeName != null) {
                            pageInstance = getInstance("page", cleanForFun(scopeName), argLists, context);
                        }
                        if (pageInstance != null) {
                            Definition pageDef = pageInstance.getDefinition(context);
                            ArgumentList pageArgs = pageInstance.getArguments();
                            ParameterList pageParams = pageDef.getParamsForArgs(pageArgs, context);
                            context.push(pageDef, pageParams, pageArgs, true);
                            data = instance.getData(context);
                            context.pop();
                        } else {
                            Definition responseDef = instance.getDefinition(context);
                            data = instance.instantiate(context, responseDef);
                        }
                        context.pop();
                    } else {
                        Instantiation pageInstance = null;
                        if (scopeName != null) {
                            pageInstance = getPageInstance(cleanForFun(scopeName), argLists, context);
                        }
                        if (pageInstance != null) {
                            Definition pageDef = pageInstance.getDefinition(context);
                            ArgumentList pageArgs = pageInstance.getArguments();
                            ParameterList pageParams = pageDef.getParamsForArgs(pageArgs, context);
                            context.push(pageDef, pageParams, pageArgs, true);
                            data = instance.getData(context);
                            context.pop();
                        } else {
                            data = instance.instantiate(context, instanceDef);
                        }
                    }
                    if (data == null) {
                        Type type = instance.getType(context, false);
                        log(type.getName() + " " + (pageName.charAt(0) == '$' ? pageName.substring(1) : pageName) + " is empty.");
                        return FunServer.NO_CONTENT;
                    }
                    String str = getStringForData(data);
                    out.println(str);
                    currentSiteName = siteName; //for logging
                    mlog("----------------- requested object: " + pageName + " ------------------");
                    mlog("Created " + Context.getNumContextsCreated() + " Contexts (" + Context.getNumClonedContexts() + " of them cloned) and " + Context.getNumEntriesCreated() + " entries (" + Context.getNumEntriesCloned() + " of them cloned).");
                    mlog("Created " + Context.getNumHashMapsCreated() + " HashMaps.");
                    mlog("Created " + Context.getNumArrayListsCreated() + " ArrayLists, " + Context.getTotalListSize() + " total initial allocation.");
                    long consumedMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory() - loadedConsumedMemory;
                    mlog(consumedMemory + " additional bytes of memory consumed since site was loaded.");

                } catch (Redirection r) {
                    String location = r.getLocation();
                    if (location == null || location.length() < 1 || location.equals(Redirection.STANDARD_ERROR)) {
                        if (respondWithPage) {
                            location = Redirection.STANDARD_ERROR_PAGE;
                        } else {
                            location = Redirection.STANDARD_ERROR_DIV;
                        }
                        r.setLocation(location);
                    }
                    recordRequest(location, redirectTracker);
                    throw r;
                }
            } else {
                return FunServer.NOT_FOUND;
            }
        }
        return FunServer.OK;
    }

    private FunDebugger createDebugger() {
        return new SimpleDebugger();
    }

    public int respond(Instantiation page, Context context, PrintWriter out) throws Redirection {
        
        String pageName = page.getName();
        recordRequest(pageName, pageTracker);
        try {
            Object pageData = null;
            Definition pageDef = page.getDefinition(context);
            if (pageDef == null) {
                log("Page " + pageName + " is undefined.");
                return FunServer.NOT_FOUND;
            } else if (pageDef.getAccess() != Definition.PUBLIC_ACCESS) {
                log("Page " + pageName + " is not public.");
                return FunServer.NOT_FOUND;
            }
            Site pageSite = pageDef.getSite();
            if (pageSite != null && !pageSite.equals(context.peek().def) && !(pageSite instanceof Core)) {
                context.push(pageSite, null, null, true);
                pageData = pageDef.instantiate(page.getArguments(), null, context);
                context.pop();
            } else {
                pageData = page.instantiate(context, pageDef);
            }
            if (pageData == null) {
                log("Page " + pageName + " is empty.");
                return FunServer.NO_CONTENT;
            }
            String str = getStringForData(pageData);

            // for server-to-server communications, we want to send the response exactly as
            // it has been constructed, so we make sure not to add a newline
            if (pageDef != null && pageDef.isSuperType("server_response")) {
                out.print(str);
            } else {
                out.println(str);
            }
            currentSiteName = siteName; //for logging
            mlog("----------------- requested page: " + pageName + " ------------------");
            mlog("Created " + Context.getNumContextsCreated() + " Contexts (" + Context.getNumClonedContexts() + " of them cloned) and " + Context.getNumEntriesCreated() + " entries (" + Context.getNumEntriesCloned() + " of them cloned).");
            mlog("Created " + Context.getNumHashMapsCreated() + " HashMaps.");
            mlog("Created " + Context.getNumArrayListsCreated() + " ArrayLists, " + Context.getTotalListSize() + " total initial allocation.");
            long consumedMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory() - loadedConsumedMemory;
            mlog(consumedMemory + " bytes of memory consumed since site was loaded.");

        } catch (Redirection r) {
            String location = r.getLocation();
            if (location == null || location.length() < 1 || location.equals(Redirection.STANDARD_ERROR)) {
                location = Redirection.STANDARD_ERROR_PAGE;
                r.setLocation(location);
            }
            recordRequest(location, redirectTracker);
            throw r;
        }
        return FunServer.OK;
    }

    public boolean respondWithFile(File file, String mimeType, OutputStream out) throws IOException {
        // Just record the request and return false, indicating that the caller should
        // handle the file transfer using an appropriate default mechanism
        recordRequest(file.getName(), fileTracker);
        return false;
    }
    
    public void run(String request, Writer out) throws Redirection, IOException {
        
        try {
            Object runData = get(request);
            if (runData == null) {
                log("Request " + request + " returns null.");
                return;
            }
            String str = getStringForData(runData);
            out.write(str);

        } catch (Redirection r) {
            String location = r.getLocation();
            String message = r.getMessage();
            if (location != null && location.length() > 0) {
                out.write("Redirecting to " + location);
                if (message != null && message.length() > 0) {
                    out.write(": ");
                }
            }
            if (message != null && message.length() > 0) {
                out.write(message);
            }
            throw r;
        } 
    }


    private static String getStringForData(Object data) throws Redirection {
        if (isCollection(data)) {
            return getStringForCollection(data);
        } else if (data instanceof FunObjectWrapper) {
            return ((FunObjectWrapper) data).getText();
        } else {
            return data.toString();
        }
        
    }
    
    private static boolean isCollection(Object data) {
        return (data instanceof Map<?,?> || data instanceof List<?> || data.getClass().isArray());
    }

    private static String getStringForCollection(Object data) {
        
        List<?> list = null;
        Map<?,?> map = null;
        
        if (data instanceof List<?>) {
            list = (List<?>) data;
        } else if (data.getClass().isArray()) {
            list = Arrays.asList((Object[]) data);
        } else if (data instanceof Map<?,?>) {
            map = (Map<?,?>) data;
        }
         
        if (list != null) {    
            StringBuffer sb = new StringBuffer();
            sb.append("[ ");
            int len = list.size();
            if (len > 0) {
                Iterator<?> it = list.iterator();
                while (it.hasNext()) {
                    Object element = it.next();
                    if (element instanceof Value) {
                        element = ((Value) element).getValue();
                    }
                    if (element != null) {
                        if (isCollection(element)) {
                            sb.append(getStringForCollection(element));
                        } else if (element instanceof Number) {
                            sb.append(element.toString());
                        } else {
                            sb.append('"');
                            String str = element.toString();
                            sb.append(str.replace("\"", "\\\""));
                            sb.append('"');
                        }
                    }

                    if (it.hasNext()) {
                        sb.append(", ");
                    }
                }
            }
            sb.append(" ]");
            return sb.toString();
    
        } else if (map != null) {
            StringBuffer sb = new StringBuffer();
            sb.append("{ ");
            Object[] keys = map.keySet().toArray();
            if (keys.length > 0) {
                Arrays.sort(keys);
                for (int i = 0; i < keys.length; i++) {
                    if (i > 0) {
                        sb.append(", ");
                    }
                    String key = keys[i].toString();
                    sb.append('"');
                    sb.append(key);
                    sb.append('"');
                    sb.append(": ");
                    Object element = map.get(key);
                    if (element == null) {
                        sb.append("null");
                    } else {
                        if (element instanceof Value) {
                            element = ((Value) element).getValue();
                        }
                        if (isCollection(element)) {
                            sb.append(getStringForCollection(element));
                        } else if (element instanceof Number) {
                            sb.append(element.toString());
                        } else {
                            sb.append('"');
                            String str = element.toString();
                            sb.append(str.replace("\"", "\\\""));
                            sb.append('"');
                        }
                    }
                }
            }
            sb.append(" }");
            return sb.toString();
           
        } else {
            return "";
        }

    }
    
    
    
    private static final Integer ONE = new Integer(1);
    private void recordRequest(String name, Map<String, Integer> tracker) {
        vlog("------------------------------------------------------------\nRequesting: " + name);
        Integer hitCount = (Integer) tracker.get(name);
        if (hitCount != null) {
            int n = hitCount.intValue();
            tracker.put(name, new Integer(n + 1));
        } else {
            tracker.put(name, ONE);
        }
    }

    private void printStatus(PrintWriter out) {
        out.println("<html>");
        out.println("<head><title>Site " + siteName + "</title></head>");
        out.println("<body bgcolor=\"#ccbb99\">");
        out.println("<h2><font color=\"#993300\">STATUS</font></h2>");
        out.println("<hr>");
        out.println("<h3>Site: " + siteName + "</h3>");
        out.println("<p>Loaded " + (new Date(loadTime)).toString() + ".</p>");
        out.println("<h3>Resource Usage</h3>");
        long memory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        out.println("<p>" + memory + " bytes of memory in use.<br>");
        out.println("Created " + Context.getNumContextsCreated() + " Contexts (" + Context.getNumClonedContexts() + " of them cloned) and " + Context.getNumEntriesCreated() + " entries (" + Context.getNumEntriesCloned() + " of them cloned).<br>");
        out.println("Created " + Context.getNumHashMapsCreated() + " HashMaps.<br>");
        out.println("Created " + Context.getNumArrayListsCreated() + " ArrayLists, " + Context.getTotalListSize() + " total initial allocation.</p>");

        out.println("<h3>Input</h3>");
        out.println("<p>funpath: " + funPath + "</p>");

        int numExceptions = 0;
        int numFiles = 0;
        for (int i = 0; i < sources.length; i++) {
            if (exceptions[i] != null) {
                numExceptions++;
            }
            if (sources[i] instanceof File) {
                numFiles++;
            }

        }
        int numURLs = sources.length - numFiles;
        out.println("<p>Loaded Fun source from " + numFiles + " file" + (numFiles == 1 ? "" : "s") + ", " + numURLs + " URL" + (numURLs == 1 ? "" : "s") + ".</p>");
        if (numExceptions == 0) {
            out.println("<p>No exceptions reported.</p>");
        } else {
            out.println("<p>" + numExceptions + " exceptions encountered:</p><ol>");
            for (int i = 0; i < exceptions.length; i++) {
                if (exceptions[i] != null) {
                   Object source = sources[i];
                   String name = (source instanceof File ? ((File) source).getAbsolutePath() : source.toString());
                   out.println("<li>Exception processing " + name + ": " + exceptions[i].toString() + "</li><p>");
                }
            }
            out.println("</ol>");
        }

        out.println("<h3>Output</h3>");

        out.println("<p><table border=\"1\" cellpadding=\"8\"><tr><th align=\"left\">Page</th><th align=\"left\">Requests</th></tr>");
        printTrackerRows(out, pageTracker);
        out.println("</table></p>");
        out.println("<p><table border=\"1\" cellpadding=\"8\"><tr><th align=\"left\">File</th><th align=\"left\">Requests</th></tr>");
        printTrackerRows(out, fileTracker);
        out.println("</table></p>");
        out.println("<p><table border=\"1\" cellpadding=\"8\"><tr><th align=\"left\">Redirected to</th><th align=\"left\">Redirections</th></tr>");
        printTrackerRows(out, redirectTracker);
        out.println("</table></p>");

        out.println("<h3>Sites</h3>");
        Iterator<Site> sites = core.getSites();
        int totalDefs = 0;
        if (sites.hasNext()) {
            while (sites.hasNext()) {
                Site site = sites.next();
                int numDefs = site.getNumDefinitions();
                totalDefs += numDefs;
                AbstractNode contents = site.getContents();
                int numTLDs = contents.getNumChildren();
                out.println("<p>site " + site.getName() + ": " + numDefs + " definition" + (numDefs == 1 ? "" : "s") + " (top level: " + numTLDs + ")</p>");
//                out.println("<blockquote>");
//                for (int i = 0; i < numTLDs; i++) {
//                    FunNode node = contents.getChild(i);
//                    if (node instanceof Definition) {
//                        out.println("<p>TLD " + i + ": " + ((Definition) node).getFullName() + "</p>");
//                    } else {
//                        out.println("<p>child " + i + " (not a definition): " + node.getClass().getName() + "</p>");
//                    }
//                }
//                out.println("</blockquote>");
            }
        } else {
            out.println("<p>No sites.</p>");
        }

        out.println("<h3>Objects</h3>");
        out.println("<p>" + totalDefs + " definition" + (totalDefs == 1 ? "" : "s") + "</p>");
        out.println("<hr><p><i>" + FunServer.NAME_AND_VERSION + "</i></p></body></html>");
    }

    private void printTrackerRows(PrintWriter out, Map<String, Integer> tracker) {
        Set<Map.Entry<String, Integer>> entries = tracker.entrySet();
        Iterator<Map.Entry<String, Integer>> it = entries.iterator();
        while (it.hasNext()) {
            Map.Entry<String, Integer> entry = (Map.Entry<String, Integer>) it.next();
            String key = (String) entry.getKey();
            int hits = ((Integer) entry.getValue()).intValue();
            out.println("<tr><td>" + key + "</td><td>" + hits + "</td></tr>");
        }
    }

    private void printSource(PrintWriter out) {
        SourceReporter reporter = new SourceReporter(out);
        reporter.handleSite(site);
        out.println();
        reporter.handleSite(core);
        out.println();
    }


    public class SourceReporter extends FunVisitor {

        String indent = "    ";
        PrintWriter out;

        public SourceReporter(PrintWriter out) {
            this.out = out;
        }

        public void handleSite(Site site) {

            if (site instanceof Core) {
                out.println("[---------------- Core ----------------]\n");
                out.print("core ");
            } else {
                out.println("[----------- Site " + site.getName() + " --------------]\n");
                out.print("site ");
            }

            // print the site's immediate children, remembering them
            // in a hashmap
            HashMap<FunNode, String> childmap = new HashMap<FunNode, String>(site.getNumChildren());
            Iterator<FunNode> it = site.getChildren();
            while (it.hasNext()) {
                FunNode node = it.next();
                childmap.put(node, "x");

                // handle the top-level block up here, to preserve child order order
                if (node instanceof Block) {
                    Iterator<FunNode> blockIt = node.getChildren();
                    while (blockIt.hasNext()) {
                        FunNode blockChild = blockIt.next();
                        childmap.put(blockChild, "x");
                    }
                    handleNode(node, indent);
                } else {
                    handleNode(node, "");
                }
            }

            // now handle any definitions that were added from elsewhere

            Definition[] defs = site.getDefinitions();
            ArrayList<FunNode> list = new ArrayList<FunNode>();
            for (int i = 0; i < defs.length; i++) {
                if (defs[i].getOwner().equals(site) && childmap.get(defs[i]) == null) {
                    list.add((FunNode) defs[i]);
                }
            }
            int n = list.size();
            if (n > 0) {
                it = list.iterator();
                while (it.hasNext()) {
                    FunNode node = it.next();
                    handleNode(node, indent);
                }
            }

            if (site instanceof Core) {
                out.println("[------------- end of core ------------]");
            } else {
                out.println("[----------- end of " + site.getName() + " --------------]");
            }
            out.println();
        }

        public Object handleNode(FunNode node, Object data) {

            String prefix = (String) data;

            // space out all definitions
            if (node instanceof Definition) {
                out.println();
                out.print(prefix);
            }

            if (node instanceof ComplexDefinition) {
                data = super.handleNode(node, prefix);
                out.println();

            } else if (node instanceof FunBlock) {
                out.println("{=");
                data = super.handleNode(node, prefix + indent);
                out.println(prefix + "=}");

            } else if (node instanceof StaticBlock) {
                out.println("[/");
                data = super.handleNode(node, prefix);
                out.println(prefix + "/]");

            } else if (node instanceof DynamicFunBlock || node instanceof DynamicElementBlock) {
                out.println("[[");
                data = super.handleNode(node, prefix);
                out.println(prefix + "]]");

            } else if (node instanceof ConcurrentFunBlock) {
                out.println("{+");
                data = super.handleNode(node, prefix);
                out.println(prefix + "+}");

            } else {
                printNode(node, prefix);
            }
            return data;
        }

        public void printNode(FunNode node, String prefix) {
            Token first = ((AbstractNode) node).getFirstToken();
            Token last = ((AbstractNode) node).getLastToken();
            for (Token t = first; t != null; t = t.next) {
//                Token st = t.specialToken;
//                if (st != null) {
//                    while (st.specialToken != null) {
//                        st = st.specialToken;
//                    }
//                    while (st != null) {
//                        out.print(st.image);
//                        st = st.next;
//                    }
//                }
                switch (t.kind) {
                    case FunParserConstants.LSTATIC:
                    case FunParserConstants.LSTATICW:
                    case FunParserConstants.LLITERAL:
                    case FunParserConstants.STATIC_0:
                    case FunParserConstants.STATIC_1:
                    case FunParserConstants.STATIC_2:
                    case FunParserConstants.STATIC_4:
                    case FunParserConstants.STATIC_5:
                        out.println(t.image);
                        prefix = prefix + indent;
                        out.print(prefix);
                        break;

                    case FunParserConstants.RSTATIC:
                    case FunParserConstants.RSTATICW:
                    case FunParserConstants.RLITERAL:
                    case FunParserConstants.STATIC_3:
                    case FunParserConstants.LITERAL_1:
                        out.println();
                        if (prefix.length() > 4) {
                            prefix = prefix.substring(4);
                        } else {
                            prefix = "";
                        }
                        if (prefix.length() > 0) {
                            prefix = prefix.substring(4);
                            out.print(prefix);
                        }
                        out.println(t.image);
                        break;

                    case FunParserConstants.DOT:
                    case FunParserConstants.LPAREN:
                    case FunParserConstants.LCODE:
                    case FunParserConstants.LBRACKET:
                        out.print(t.image);
                        break;

                    case FunParserConstants.SEMICOLON:
                    case FunParserConstants.NULL_BLOCK:
                    case FunParserConstants.ABSTRACT_NULL:
                    case FunParserConstants.EXTERNAL_BLOCK:
                        out.println(t.image);
                        if (prefix.length() > 0) {
                            out.print(prefix);
                        }
                        break;

                    default:
                        out.print(t.image);
                        if (t.next != null) {
                            switch (t.next.kind) {
                                case FunParserConstants.DOT:
                                case FunParserConstants.COMMA:
                                case FunParserConstants.LPAREN:
                                case FunParserConstants.RPAREN:
                                case FunParserConstants.LBRACKET:
                                case FunParserConstants.RBRACKET:
                                case FunParserConstants.LCODE:
                                case FunParserConstants.RCODE:
                                    break;
                                case FunParserConstants.EXTERN:
                                case FunParserConstants.KEEP:
                                case FunParserConstants.FOR:
                                case FunParserConstants.IF:
                                case FunParserConstants.ELSE:
                                case FunParserConstants.SUB:
                                case FunParserConstants.SUPER:
                                case FunParserConstants.OWNER:
                                case FunParserConstants.CONTAINER:
                                case FunParserConstants.THIS:
                                case FunParserConstants.CATCH:
                                    out.println();
                                    if (prefix.length() > 0) {
                                        out.print(prefix);
                                    }
                                    break;
                                default:
                                    out.print(' ');
                                    break;
                            }
                        }
                        break;
                }
                if (t == last) {
                    break;
                }
            }

            if (node instanceof Definition) {
                out.println();
            }
        }
    }
}

