class Mainhome{
  String? name;
  String? email;
  String photo;
  String token;
  dynamic timenow;
  dynamic numberofmessage;
  String lastmessage;
  Mainhome(this.name,this.email,this.photo,this.token,this.lastmessage,this.numberofmessage,this.timenow);


  factory Mainhome.fromJson( json) {
    return Mainhome(json['name'] ,json['email'] ,json['photo'],json['token'],json['lastmessage'],json['numberofmessage'],json['timenow']
    );
  }
}