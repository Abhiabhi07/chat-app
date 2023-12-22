import 'package:chat/controller/chat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUid;
  final bool isGroupChat;
  const BottomChatField({
    super.key,
    required this.receiverUid,
    required this.isGroupChat,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSend = true;
  final TextEditingController _messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  // FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;

  void sendTextMessage() async {
    if (isShowSend) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUid,
            widget.isGroupChat,
          );
      setState(() {
        _messageController.clear();
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();

  //   // _soundRecorder = FlutterSoundRecorder();
  //   // openAudio();
  // }

  // void openAudio() async {
  //   final status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     throw RecordingPermissionException('Mic permission not allowed');
  //   }
  //   await _soundRecorder!.openRecorder();
  //   isRecorderInit = true;
  // }

  // void sendTextMessage() async {
  //   if (isShowSend) {
  //     ref.read(chatControllerProvider).sendTextMessage(
  //           context,
  //           _messageController.text.trim(),
  //           widget.recieverUserId,
  //           widget.isGroupChat,
  //         );
  //     setState(() {
  //       _messageController.text = '';
  //     });
  //   } else {
  //     var tempDir = await getTemporaryDirectory();
  //     var path = '${tempDir.path}/flutter_sound.aac';
  //     if (!isRecorderInit) {
  //       return;
  //     }
  //     if (isRecording) {
  //       await _soundRecorder!.stopRecorder();
  //       sendFileMessage(File(path), MessageEnum.audio);
  //     } else {
  //       await _soundRecorder!.startRecorder(
  //         toFile: path,
  //       );
  //     }
  //     setState(() {
  //       isRecording = !isRecording;
  //     });
  //   }
  // }

  // void sendFileMessage(
  //   File file,
  //   MessageEnum messageEnum,
  // ) {
  //   ref.read(chatControllerProvider).sendFileMessage(
  //         context,
  //         file,
  //         widget.recieverUserId,
  //         messageEnum,
  //         widget.isGroupChat,
  //       );
  // }

  void showKeyboard() => focusNode.requestFocus();

  void hideKeyboard() => focusNode.unfocus();

  // void selectImage() async {
  //   File? image = await pickImageFromGallery(context);
  //   if (image != null) {
  //     sendFileMessage(image, MessageEnum.image);
  //   }
  // }

  // void selectVideo() async {
  //   File? video = await pickVideoFromGallery(context);
  //   if (video != null) {
  //     sendFileMessage(video, MessageEnum.video);
  //   }
  // }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    // _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    // final messageReplay = ref.watch(messageReplyProvider);
    // final isShowMessageReply = messageReplay != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: TextFormField(
              focusNode: focusNode,
              controller: _messageController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Your message...',
                  hintStyle: TextStyle(color: Colors.teal, fontSize: 16),
                  prefixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //  mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: Icon(Icons.emoji_emotions_outlined)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.gif))
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.attach_file)),
                        IconButton(
                            onPressed: () {}, icon: Icon(CupertinoIcons.camera))
                      ],
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(40),
                  )),
              onChanged: (v) {
                if (v.isNotEmpty || v != null) {
                  setState(() {
                    isShowSend = true;
                  });
                } else {
                  setState(() {
                    isShowSend = false;
                  });
                }
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            radius: 25,
            // backgroundColor: Colors.amber,
            child: Center(
                child: GestureDetector(
              onTap: sendTextMessage,
              child: isShowSend
                  ? Image.network(
                      'https://cdn-icons-png.flaticon.com/128/3024/3024593.png',
                      fit: BoxFit.cover,
                      height: 25,
                    )
                  : Icon(CupertinoIcons.share_solid
                      // : isRecording
                      //     ? Icons.close
                      //     : Icons.mic,
                      // color: Colors.teal,
                      ),
            )),
          ),
        ),
      ],
    );
  }
}
