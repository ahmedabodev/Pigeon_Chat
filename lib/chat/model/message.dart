class Message{
   String? message;
   String? email;
   Message(this.message,this.email);


  factory Message.fromJson( json) {
    return Message(json['message'] ,json['email'] ,
    );
  }
}