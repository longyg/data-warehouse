package com.yglong.data.collection.bean;

/**
 * 用户后台活跃事件：active_background
 */
public class AppActiveBackground {
    //1=upgrade，2=download，3=plugin_upgrade
    private String activeSource;

    public String getActiveSource() {
        return activeSource;
    }

    public void setActiveSource(String activeSource) {
        this.activeSource = activeSource;
    }
}
