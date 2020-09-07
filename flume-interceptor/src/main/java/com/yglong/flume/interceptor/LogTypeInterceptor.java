package com.yglong.flume.interceptor;

import lombok.extern.slf4j.Slf4j;
import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.interceptor.Interceptor;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
public class LogTypeInterceptor implements Interceptor {
    @Override
    public void initialize() {
        log.info("====> type initialize");
    }

    @Override
    public Event intercept(Event event) {
        byte[] body = event.getBody();
        String str = new String(body, StandardCharsets.UTF_8);
        Map<String, String> headers = event.getHeaders();
        if (str.contains("start")) {
            headers.put("state", "mystart");
        } else {
            headers.put("state", "myevent");
        }
        log.info("====> set headers " + headers);
        event.setHeaders(headers);
        return event;
    }

    @Override
    public List<Event> intercept(List<Event> list) {
        ArrayList<Event> events = new ArrayList<>();
        for (Event e : list) {
            Event event = intercept(e);
            events.add(event);
        }
        log.info("==============> Type result events: " + events.size());
        log.info("==============> " + events.get(0).getHeaders());
        return events;
    }

    @Override
    public void close() {
        log.info("==========> type close");
    }

    public static class Builder implements Interceptor.Builder {

        @Override
        public Interceptor build() {
            log.info("=====> new type interceptor");
            return new LogTypeInterceptor();
        }

        @Override
        public void configure(Context context) {
            String topic = context.getString("topic");
            log.info("=======> context: " + topic);
        }
    }
}
