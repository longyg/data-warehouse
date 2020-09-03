package com.yglong.flume.interceptor;

import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.interceptor.Interceptor;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class LogTypeInterceptor implements Interceptor {
    @Override
    public void initialize() {

    }

    @Override
    public Event intercept(Event event) {
        byte[] body = event.getBody();
        String log = new String(body, StandardCharsets.UTF_8);
        Map<String, String> headers = event.getHeaders();
        if (log.contains("start")) {
            headers.put("topic", "topic_start");
        } else {
            headers.put("topic", "topic_event");
        }
        return event;
    }

    @Override
    public List<Event> intercept(List<Event> list) {
        ArrayList<Event> events = new ArrayList<>();
        for (Event e : list) {
            Event event = intercept(e);
            events.add(event);
        }
        return events;
    }

    @Override
    public void close() {

    }

    public static class Builder implements Interceptor.Builder {

        @Override
        public Interceptor build() {
            return new LogTypeInterceptor();
        }

        @Override
        public void configure(Context context) {

        }
    }
}
