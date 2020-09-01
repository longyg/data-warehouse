package com.yglong.data.collection.bean;

/**
 * 广告事件：ad
 */
public class AppAd {
    //入口：商品列表页=1，应用首页=2，商品详情页=3
    private int entry;
    // 动作：广告展示=1，广告点击=2
    private int action;
    //Type：1=商品， 2=营销活动
    private int contentType;
    //展示时长：毫秒数
    private long displayMills;
    //商品ID
    private int itemId;
    //营销活动ID
    private int activityId;

    public int getEntry() {
        return entry;
    }

    public void setEntry(int entry) {
        this.entry = entry;
    }

    public int getAction() {
        return action;
    }

    public void setAction(int action) {
        this.action = action;
    }

    public int getContentType() {
        return contentType;
    }

    public void setContentType(int contentType) {
        this.contentType = contentType;
    }

    public long getDisplayMills() {
        return displayMills;
    }

    public void setDisplayMills(long displayMills) {
        this.displayMills = displayMills;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getActivityId() {
        return activityId;
    }

    public void setActivityId(int activityId) {
        this.activityId = activityId;
    }
}
