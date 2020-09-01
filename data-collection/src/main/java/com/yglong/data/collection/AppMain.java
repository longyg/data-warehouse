package com.yglong.data.collection;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.yglong.data.collection.bean.AppBase;
import com.yglong.data.collection.bean.AppStart;
import lombok.extern.slf4j.Slf4j;

import java.util.Random;
import java.util.concurrent.TimeUnit;

@Slf4j
public class AppMain {

    private static Random random = new Random();

    private static int sMid = 0;
    private static int goodSid = 0;
    private static int uid = 0;

    public static void main(String[] args) {
        long interval = 0;
        int number = 1000;
        if (args.length > 0) {
            interval = Integer.parseInt(args[0]);
        }
        if (args.length > 1) {
            number = Integer.parseInt(args[1]);
        }

        generateLog(interval, number);

    }

    private static void generateLog(long interval, int number) {
        for (int i = 0; i < number; i++) {
            Object obj = null;
            if (random.nextBoolean()) {
                obj = generateStartLog();
            } else {
                obj = generateEventLog();
            }

            String jsonStr = System.currentTimeMillis() + "|" + JSON.toJSONString(obj);
            log.info(jsonStr);

            if (interval > 0) {
                try {
                    TimeUnit.SECONDS.sleep(interval);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private static Object generateEventLog() {
        JSONObject eventLog = new JSONObject();
        eventLog.put("ap", getAp());
        eventLog.put("cm", generateAppBase());
        eventLog.put("et",  generateEvents());
        return eventLog;
    }

    private static String getAp() {
        return new Random().nextBoolean() ? "app" : "pc";
    }

    private static JSONArray generateEvents() {
        JSONArray events = new JSONArray();
        Random random = new Random();
        for (int i = 0; i < random.nextInt(5) + 1; i++) {
            events.add(generateEvent());
        }
        return events;
    }

    private static AppBase generateAppBase() {
        return null;
    }

    private static Object generateEvent() {
        Random random = new Random();
        int n = random.nextInt(10);
        String en = "";
        Object kv = null;
        switch (n) {
            case 0:
                en = "active_background";
                kv = generateAppActiveBackground();
                break;
            case 1:
                en = "ad";
                kv = generateAppAd();
                break;
            case 2:
                en = "comment";
                kv = generateAppComment();
                break;
            case 3:
                en = "display";
                kv = generateAppDisplay();
                break;
            case 4:
                en = "errorlog";
                kv = generateAppErrorLog();
                break;
            case 5:
                en = "favorites";
                kv = generateAppFavorites();
                break;
            case 6:
                en = "newsdetail";
                kv = generateAppNewsDetail();
                break;
            case 7:
                en = "notification";
                kv = generateAppNotification();
                break;
            case 8:
                en = "praise";
                kv = generateAppPraise();
                break;
            case 9:
                en = "loading";
                kv = generateAppLoading();
                break;
        }
        JSONObject event = new JSONObject();
        event.put("ett", System.currentTimeMillis() + "");
        event.put("en", en);
        event.put("kv", kv);
        return event;
    }

    private static Object generateAppLoading() {
        return null;
    }

    private static Object generateAppPraise() {
        return null;
    }

    private static Object generateAppNotification() {
        return null;
    }

    private static Object generateAppNewsDetail() {
        return null;
    }

    private static Object generateAppFavorites() {
        return null;
    }

    private static Object generateAppErrorLog() {
        return null;
    }

    private static Object generateAppDisplay() {
        return null;
    }

    private static Object generateAppComment() {
        return null;
    }

    private static Object generateAppAd() {
        return null;
    }

    private static Object generateAppActiveBackground() {
        return null;
    }

    private static Object generateStartLog() {
        AppStart start = new AppStart();
        AppBase appBase = generateAppBase();
        Random random = new Random();
        start.setEn("start");
        start.setAction(random.nextBoolean() ? "1" : "2");
        return start;
    }
}
