package com.yglong.flume.interceptor;

import lombok.extern.slf4j.Slf4j;
import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.interceptor.Interceptor;

import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Slf4j
public class LogETLInterceptor implements Interceptor {
    @Override
    public void initialize() {

    }

    @Override
    public Event intercept(Event event) {
        byte[] body = event.getBody();
        String str = new String(body, StandardCharsets.UTF_8);
        if (str.contains("start")) {
            if (LogUtils.validateStart(str)) {
                log.info("Valid start log: " + str);
                return event;
            }
        } else {
            if (LogUtils.validateEvent(str)) {
                log.info("Valid event log: " + str);
                return event;
            }
        }
        return null;
    }

    @Override
    public List<Event> intercept(List<Event> list) {
        ArrayList<Event> events = new ArrayList<>();
        for (Event e : list) {
            Event event = intercept(e);
            if (null != event) {
                events.add(event);
            }
        }
        return events;
    }

    @Override
    public void close() {

    }

    public static  class Builder implements Interceptor.Builder {

        @Override
        public Interceptor build() {
            return new LogETLInterceptor();
        }

        @Override
        public void configure(Context context) {

        }
    }
}
