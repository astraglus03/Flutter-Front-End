import 'package:dimple/chatbot/view/chatbot_screen.dart';
import 'package:dimple/common/const/colors.dart';
import 'package:dimple/dashboard/view/dash_board_screen.dart';
import 'package:dimple/map/view/map_page.dart';
import 'package:dimple/social/view/social_screen.dart';
import 'package:dimple/user/view/dog_register_screen1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../calendar/view/calendar_screen.dart';


class RootTab extends StatefulWidget {
  static String get routeName => 'RootTab';
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      floatingActionButton: _currentIndex ==0 ? _getMultiplePets(context) : null,
      tabs: [
        PersistentTabConfig(
          screen: DashBoardScreen(),
          item: ItemConfig(
            activeForegroundColor: Colors.black,
            icon: Icon(Icons.home),
            title: "홈",
          ),
        ),
        PersistentTabConfig(
          screen: CalendarScreen(),

          item: ItemConfig(
            activeForegroundColor: Colors.black,
            icon: Icon(Icons.calendar_month),
            title: "솔루션",
          ),
        ),
        // pushScreen(context, screen: ChatbotScreen(),withNavBar: false),
        PersistentTabConfig.noScreen(
          item: ItemConfig(
            activeForegroundColor: PRIMARY_COLOR,
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/img/banreou.png',fit: BoxFit.cover,),
            ),
            title: "챗봇",
          ),
          onPressed: (BuildContext context){
            pushScreen(context, screen: ChatbotScreen(),withNavBar: false);
          },
        ),
        PersistentTabConfig.noScreen(
          item: ItemConfig(
            activeForegroundColor: Colors.black,
            icon: Icon(Icons.directions_walk),
            title: "산책",
          ),
          onPressed: (BuildContext context){
            pushScreen(context, screen: MapScreen(),withNavBar: false);
          },
        ),
        PersistentTabConfig(
          screen: SocialScreen(),
          item: ItemConfig(
            activeForegroundColor: Colors.black,
            icon: Icon(Icons.social_distance),
            title: "소셜",
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style14BottomNavBar(
        navBarConfig: navBarConfig,
      ),
      onTabChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget _getMultiplePets(context) {
    return SpeedDial(
      spaceBetweenChildren: 8,
      visible: true,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 20),
      backgroundColor: PRIMARY_COLOR,
      useRotationAnimation: true,
      curve: Curves.elasticInOut,
      children: [
        // 나중에 스피드 다이얼은 리스트 뷰로 찍을 예정
        SpeedDialChild(
          backgroundColor: PRIMARY_COLOR,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              'assets/img/banreou.png',
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {},
        ),
        SpeedDialChild(
          backgroundColor: PRIMARY_COLOR,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              'assets/img/runningDog.jpg',
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {},
        ),
        SpeedDialChild(
          backgroundColor: PRIMARY_COLOR,
          child: Icon(Icons.add),
          onTap: () {
            pushScreenWithoutNavBar(context, DogRegisterScreen1());
          },
        ),
      ],
    );
  }
}
