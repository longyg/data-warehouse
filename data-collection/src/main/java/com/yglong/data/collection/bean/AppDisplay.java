package com.yglong.data.collection.bean;

/**
 * 商品点击：display
 */
public class AppDisplay {
    //动作：曝光商品=1，点击商品=2
    private int action;
    //商品ID（服务端发下的ID）
    private int goodsid;
    //顺序（第几条商品，第一条为0，第二条为1，如此类推）
    private int place;
    //曝光类型：1-首次曝光，2-重复曝光
    private int extend1;
    //分类ID（服务端定义的分类ID）
    private int category;

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

    public int getPlace() {
        return place;
    }

    public void setPlace(int place) {
        this.place = place;
    }

    public int getExtend1() {
        return extend1;
    }

    public void setExtend1(int extend1) {
        this.extend1 = extend1;
    }

    public int getCategory() {
        return category;
    }

    public void setCategory(int category) {
        this.category = category;
    }
}
