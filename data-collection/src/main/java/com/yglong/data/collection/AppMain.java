package com.yglong.data.collection;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.yglong.data.collection.bean.*;
import lombok.extern.slf4j.Slf4j;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.util.Random;
import java.util.concurrent.TimeUnit;

@Slf4j
public class AppMain {

    private static Random random = new Random();

    private static int s_mid = 0;
    private static int goodsid = 0;
    private static int s_uid = 0;

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
            if (random.nextBoolean()) {
                AppStart appStart = generateStartLog();
                log.info(JSON.toJSONString(appStart));
            } else {
                JSONObject json = generateEventLog();
                log.info(System.currentTimeMillis() + "|" + JSON.toJSONString(json));
            }

            if (interval > 0) {
                try {
                    TimeUnit.SECONDS.sleep(interval);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private static JSONObject generateEventLog() {
        JSONObject eventLog = new JSONObject();
        eventLog.put("ap", "app");
        eventLog.put("cm", generateCommonFields());
        eventLog.put("et",  generateEvents());
        return eventLog;
    }

    private static JSONArray generateEvents() {
        JSONArray events = new JSONArray();

        if (random.nextBoolean()) {
            events.add(generateAppDisplay());
        }
        if (random.nextBoolean()) {
            events.add(generateAppPraise());
        }
        if (random.nextBoolean()) {
            events.add(generateAppActiveBackground());
        }
        if (random.nextBoolean()) {
            events.add(generateAppAd());
        }
        if (random.nextBoolean()) {
            events.add(generateAppComment());
        }
        if (random.nextBoolean()) {
            events.add(generateAppErrorLog());
        }
        if (random.nextBoolean()) {
            events.add(generateAppFavorites());
        }
        if (random.nextBoolean()) {
            events.add(generateAppLoading());
        }
        if (random.nextBoolean()) {
            events.add(generateAppNewsDetail());
        }
        if (random.nextBoolean()) {
            events.add(generateAppNotification());
        }

        return events;
    }

    private static AppBase generateCommonFields() {
        AppBase appBase = new AppBase();

        // 设备id
        appBase.setMid(s_mid + "");
        s_mid++;

        // 用户id
        appBase.setUid(s_uid + "");
        s_uid++;

        // 程序版本号
        appBase.setVc("" + random.nextInt(20));
        // 程序版本名
        appBase.setVn("1." + random.nextInt(4) + "." + random.nextInt(10));
        // 安卓系统版本
        appBase.setOs("8." + random.nextInt(3) + "." + random.nextInt(10));

        // 语言
        int flag = random.nextInt(3);
        switch (flag) {
            case 0:
                appBase.setL("es");
                break;
            case 1:
                appBase.setL("en");
                break;
            case 2:
                appBase.setL("pt");
                break;
        }

        // 渠道号
        appBase.setSr(getRandomChar(1));

        // 区域
        appBase.setAr(random.nextBoolean() ? "BR" : "MX");

        //手机品牌 ba
        //手机型号 md
        flag = random.nextInt(3);
        switch (flag) {
            case 0:
                appBase.setBa("Sumsung");
                appBase.setMd("Sumsung-" + random.nextInt(20));
                break;
            case 1:
                appBase.setBa("Huawei");
                appBase.setMd("Huawei-" + random.nextInt(20));
                break;
            case 2:
                appBase.setBa("HTC");
                appBase.setMd("HTC-" + random.nextInt(20));
                break;
        }

        // sdk version
        appBase.setSv("V2." + random.nextInt(10) + "." + random.nextInt(10));

        // gmail
        appBase.setG(getRandomCharAndNumber(8) + "@gmail.com");

        //屏幕宽高
        flag = random.nextInt(4);
        switch (flag) {
            case 0:
                appBase.setHw("640*960");
                break;
            case 1:
                appBase.setHw("640*1136");
                break;
            case 2:
                appBase.setHw("750*1134");
                break;
            case 3:
                appBase.setHw("1080*1920");
                break;
        }

        // 客户端日志产生时间
        appBase.setT("" + (System.currentTimeMillis() - random.nextInt(99999999)));

        // 手机网络模式 3G 4G WIFI
        flag = random.nextInt(3);
        switch (flag) {
            case 0:
                appBase.setNw("3G");
                break;
            case 1:
                appBase.setNw("4G");
                break;
            case 2:
                appBase.setNw("WIFI");
                break;
        }

        // 经度
        appBase.setLn((-34 - random.nextInt(83) - random.nextInt(60) / 10.0) + "");
        // 纬度
        appBase.setLa((32 - random.nextInt(85) - random.nextInt(60) / 10.0) + "");

        return appBase;
    }

    private static String getRandomCharAndNumber(int length) {
        StringBuilder str = new StringBuilder();
        for (int i = 0; i < length; i++) {
            if (random.nextBoolean()) {
                str.append((char) (65 + random.nextInt(26)));
            } else {
                str.append(String.valueOf(random.nextInt(10)));
            }
        }
        return str.toString();
    }

    /**
     * 随机大写字母组合
     * @param length
     * @return
     */
    private static String getRandomChar(int length) {
        StringBuilder str = new StringBuilder();
        for (int i = 0; i < length; i++) {
            str.append((char) (65 + random.nextInt(26)));
        }
        return str.toString();
    }


    private static Object generateAppLoading() {
        AppLoading loading = new AppLoading();
        loading.setAction("" + (random.nextInt(3) + 1));
        loading.setLoadingTime("" + (random.nextInt(10) * random.nextInt(7)));
        loading.setType1(getFailedCode());
        loading.setLoadingWay("" + (random.nextInt(2) + 1));
        loading.setExtend1("");
        loading.setExtend2("");
        loading.setType("" + (random.nextInt(3) + 1));
        return createEventJson("loading", loading);
    }

    private static Object generateAppPraise() {
        AppPraise praise = new AppPraise();
        praise.setId(random.nextInt(10));
        praise.setUserId(random.nextInt(10));
        praise.setTargetId(random.nextInt(10));
        praise.setType(random.nextInt(4) + 1);
        praise.setAddTime("" + (System.currentTimeMillis() - random.nextInt(99999999)));
        return createEventJson("praise", praise);
    }

    private static Object generateAppNotification() {
        AppNotification notification = new AppNotification();
        notification.setAction("" + (random.nextInt(4) + 1));
        notification.setType("" + (random.nextInt(4) + 1));
        notification.setApTime("" + (System.currentTimeMillis() - random.nextInt(99999999)));
        notification.setContent("");
        return createEventJson("notification", notification);
    }

    private static Object generateAppNewsDetail() {
        AppNewsDetail newsDetail = new AppNewsDetail();
        newsDetail.setEntry("" + (random.nextInt(3) + 1));
        newsDetail.setAction("" + (random.nextInt(4) + 1));
        newsDetail.setGoodsid(goodsid + "");
        newsDetail.setShowType("" + random.nextInt(6));
        newsDetail.setNewsStayTime("" + (random.nextInt(10) * random.nextInt(7)));
        newsDetail.setLoadingTime("" + (random.nextInt(10) * random.nextInt(7)));
        newsDetail.setType1(getFailedCode());
        newsDetail.setCategory("" + (random.nextInt(100) + 1));
        return createEventJson("newsdetail", newsDetail);
    }

    private static Object generateAppFavorites() {
        AppFavorites favorites = new AppFavorites();
        favorites.setId(random.nextInt(10));
        favorites.setCourseId(random.nextInt(10));
        favorites.setUserId(random.nextInt(10));
        favorites.setAddTime("" + (System.currentTimeMillis() - random.nextInt(99999999)));
        return createEventJson("favorites", favorites);
    }

    private static Object generateAppErrorLog() {
        AppErrorLog errorLog = new AppErrorLog();
        return createEventJson("errorlog", errorLog);
    }

    private static JSONObject generateAppDisplay() {
        AppDisplay appDisplay = new AppDisplay();

        // 曝光商品，几率比点击商品高
        appDisplay.setAction(random.nextInt(10) < 7 ? "1" : "2");
        appDisplay.setGoodsid(goodsid + "");
        appDisplay.setPlace(random.nextInt(6) + "");
        appDisplay.setExtend1("" + (random.nextInt(2) + 1));
        appDisplay.setCategory("" + (random.nextInt(100) + 1));
        goodsid++;

        return createEventJson("display", appDisplay);
    }

    private static Object generateAppComment() {
        AppComment comment = new AppComment();
        comment.setCommentId(random.nextInt(10));
        comment.setUserId(random.nextInt(10));
        comment.setpCommentId(random.nextInt(5));
        comment.setContent(getContent());
        comment.setAddTime("" + (System.currentTimeMillis() - random.nextInt(99999999)));
        comment.setOtherId(random.nextInt(10));
        comment.setPraiseCount(random.nextInt(1000));
        comment.setReplyCount(random.nextInt(200));
        return createEventJson("comment", comment);
    }

    private static String getContent() {
        StringBuilder str = new StringBuilder();
        for (int i = 0; i < random.nextInt(100); i++) {
            str.append(getRandomChar());
        }
        return str.toString();
    }

    private static char getRandomChar() {
        String str = "";
        int highPos, lowPos;
        highPos = (176 + Math.abs(random.nextInt(39)));
        lowPos = (161 + Math.abs(random.nextInt(93)));
        byte[] b = new byte[2];
        b[0] = (Integer.valueOf(highPos)).byteValue();
        b[1] = (Integer.valueOf(lowPos)).byteValue();

        try {
            str = new String(b, "GBK");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return str.charAt(0);
    }

    private static Object generateAppAd() {
        AppAd ad = new AppAd();
        ad.setEntry("" + (random.nextInt(3) + 1));
        ad.setAction("" + (random.nextInt(5) + 1));
        ad.setDisplayMills("" + (random.nextInt(120000) + 1000));
        int flag = random.nextInt(2) + 1;
        ad.setContentType(flag + "");
        if (flag == 1) {
            ad.setItemId("" + random.nextInt(6));
        } else {
            ad.setActivityId("" + (random.nextInt(1) + 1));
        }
        return createEventJson("ad", ad);
    }

    private static Object generateAppActiveBackground() {
        AppActiveBackground appActiveBackground = new AppActiveBackground();
        appActiveBackground.setActiveSource("" + (random.nextInt(3) + 1));
        return createEventJson("active_background", appActiveBackground);
    }

    private static JSONObject createEventJson(String eventName, Object kv) {
        JSONObject event = new JSONObject();
        event.put("ett", System.currentTimeMillis() + "");
        event.put("en", eventName);
        event.put("kv", kv);
        return event;
    }

    private static AppStart generateStartLog() {
        AppStart start = new AppStart();
        AppBase appBase = generateCommonFields();

        for (Field declaredField : appBase.getClass().getDeclaredFields()) {
            declaredField.setAccessible(true);
            String fieldName = declaredField.getName();

            for (Field field : start.getClass().getSuperclass().getDeclaredFields()) {
                field.setAccessible(true);
                String name = field.getName();
                if (name.equals(fieldName)) {
                    try {
                        field.set(start, declaredField.get(appBase));
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        start.setEn("start");
        start.setEntry("" + (random.nextInt(5) + 1));
        start.setOpenAdType("" + (random.nextInt(2) + 1));
        start.setAction("" + (random.nextInt(10) > 8 ? 2 : 1));
        start.setLoadingTime(random.nextInt(20) + "");
        start.setDetail(getFailedCode());
        start.setExtend1("");

        return start;
    }

    private static String getFailedCode() {
        int flag;
        String code = "";
        flag = random.nextInt(10);
        switch (flag) {
            case 1:
                code = "102";
                break;
            case 2:
                code = "201";
                break;
            case 3:
                code = "325";
                break;
            case 4:
                code = "433";
                break;
            case 5:
                code = "542";
                break;
            default:
                code = "";
                break;
        }
        return code;
    }
}
