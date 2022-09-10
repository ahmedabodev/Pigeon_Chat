class postmodel{
  String? name;
  String? photo;
  String? postphoto;
  String? mypost;
  String? email;
  dynamic Time;


  postmodel(
    this.name,
    this.photo,
    this.postphoto,
    this.mypost,
      this.Time,
      this.email,
  );

  factory postmodel.fromJson( json) {
    return postmodel(json['name'] ,json['photo'] ,json['postphoto'],json['mypost'],json['Time'],json['email']
    );
  }

}
