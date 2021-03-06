package com.yglong.flume.interceptor;

import org.apache.commons.lang.math.NumberUtils;

public class LogUtils {

    public static boolean validateStart(String log) {
        if (log == null) {
            return false;
        }
        if (!log.trim().startsWith("{") || !log.trim().endsWith("}")) {
            return false;
        }
        return true;
    }

    public static boolean validateEvent(String log) {
        String[] logContents = log.split("\\|");
        if (logContents.length != 2) {
            return false;
        }

        if (logContents[0].length() != 13 || !NumberUtils.isDigits(logContents[0])) {
            return false;
        }

        if (!logContents[1].trim().startsWith("{") || !logContents[1].trim().endsWith("}")) {
            return false;
        }
        return true;
    }
}
