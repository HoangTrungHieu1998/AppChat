import 'package:cloud_firestore/cloud_firestore.dart';

class Contact{
  String? uid;
  Timestamp? addedOn;

  Contact({
    this.uid,
    this.addedOn
  });

  factory Contact.fromJson(Map<String, dynamic> json){
    return Contact(
      uid: json["contact_id"],
      addedOn: json["added_on"],
    );
  }

  Map<String,dynamic> toJson(Contact call) {
    final data = <String, dynamic>{};
    data['contact_id'] = uid;
    data['added_on'] = addedOn;
    return data;
  }
}