package com.yglong.data.collection.bean;

/**
 * 商品点击：display
 */
public class AppDisplay {
    //动作：曝光商品=1，点击商品=2
    private String action;
    //商品ID（服务端发下的ID）
    private String goodsid;
    //顺序（第几条商品，第一条为0，第二条为1，如此类推）
    private String place;
    //曝光类型：1-首次曝光，2-重复曝光
    private String extend1;
    //分类ID（服务端定义的分类ID）
    private String category;

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

    public String getPlace() {
        return place;
    }

    public void setPlace(String place) {
        this.place = place;
    }

    public String getExtend1() {
        return extend1;
    }

    public void setExtend1(String extend1) {
        this.extend1 = extend1;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}
