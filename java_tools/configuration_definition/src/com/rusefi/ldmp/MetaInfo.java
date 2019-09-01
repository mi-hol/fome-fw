package com.rusefi.ldmp;

import java.util.*;

public class MetaInfo {
    public Map<String, List<Request>> map = new TreeMap<>();
    public Stack<String> stateStack = new Stack<>();

    public List<Request> start(String content) {
        map.putIfAbsent(content, new ArrayList<>());
        return map.get(content);
    }

    public List<Request> first() {
        return map.values().iterator().next();
    }

    public String getStateContext() {
        if (stateStack.isEmpty())
            return ""; // state context not defined, java code would have to explicitly provide that information
        return stateStack.peek();
    }
}
