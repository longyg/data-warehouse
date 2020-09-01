package com.yglong.data.collection.bean;

/**
 * 点赞事件：praise
 */
public class AppPraise {
    //主键id（int，10）不允许空
    private int id;
    //用户id（int，10）
    private int userId;
    //点赞的对象id（int，10）
    private int targetId;
    //点赞类型 1：问答点赞 2：问答评论点赞 3：文章点赞 4：评论点赞 （int，10）
    private int type;
    //添加时间（string）
    private String addTime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getTargetId() {
        return targetId;
    }

    public void setTargetId(int targetId) {
        this.targetId = targetId;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getAddTime() {
        return addTime;
    }

    public void setAddTime(String addTime) {
        this.addTime = addTime;
    }
}
