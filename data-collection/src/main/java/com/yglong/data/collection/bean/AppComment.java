package com.yglong.data.collection.bean;

/**
 * 评论事件：comment
 */
public class AppComment {
    //评论表 （int， 长度10），不允许空
    private int commentId;
    //用户id （int，长度10），缺省值为0
    private int userId;
    //父级评论id（为0则是一级评论，不为0则是回复） （int，长度10）
    private int pCommentId;
    //评论内容 （string，长度1000）
    private String content;
    //创建时间（string）
    private String addTime;
    //评论的相关id （int，长度10）
    private int otherId;
    //点赞数量（int，长度10） 缺省值为0
    private int praiseCount;
    //回复数量（int，长度10） 缺省值为0
    private int replyCount;

    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getpCommentId() {
        return pCommentId;
    }

    public void setpCommentId(int pCommentId) {
        this.pCommentId = pCommentId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAddTime() {
        return addTime;
    }

    public void setAddTime(String addTime) {
        this.addTime = addTime;
    }

    public int getOtherId() {
        return otherId;
    }

    public void setOtherId(int otherId) {
        this.otherId = otherId;
    }

    public int getPraiseCount() {
        return praiseCount;
    }

    public void setPraiseCount(int praiseCount) {
        this.praiseCount = praiseCount;
    }

    public int getReplyCount() {
        return replyCount;
    }

    public void setReplyCount(int replyCount) {
        this.replyCount = replyCount;
    }
}
