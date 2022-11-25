import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone/component/app_utils.dart';

import '../const.dart';
import '../enum/user_state.dart';
import '../models/user.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>["email"]
  );
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollection = firestore.collection(Constant.userCollection);
  UserModel userModel = UserModel();

  User? getCurrentUser(){
    print("A: ${_auth.currentUser}");
    return _auth.currentUser;
  }

  Future<UserModel> getUserDetails() async {
    User? currentUser = getCurrentUser();

    DocumentSnapshot documentSnapshot =
    await _userCollection.doc(currentUser!.uid).get();

    return UserModel.fromJson(documentSnapshot.data() as Map<String,dynamic>);
  }

  Future<UserModel?> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
      await _userCollection.doc(id).get();
      return UserModel.fromJson(documentSnapshot.data() as Map<String,dynamic>);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    print("AAA:$googleUser");

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  Future<UserCredential?> signInWithFacebook() async {
    //Trigger the authentication flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    print("Hello:${loginResult.accessToken!.token}");

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }

  Future<UserCredential?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }

  Future<bool> authenticateUser (UserCredential user) async{
    QuerySnapshot result = await firestore
        .collection(Constant.userCollection).where(Constant.emailField,isEqualTo: user.user?.email).get();
    final List<DocumentSnapshot> docs = result.docs;

    // If user is register then doc is not empty
    return docs.isEmpty ? true:false;
  }

  Future<void> addDataToDB (UserCredential user) async{
    userModel = UserModel(
        uid: user.user?.uid,
        name: user.user?.displayName ?? user.user?.email,
        email: user.user?.email,
        username: user.user?.email
    );
    firestore.collection(Constant.userCollection).doc(user.user!.uid).set(userModel.toJson(userModel) as Map<String,dynamic>);
  }

  Future<List<UserModel>> fetchAllUsers(User currentUser) async {
    List<UserModel> userList = [];

    final querySnapshot = await firestore.collection(Constant.userCollection).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(UserModel.fromJson(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void setUserState({required String userId, required UserState userState}) {
    int stateNum = AppUtils.stateToNum(userState);

    _userCollection.doc(userId).update({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({required String uid}) =>
      _userCollection.doc(uid).snapshots();
}