import 'package:dimple/common/const/colors.dart';
import 'package:dimple/common/const/theme.dart';
import 'package:dimple/chatbot/view/data.dart';
import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class ChatbotScreen extends StatefulWidget {
  static String get routeName => 'chatbot';
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey = GlobalKey<SliderDrawerState>();

  AppTheme theme = LightTheme();
  bool isDarkTheme = false;
  final _chatController = ChatController(
    initialMessageList: Data.messageList,
    scrollController: ScrollController(),
    currentUser: Data.currentUser,
    otherUsers: [Data.chatBotUser],
  );

  String title = "쿠룽";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: true,
        bottom: false,
        child: SliderDrawer(
          key: _sliderDrawerKey,
          appBar: SliderAppBar(
            appBarPadding: EdgeInsets.only(top: 0.0),
            appBarHeight: 50,
            title: Text(
              title,
              style: TextStyle(
                color: theme.appBarTitleTextStyle,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.25,
              ),
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
                onPressed: (){
              // TODO: 새로운 채팅 시작
                },
                icon: Icon(Icons.add)),
          ),
          slider: _buildSliderMenu(),
          child: _buildMainContent(),
        ),
      ),
    );
  }

  Widget _buildSliderMenu(){
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: theme.appBarColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/img/banreou.png'),
              ),
              const SizedBox(height: 10),
              Text(
                '쿠룽',
                style: TextStyle(
                  color: theme.appBarTitleTextStyle,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.chat),
              title: Text('$index 대화기록 입니다.'),
              onTap: () {
                // 선택된 항목에 대한 동작
                _sliderDrawerKey.currentState?.closeSlider();
                setState(() {
                  title = '$index 대화기록';
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMainContent(){
    return ChatView(
      chatController: _chatController,
      onSendTap: _onSendTap,
      featureActiveConfig: FeatureActiveConfig(
        lastSeenAgoBuilderVisibility: true,
        receiptsBuilderVisibility: true,
        enableScrollToBottomButton: true,
        enableSwipeToSeeTime: true,
      ),
      scrollToBottomButtonConfig: ScrollToBottomButtonConfig(
        backgroundColor: theme.textFieldBackgroundColor,
        border: Border.all(
          color: isDarkTheme ? Colors.transparent : Colors.grey,
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: theme.themeIconColor,
          weight: 10,
          size: 30,
        ),
      ),
      chatViewState: ChatViewState.hasMessages,
      chatViewStateConfig: ChatViewStateConfiguration(
        loadingWidgetConfig: ChatViewStateWidgetConfiguration(
          loadingIndicatorColor: theme.outgoingChatBubbleColor,
        ),
        onReloadButtonTap: () {},
      ),
      typeIndicatorConfig: TypeIndicatorConfiguration(
        flashingCircleBrightColor: theme.flashingCircleBrightColor,
        flashingCircleDarkColor: theme.flashingCircleDarkColor,
      ),
      // appBar: ChatViewAppBar(
      //   elevation: theme.elevation,
      //   backGroundColor: theme.appBarColor,
      //   backArrowColor: theme.backArrowColor,
      //   chatTitle: "\t \t \t \t \t \t \t \t \t \t \t \t \t 쿠룽",
      //   chatTitleTextStyle: TextStyle(
      //     color: theme.appBarTitleTextStyle,
      //     fontWeight: FontWeight.bold,
      //     fontSize: 18,
      //     letterSpacing: 0.25,
      //   ),
      // ),
      chatBackgroundConfig: ChatBackgroundConfiguration(
        messageTimeIconColor: theme.messageTimeIconColor,
        messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
        defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
          chatSeparatorDatePattern: 'MM.dd',
          // TODO: 여기부분에서 Today가 오늘날짜 되도록 설정해야함.
          textStyle: TextStyle(
            color: theme.chatHeaderColor,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      sendMessageConfig: SendMessageConfiguration(
        imagePickerIconsConfig: ImagePickerIconsConfiguration(
          cameraIconColor: theme.cameraIconColor,
          galleryIconColor: theme.galleryIconColor,
        ),
        replyMessageColor: theme.replyMessageColor,
        defaultSendButtonColor: theme.sendButtonColor,
        replyDialogColor: theme.replyDialogColor,
        replyTitleColor: theme.replyTitleColor,
        textFieldBackgroundColor: Colors.grey.shade200,
        closeIconColor: theme.closeIconColor,
        textFieldConfig: TextFieldConfiguration(
          hintText: '메시지를 입력하세요.',
          margin: EdgeInsets.all(4.0),
          onMessageTyping: (status) {
            // debugPrint(status.toString());
          },
          compositionThresholdTime: const Duration(seconds: 1),
          textStyle: TextStyle(color: theme.textFieldTextColor),
        ),
        micIconColor: theme.replyMicIconColor,
        voiceRecordingConfiguration: VoiceRecordingConfiguration(
          backgroundColor: theme.waveformBackgroundColor,
          recorderIconColor: theme.recordIconColor,
          waveStyle: WaveStyle(
            showMiddleLine: false,
            waveColor: theme.waveColor ?? Colors.white,
            extendWaveform: true,
          ),
        ),
        cancelRecordConfiguration: CancelRecordConfiguration(
          icon: Icon(Icons.cancel),
        ),
      ),
      chatBubbleConfig: ChatBubbleConfiguration(
        outgoingChatBubbleConfig: ChatBubble(
          linkPreviewConfig: LinkPreviewConfiguration(
            backgroundColor: theme.linkPreviewOutgoingChatColor,
            bodyStyle: theme.outgoingChatLinkBodyStyle,
            titleStyle: theme.outgoingChatLinkTitleStyle,
          ),
          // 송신 메시지 내용 색
          textStyle: TextStyle(color:Colors.black),
          receiptsWidgetConfig: const ReceiptsWidgetConfig(
            showReceiptsIn: ShowReceiptsIn.lastMessage,
          ),
          color: PRIMARY_COLOR,
        ),
        inComingChatBubbleConfig: ChatBubble(
          linkPreviewConfig: LinkPreviewConfiguration(
            linkStyle: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
            backgroundColor: theme.linkPreviewIncomingChatColor,
            bodyStyle: theme.incomingChatLinkBodyStyle,
            titleStyle: theme.incomingChatLinkTitleStyle,
          ),
          textStyle: TextStyle(color: Colors.black),
          senderNameTextStyle: TextStyle(color: Colors.black),
          color: Colors.grey.shade200,
        ),
      ),
      replyPopupConfig: ReplyPopupConfiguration(
        backgroundColor: theme.replyPopupColor,
        buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
        topBorderColor: theme.replyPopupTopBorderColor,
      ),
      reactionPopupConfig: ReactionPopupConfiguration(
        shadow: BoxShadow(
          color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
          blurRadius: 20,
        ),
        backgroundColor: theme.reactionPopupColor,
      ),
      messageConfig: MessageConfiguration(
        messageReactionConfig: MessageReactionConfiguration(
          backgroundColor: theme.messageReactionBackGroundColor,
          borderColor: theme.messageReactionBackGroundColor,
          reactedUserCountTextStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
          reactionCountTextStyle: TextStyle(color: Colors.red),
          reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
            backgroundColor: theme.backgroundColor,
            reactedUserTextStyle: TextStyle(
              color: theme.inComingChatBubbleTextColor,
            ),
            reactionWidgetDecoration: BoxDecoration(
              color: theme.inComingChatBubbleColor,
              boxShadow: [
                BoxShadow(
                  color: isDarkTheme ? Colors.black12 : Colors.grey.shade200,
                  offset: const Offset(0, 20),
                  blurRadius: 40,
                )
              ],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        imageMessageConfig: ImageMessageConfiguration(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          shareIconConfig: ShareIconConfiguration(
            defaultIconBackgroundColor: theme.shareIconBackgroundColor,
            defaultIconColor: theme.shareIconColor,
          ),
        ),
      ),
      profileCircleConfig: const ProfileCircleConfiguration(
        profileImageUrl: Data.profileImage,
      ),
      repliedMessageConfig: RepliedMessageConfiguration(
        backgroundColor: theme.repliedMessageColor,
        verticalBarColor: theme.verticalBarColor,
        repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
          enableHighlightRepliedMsg: true,
          highlightColor: Colors.pinkAccent.shade100,
          highlightScale: 1.1,
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.25,
        ),
        replyTitleTextStyle: TextStyle(color: theme.repliedTitleTextColor),
      ),
      swipeToReplyConfig: SwipeToReplyConfiguration(
        replyIconColor: theme.swipeToReplyIconColor,
      ),
      replySuggestionsConfig: ReplySuggestionsConfig(
        itemConfig: SuggestionItemConfig(
          decoration: BoxDecoration(
            color: theme.textFieldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.outgoingChatBubbleColor ?? Colors.white,
            ),
          ),
          textStyle: TextStyle(
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        onTap: (item) => _onSendTap(item.text, const ReplyMessage(), MessageType.text),
      ),
    );
  }

  void _onSendTap(
      String message,
      ReplyMessage replyMessage,
      MessageType messageType,
      ) {
    _chatController.addMessage(
      Message(
        id: DateTime.now().toString(),
        createdAt: DateTime.now(),
        message: message,
        sentBy: _chatController.currentUser.id,
        replyMessage: replyMessage,
        messageType: messageType,
      ),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatController.initialMessageList.last.setStatus =
          MessageStatus.undelivered;
    });
    // 읽음처리
    // Future.delayed(const Duration(seconds: 1), () {
    //   _chatController.initialMessageList.last.setStatus = MessageStatus.read;
    // });
  }

  void _onThemeIconTap() {
    setState(() {
      if (isDarkTheme) {
        theme = LightTheme();
        isDarkTheme = false;
      } else {
        theme = DarkTheme();
        isDarkTheme = true;
      }
    });
  }
}
