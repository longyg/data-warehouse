package com.yglong.data.collection.bean;

/**
 * 商品详情页：newsdetail
 */
public class AppNewsDetail {
    //页面入口来源：应用首页=1，push=2，详情页相关推荐=3
    private int entry;
    //动作：开始加载=1，加载成功=2，加载失败=3，退出页面=4
    private int action;
    //商品ID（服务端下发的ID）
    private int goodsid;
    //商品样式：0、无图，1、一张大图，2、两张图，3、三张小图，4、一张小图，5、一张大图两张小图
    private int showStyle;
    //页面停留时长：从商品开始加载时开始计算，用到户关闭页面所有的时间。
    // 若中途用跳转到其他页面了，则暂停计时，待回到详情页时恢复计时。
    // 或中途划出的时间超过10秒，则本次计时作废，不上报本次数据。如未加载成功退出，则保空
    private long newsStayTime;
    //加载时长：计算页面开始加载到接口返回数据的时间（开始加载报0，加载成功或加载失败才上报时间）
    private long loadingTime;
    //加载失败码：把加载失败状态码报回来（报空为加载成功，没有失败）
    private String type1;
    //分类ID（服务端d定义的分类ID）
    private int category;

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

    public int getGoodsid() {
        return goodsid;
    }

    public void setGoodsid(int goodsid) {
        this.goodsid = goodsid;
    }

    public int getShowStyle() {
        return showStyle;
    }

    public void setShowStyle(int showStyle) {
        this.showStyle = showStyle;
    }

    public long getNewsStayTime() {
        return newsStayTime;
    }

    public void setNewsStayTime(long newsStayTime) {
        this.newsStayTime = newsStayTime;
    }

    public long getLoadingTime() {
        return loadingTime;
    }

    public void setLoadingTime(long loadingTime) {
        this.loadingTime = loadingTime;
    }

    public String getType1() {
        return type1;
    }

    public void setType1(String type1) {
        this.type1 = type1;
    }

    public int getCategory() {
        return category;
    }

    public void setCategory(int category) {
        this.category = category;
    }
}
