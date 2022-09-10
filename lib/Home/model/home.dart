class Home{
  String? name;
  String? email;
  String photo;
  String token;
  List<String>followers=[];

  Home(this.name,this.email,this.photo,this.token,this.followers);


  factory Home.fromJson( json) {
    return Home(
      json['name'] ,
      json['email'] ,
      json['photo'],
      json['token'],
        List<String>.from(json['followers'].map((e) => e))



    );
  }
}
