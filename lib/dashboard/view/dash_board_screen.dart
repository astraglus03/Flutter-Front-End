import 'package:dimple/calendar/view/calendar_screen.dart';
import 'package:dimple/common/const/colors.dart';
import 'package:dimple/common/layout/default_layout.dart';
import 'package:dimple/common/utils/data_utils.dart';
import 'package:dimple/common/view_model/go_router.dart';
import 'package:dimple/dashboard/component/dashboard_container.dart';
import 'package:dimple/dashboard/component/dashboard_petInfo_container.dart';
import 'package:dimple/dashboard/view/food_range_screen.dart';
import 'package:dimple/dashboard/view/moved_distance_detail_screen.dart';
import 'package:dimple/dashboard/view/pupu_detail_screen.dart';
import 'package:dimple/user/model/user_model.dart';
import 'package:dimple/register/view/dog_register_screen1.dart';
import 'package:dimple/dashboard/view/temrs_screen.dart';
import 'package:dimple/user/view_model/user_me_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  static String get routeName => 'dashboard';
  const DashBoardScreen({super.key});

  @override
  ConsumerState<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  final FlipCardController _controller = FlipCardController();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.flipcard();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);

    const NeverScrollableScrollPhysics();
    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 5.0),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    if (userState is UserModel) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20.0),
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: userState.profileImage != null
                                  ? NetworkImage(userState.profileImage)
                                  : AssetImage('assets/img/runningDog.jpg'),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              userState.name,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              userState.email,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Expanded(
                              child: ListView(
                                children: [
                                  ListTile(
                                    title: Text('이용약관'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      context.goNamed(TermsScreen.routeName);
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  ListTile(
                                    title: Text('회원탈퇴'),
                                    onTap: () {
                                      ref.read(userMeProvider.notifier).logout();
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  ListTile(
                                    title: Text('로그아웃'),
                                    onTap: () {
                                      ref.read(userMeProvider.notifier).logout();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                );
              },
              icon: Image.asset('assets/img/banreou.png'),
            ),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomScrollView(
          controller: controller,
          slivers: [
            petInfoSliver(_controller),
            makeSpace(),
            weekReport(context),
            makeSpace(),
            movedDistance(context),
            makeSpace(),
            rowPupuAndCalories(context),
            makeSpace(),
            RowAddMemoAndAllResponse(context),
            makeSpace(),
          ],
        ),
      ),
    );
  }
}

SliverPadding petInfoSliver(FlipCardController controller) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // FlipCard(
          //   rotateSide: RotateSide.bottom,
          //   onTapFlipping: true,
          //   axis: FlipAxis.vertical,
          //   controller: controller,
          //   frontWidget: DashboardPetInfoCard(
          //     img: Image.asset(
          //       'assets/img/banreou.png',
          //       fit: BoxFit.cover,
          //     ),
          //     name: '마콩',
          //     age: 12,
          //     breed: '포메라니안',
          //     petNum: 1234567891011,
          //     isFront: true,
          //   ),
          //   backWidget: DashboardPetInfoCard(
          //     img: Image.asset(
          //       'assets/img/banreou.png',
          //       fit: BoxFit.cover,
          //     ),
          //     name: '마콩',
          //     breed: '포메라니안',
          //     lastHeartInjection: '2023-03-12',
          //     lastCheck: '2022-03-21',
          //     isFront: false,
          //   ),
          // ),
        ],
      ),
    ),
  );
}

SliverPadding weekReport(BuildContext context) {
  final TextStyle tstyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
  );
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    sliver: SliverToBoxAdapter(
      child: DashboardContainer(
        yIcon: false,
        title: '이번주 주간 리포트',
        // // 이렇게하면 바텀네비게이션바 없애면서 페이지 이동 --> 나중에 라우터 적용하면 달라짐
        // onTap: () {
        //  pushScreen(context, screen: MovedDistanceScreen(),withNavBar: false);
        // },
        // 이렇게하면 바텀네비게이션바 유지하면서 페이지이동 --> 나중에 라우터 적용하면 달라짐
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1.	반려견의 체중, 운동량, 식사량 등을 분석한 개인화된 건강 관리 권고', style: tstyle),
              SizedBox(
                height: 10,
              ),
              Text('2.	반려견의 체중, 운동량, 식사량 등을 분석한 개인화된 건강 관리 권고', style: tstyle),
            ],
          ),
        ),
      ),
    ),
  );
}

SliverPadding movedDistance(BuildContext context) {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    sliver: SliverToBoxAdapter(
      child: DashboardContainer(
        title: '이동 거리',
        // // 이렇게하면 바텀네비게이션바 없애면서 페이지 이동 --> 나중에 라우터 적용하면 달라짐
        // onTap: () {
        //  pushScreen(context, screen: MovedDistanceScreen(),withNavBar: false);
        // },
        // 이렇게하면 바텀네비게이션바 유지하면서 페이지이동 --> 나중에 라우터 적용하면 달라짐
        onTap: () {
          pushScreenWithoutNavBar(context, MovedDistanceDetailScreen());
        },

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/runningDog.jpg',
              fit: BoxFit.cover,
              width: 60,
              height: 60,
            ),
            const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '80KM',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '123kcal',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

SliverPadding makeSpace() {
  return const SliverPadding(
    padding: EdgeInsets.only(top: 16.0),
  );
}

SliverPadding rowPupuAndCalories(BuildContext context) {
  int _currentNumber = 0;

  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    sliver: SliverToBoxAdapter(
      child: Row(
        children: [
          Expanded(
            child: DashboardContainer(
              title: '배변 활동',
              onTap: () {
                pushScreenWithNavBar(context, PupuDetailScreen());
              },
              child: GestureDetector(
                onTap: () {
                  // 숫자 Picker 호출
                  DataUtils.showCenterNumberPicker(
                    context,
                    _currentNumber,
                    (int value) {
                      _currentNumber = value;
                    },
                  );
                },
                child: ClipOval(
                  child: Image.asset(
                    'assets/img/pupuActivity.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: DashboardContainer(
              title: '금주 설정 칼로리',
              onTap: () {},
              child: Center(
                child: Text("0 / 210 Kcal", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.0),),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

SliverPadding RowAddMemoAndAllResponse(BuildContext context) {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    sliver: SliverToBoxAdapter(
      child: Row(
        children: [
          Expanded(
            child: DashboardContainer(
              title: '급여량',
              onTap: () {
                pushScreenWithNavBar(context, FoodRangeScreen());
              },
              child: GestureDetector(
                onTap: () {
                  DataUtils.showFoodPopUp(context);
                },
                child: ClipOval(
                  child: Image.asset(
                    'assets/img/dog-food.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain, // 이미지 전체가 보이도록 함
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: DashboardContainer(
              title: '생리 추적',
              onTap: () {
                pushScreenWithNavBar(context, CalendarScreen());
              },
              child: Center(
                child: Text(
                  "D-10",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}