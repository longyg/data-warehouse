package com.yglong.data.collection.bean;

/**
 * 商品详情页：newsdetail
 */
public class AppNewsDetail {
    //页面入口来源：应用首页=1，push=2，详情页相关推荐=3
    private String entry;
    //动作：开始加载=1，加载成功=2，加载失败=3，退出页面=4
    private String action;
    //商品ID（服务端下发的ID）
    private String goodsid;
    //商品样式：0、无图，1、一张大图，2、两张图，3、三张小图，4、一张小图，5、一张大图两张小图
    private String showType;
    //页面停留时长：从商品开始加载时开始计算，用到户关闭页面所有的时间。
    // 若中途用跳转到其他页面了，则暂停计时，待回到详情页时恢复计时。
    // 或中途划出的时间超过10秒，则本次计时作废，不上报本次数据。如未加载成功退出，则保空
    private String newsStayTime;
    //加载时长：计算页面开始加载到接口返回数据的时间（开始加载报0，加载成功或加载失败才上报时间）
    private String loadingTime;
    //加载失败码：把加载失败状态码报回来（报空为加载成功，没有失败）
    private String type1;
    //分类ID（服务端d定义的分类ID）
    private String category;

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

    public String getGoodsid() {
        return goodsid;
    }

    public void setGoodsid(String goodsid) {
        this.goodsid = goodsid;
    }

    public String getShowType() {
        return showType;
    }

    public void setShowType(String showType) {
        this.showType = showType;
    }

    public String getNewsStayTime() {
        return newsStayTime;
    }

    public void setNewsStayTime(String newsStayTime) {
        this.newsStayTime = newsStayTime;
    }

    public String getLoadingTime() {
        return loadingTime;
    }

    public void setLoadingTime(String loadingTime) {
        this.loadingTime = loadingTime;
    }

    public String getType1() {
        return type1;
    }

    public void setType1(String type1) {
        this.type1 = type1;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}
