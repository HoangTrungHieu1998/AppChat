import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/component/app_utils.dart';
import 'package:skype_clone/const.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/resources/call_methods.dart';
import 'package:skype_clone/resources/chat_methods.dart';
import 'package:skype_clone/resources/storage_methods.dart';
import 'package:skype_clone/utils/call_utils.dart';

import '../../component/cache_image.dart';
import '../../component/custom_appbar.dart';
import '../../component/model_title.dart';
import '../../enum/view_state.dart';
import '../../logic/image_provider.dart';

class ChatDetail extends StatefulWidget {
  final UserModel receiver;

  const ChatDetail({Key? key, required this.receiver}) : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  TextEditingController textFieldController = TextEditingController();
  final AuthMethods authMethods = AuthMethods();
  final ChatMethods chatMethods = ChatMethods();
  final CallMethods callMethods = CallMethods();
  final StorageMethods storageMethods = StorageMethods();
  ScrollController scrollController = ScrollController();

  FocusNode textFieldFocus = FocusNode();

  UserModel? sender;
  String? currentUserId;
  String? token;
  late ImageUploadProvider imageUploadProvider;

  bool isWriting = false;
  bool showEmojiPicker = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    setState(() {
      currentUserId = authMethods.getCurrentUser()?.uid;
      sender = UserModel(uid: authMethods.getCurrentUser()?.uid, name: authMethods.getCurrentUser()?.displayName, profilePhoto: authMethods.getCurrentUser()?.photoURL);
    });
  }
  getToken(){
    callMethods.getToken().then((value){
      setState(() {
        token=value;
      });
    });
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  void pickImage({required ImageSource source}) async {
    File selectedImage = await AppUtils.pickImage(source: source);
    storageMethods.uploadImage(image: selectedImage, receiverId: widget.receiver.uid!, senderId: currentUserId!, imageUploadProvider: imageUploadProvider);
  }

  @override
  Widget build(BuildContext context) {
    imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return Scaffold(
      backgroundColor: AppThemes.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(right: 15),
                  child: const CircularProgressIndicator(),
                )
              : Container(),
          chatControls(),
          showEmojiPicker ? Container(child: emojiContainer()) : Container(),
        ],
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      config: const Config(columns: 7, bgColor: AppThemes.separatorColor, indicatorColor: AppThemes.blueColor, recentsLimit: 50),
      onEmojiSelected: (Category? category, Emoji emoji) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(Constant.messageCollection).doc(currentUserId).collection(widget.receiver.uid!).orderBy(Constant.timestampField, descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          scrollController.animateTo(scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
        });

        return ListView.builder(
          reverse: true,
          controller: scrollController,
          padding: const EdgeInsets.all(10),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message message = Message.fromJson(snapshot.data() as Map<String, dynamic>);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: message.senderId == currentUserId ? Alignment.centerRight : Alignment.centerLeft,
        child: message.senderId == currentUserId ? senderLayout(message) : receiverLayout(message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = const Radius.circular(10);

    return Container(
      margin: const EdgeInsets.only(top: 12),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: AppThemes.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = const Radius.circular(10);

    return Container(
      margin: const EdgeInsets.only(top: 12),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: AppThemes.gradientColorStart,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    print("TEST: ${message.photoUrl}");
    return message.type != Constant.imageMessage
        ? message.message == null
            ? const Text(
                "message has been recovered",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              )
            : Text(
                message.message!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              )
        : message.photoUrl != null && message.photoUrl!.isNotEmpty
            ? CachedImage(imageUrl: message.photoUrl!,height: 250,width: 250,radius: 10,)
            : const Text("Url was null");
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: AppThemes.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      RawMaterialButton(
                        child: const Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: const [
                      ModelTitle(
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image,
                      ),
                      ModelTitle(title: "File", subtitle: "Share files", icon: Icons.tab),
                      ModelTitle(title: "Contact", subtitle: "Share contacts", icon: Icons.contacts),
                      ModelTitle(title: "Location", subtitle: "Share a location", icon: Icons.add_location),
                      ModelTitle(title: "Schedule Call", subtitle: "Arrange a skype call and get reminders", icon: Icons.schedule),
                      ModelTitle(title: "Create Poll", subtitle: "Share polls", icon: Icons.poll)
                    ],
                  ),
                ),
              ],
            );
          });
    }

    sendMessage() {
      final text = textFieldController.text;
      Message message = Message(receiverId: widget.receiver.uid, senderId: sender!.uid, message: text, timestamp: Timestamp.now(), type: "Text");

      setState(() {
        isWriting = false;
      });

      textFieldController.clear();
      chatMethods.addMessageToDb(message, sender!, widget.receiver);
    }

    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                gradient: AppThemes.fabGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                  onTap: () => hideEmojiContainer(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (val) {
                    (val.isNotEmpty && val.trim() != "") ? setWritingTo(true) : setWritingTo(false);
                  },
                  decoration: const InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: AppThemes.greyColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: AppThemes.separatorColor,
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (!showEmojiPicker) {
                      // keyboard is visible
                      hideKeyboard();
                      showEmojiContainer();
                    } else {
                      //keyboard is hidden
                      showKeyboard();
                      hideEmojiContainer();
                    }
                  },
                  icon: const Icon(
                    Icons.face,
                    color: AppThemes.colorWhite,
                  ),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.record_voice_over,
                    color: AppThemes.colorWhite,
                  ),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  child: const Icon(Icons.camera_alt, color: AppThemes.colorWhite),
                  onTap: () => pickImage(source: ImageSource.camera),
                ),
          isWriting
              ? Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: const BoxDecoration(gradient: AppThemes.fabGradient, shape: BoxShape.circle),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () => sendMessage(),
                  ))
              : Container()
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name!,
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.video_call,
          ),
          onPressed: () => CallUtils.dial(from: sender, to: widget.receiver, context: context,token: token!),
        ),
        IconButton(
          icon: const Icon(
            Icons.phone,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
