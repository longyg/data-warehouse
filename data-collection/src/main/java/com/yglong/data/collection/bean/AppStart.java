package com.yglong.data.collection.bean;

/**
 * 启动日志数据
 */
public class AppStart extends AppBase {
    //入口：push=1，widget=2，icon=3，notification=4，lockscreen_widget=5
    private int entry;
    //开屏广告类型：开屏原生广告=1，开屏插屏广告=2
    private int openAdType;
    //状态：成功=1，失败=2
    private int action;
    //加载时长：计算下拉开始到接口返回数据的时间，（开始加载报0，加载成功或失败才上报时间）
    private long loadingTime;
    //失败码（没有则上报空）
    private String detail;
    //失败的message（没有则上报空）
    private String extend1;

    public int getEntry() {
        return entry;
    }

    public void setEntry(int entry) {
        this.entry = entry;
    }

    public int getOpenAdType() {
        return openAdType;
    }

    public void setOpenAdType(int openAdType) {
        this.openAdType = openAdType;
    }

    public int getAction() {
        return action;
    }

    public void setAction(int action) {
        this.action = action;
    }

    public long getLoadingTime() {
        return loadingTime;
    }

    public void setLoadingTime(long loadingTime) {
        this.loadingTime = loadingTime;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public String getExtend1() {
        return extend1;
    }

    public void setExtend1(String extend1) {
        this.extend1 = extend1;
    }

    public String getEn() {
        return en;
    }

    public void setEn(String en) {
        this.en = en;
    }

    //日志类型：start
    private String en;
}
