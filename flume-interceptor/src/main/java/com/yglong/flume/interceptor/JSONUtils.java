package com.yglong.flume.interceptor;

import org.mortbay.util.ajax.JSON;

public class JSONUtils {
    public static boolean isValid(String log) {
        try {
            JSON.parse(log);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
