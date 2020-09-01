package com.yglong.data.collection.bean;

/**
 * 消息通知：notification
 */
public class AppNotification {
    //动作：通知产生=1，通知弹出=2，通知点击=3，常驻通知展示（不重复上报，一天之内只报一次）=4
    private int action;
    //通知id：预警通知=1，天气预报（早=2，晚=3），常驻=4
    private int type;
    //客户端弹出时间
    private String apTime;
    //备用字段
    private String content;

    public int getAction() {
        return action;
    }

    public void setAction(int action) {
        this.action = action;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getApTime() {
        return apTime;
    }

    public void setApTime(String apTime) {
        this.apTime = apTime;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
