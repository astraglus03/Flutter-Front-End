import 'package:chatview/chatview.dart';

class Data {
  static const profileImage = "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png";

  static final messageList = [
    Message(
      id: '1',
      message: "안녕하세요! 저는 Dimple 챗봇입니다. 무엇을 도와드릴까요?",
      createdAt: DateTime.now(),
      // status: MessageStatus.read,
      sentBy: '2',
    ),
  ];

  static final chatBotUser = ChatUser(
    id: '2',
    name: 'Dimple 챗봇',
    profilePhoto: profileImage,
  );

  static final currentUser = ChatUser(
    id: '1',
    name: '현재 사용자',
    profilePhoto: profileImage,
  );
}
