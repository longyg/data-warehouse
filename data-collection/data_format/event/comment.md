评论（comment）

事件标签：comment

comment_id：   评论表 （int， 长度10），不允许空

userid：       用户id （int，长度10），缺省值为0

p_comment_id： 父级评论id（为0则是一级评论，不为0则是回复） （int，长度10）

content：      评论内容 （string，长度1000）

addtime：      创建时间（string）

other_id：     评论的相关id （int，长度10）

praise_count： 点赞数量（int，长度10） 缺省值为0

reply_count:   回复数量（int，长度10） 缺省值为0