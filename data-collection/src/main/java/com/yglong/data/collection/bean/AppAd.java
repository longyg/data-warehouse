package com.yglong.data.collection.bean;

/**
 * 广告事件：ad
 */
public class AppAd {
    //入口：商品列表页=1，应用首页=2，商品详情页=3
    private String entry;
    // 动作：广告展示=1，广告点击=2
    private String action;
    //Type：1=商品， 2=营销活动
    private String contentType;
    //展示时长：毫秒数
    private String displayMills;
    //商品ID
    private String itemId;
    //营销活动ID
    private String activityId;

    public String getEntry() {
        return entry;
    }

    public void setEntry(String entry) {
        this.entry = entry;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getDisplayMills() {
        return displayMills;
    }

    public void setDisplayMills(String displayMills) {
        this.displayMills = displayMills;
    }

    public String getItemId() {
        return itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }
}
