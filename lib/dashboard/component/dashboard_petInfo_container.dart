// import 'package:dimple/common/const/colors.dart';
// import 'package:dimple/dashboard/view/modify_petInfo_screen.dart';
// import 'package:flutter/material.dart';
//
// class DashboardPetInfoCard extends StatelessWidget {
//   // 반려견 이미지
//   final Image img;
//
//   // 반려견 성별 그림
//   final Image? gender;
//
//   // 반려견 이름
//   final String name;
//
//   // 반려견 나이
//   final int? age;
//
//   // 반려 견종
//   final String breed;
//
//   // 반려견 번호
//   final int? petNum;
//
//   // 반려견 사상충 마지막 접종일
//   final String? lastHeartInjection;
//
//   // 반려견 마지만 검진 일자
//   final String? lastCheck;
//
//   // 앞 뒷면 여부 판단
//   final bool isFront;
//
//   const DashboardPetInfoCard({
//     super.key,
//     required this.img,
//     this.gender,
//     required this.name,
//     this.age,
//     required this.breed,
//     this.petNum,
//     this.lastHeartInjection,
//     this.lastCheck, required this.isFront,
//   });
//
//   // 개인정보 모델을 여기에 추가할 예정
//   // factory CardContainer.fromModel() {
//   //   return CardContainer(
//   //     img: img,
//   //     name: name,
//   //     type: type,
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery
//           .of(context)
//           .size
//           .width,
//       height: 200,
//       decoration: BoxDecoration(
//         color: isFront ? Colors.white : PRIMARY_COLOR,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 5,
//             blurRadius: 7,
//             offset: Offset(-2, 2),
//           ),
//         ],
//         borderRadius: BorderRadius.circular(16.0),
//         border: Border.all(color: Colors.grey, width: 1), // 테두리 추가
//       ),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: name,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black, // 기본적으로 색상을 지정
//                         ),
//                       ),
//                       TextSpan(
//                         text: ' $breed',
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: Colors.grey, // 텍스트 색상 설정
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(onPressed: (){
//                   Navigator.of(context).push(MaterialPageRoute(builder: (_) => ModifyPetInfoScreen()));
//                 }, icon: Icon(Icons.edit))
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Image.asset(
//                   'assets/img/banreou.png',
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                 ),
//                 const SizedBox(width: 3,),
//                 isFront ? FrontContainer(petNum: petNum!, age: age!) :BackContainer(lastHeartInjection: lastHeartInjection.toString(), lastCheck: lastCheck.toString(),)
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FrontContainer extends StatelessWidget {
//   final int age;
//   final int petNum;
//
//   const FrontContainer({super.key, required this.petNum, required this.age});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // 나이 텍스트
//         Row(
//           children: [
//             Text(
//               '$age살',
//               style: TextStyle(
//                   fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(width: 8),
//             Icon(
//               Icons.female,
//               color: Colors.pink,
//               size: 24,
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//
//         Text(
//           petNum.toString(),
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       ],
//     );
//
//   }
// }
//
//
// class BackContainer extends StatelessWidget {
//   final String lastHeartInjection;
//   final String lastCheck;
//
//   const BackContainer(
//       {super.key, required this.lastHeartInjection, required this.lastCheck});
//
//   @override
//   Widget build(BuildContext context) {
//     TextStyle commonStyle = const TextStyle(
//       fontSize: 12,
//     );
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text('최근 검진 일자 ', style: commonStyle.copyWith(fontWeight: FontWeight.w700)),
//             Text(lastCheck, style: commonStyle),
//           ],
//         ),
//         const SizedBox(height: 8.0,),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text('최근 심장 사상충 접종일 ', style: commonStyle.copyWith(fontWeight: FontWeight.w700)),
//             Text('$lastHeartInjection', style: commonStyle),
//           ],
//         ),
//       ],
//     );
//   }
// }
