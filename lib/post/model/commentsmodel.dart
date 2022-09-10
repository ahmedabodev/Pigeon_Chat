class commentsmodel{
  String? comment;
  String? name ;
  String? photo;
  dynamic time;

  commentsmodel(this.comment, this.name, this.photo,this.time);
  factory commentsmodel.forJson(json){
    return commentsmodel(json['comment'],json['name'],json['photo'],json['Time']);
  }
}