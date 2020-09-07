package com.yglong.flume.interceptor;

import lombok.extern.slf4j.Slf4j;
import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.interceptor.Interceptor;

import java.util.List;

@Slf4j
public class TestInterceptor implements Interceptor {
    @Override
    public void initialize() {

    }

    @Override
    public Event intercept(Event event) {
        return event;
    }

    @Override
    public List<Event> intercept(List<Event> list) {
        log.info("Test ==> " + list.get(0).getHeaders());
        return list;
    }

    @Override
    public void close() {

    }

    public static class Builder implements Interceptor.Builder {

        @Override
        public Interceptor build() {
            return new TestInterceptor();
        }

        @Override
        public void configure(Context context) {

        }
    }
}
