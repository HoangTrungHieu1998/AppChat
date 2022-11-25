import 'package:cloud_firestore/cloud_firestore.dart';

import '../const.dart';
import '../models/contact.dart';
import '../models/message.dart';
import '../models/user.dart';

class ChatMethods{
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollection = firestore.collection(Constant.userCollection);
  static final CollectionReference _messageCollection = firestore.collection(Constant.messageCollection);

  Future<DocumentReference<Map<String, dynamic>>> addMessageToDb (Message message, UserModel sender, UserModel receiver) async{
    final map = message.toMap();

    await firestore
        .collection(Constant.messageCollection)
        .doc(message.senderId)
        .collection(message.receiverId!)
        .add(map as Map<String,dynamic>);
    
    addToContacts(senderId: message.senderId!, receiverId: message.receiverId!);

    return await firestore
        .collection(Constant.messageCollection)
        .doc(message.receiverId)
        .collection(message.senderId!)
        .add(map);
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await firestore
        .collection(Constant.messageCollection)
        .doc(message.senderId)
        .collection(message.receiverId!)
        .add(map as Map<String, dynamic>);

    firestore
        .collection(Constant.messageCollection)
        .doc(message.receiverId)
        .collection(message.senderId!)
        .add(map);
  }

  DocumentReference getContactsDocument({required String of, required String forContact}) =>
      _userCollection
          .doc(of)
          .collection(Constant.contactCollection)
          .doc(forContact);

  addToContacts({required String senderId,required  String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
      String senderId,
      String receiverId,
      currentTime,
      ) async {
    DocumentSnapshot senderSnapshot =
    await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toJson(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
      String senderId,
      String receiverId,
      currentTime,
      ) async {
    DocumentSnapshot receiverSnapshot =
    await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toJson(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  Stream<QuerySnapshot> fetchContacts({required String userId}) => _userCollection
      .doc(userId)
      .collection(Constant.contactCollection)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    required String senderId,
    required String receiverId,
  }) =>
      _messageCollection
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}