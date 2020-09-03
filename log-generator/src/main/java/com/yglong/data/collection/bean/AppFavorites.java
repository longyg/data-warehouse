package com.yglong.data.collection.bean;

/**
 * 收藏：favorites
 */
public class AppFavorites {
    //主键 （int，10）不允许空
    private int id;
    //商品id（int，10）缺省值为0
    private int courseId;
    //用户id（int，10）缺省值为0
    private int userId;
    //创建时间（string）
    private String addTime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAddTime() {
        return addTime;
    }

    public void setAddTime(String addTime) {
        this.addTime = addTime;
    }
}
