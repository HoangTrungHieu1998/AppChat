class UserModel{
  String? uid;
  String? name;
  String? email;
  String? username;
  String? status;
  int? state;
  String? profilePhoto;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      name: json["name"],
      email: json["email"],
      profilePhoto: json["profile_photo"],
      username: json["username"],
      uid: json["uid"],
      status: json["status"],
      state: json["state"],
    );
  }

  Map toJson(UserModel user) {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['profile_photo'] = profilePhoto;
    data['username'] = username;
    data['status'] = status;
    data['state'] = state;
    return data;
  }
}