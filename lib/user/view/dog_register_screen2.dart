import 'dart:io';
import 'package:dimple/common/component/custom_dropdown_form_field.dart';
import 'package:dimple/common/component/custom_text_formfield.dart';
import 'package:dimple/common/component/submit_button.dart';
import 'package:dimple/user/view/menstruation_detail_screen1.dart';
import 'package:dimple/user/view_model/dog_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dimple/common/layout/default_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DogRegisterScreen2 extends ConsumerStatefulWidget {
  static String get routeName => '/dog-register2';
  const DogRegisterScreen2({super.key});

  @override
  ConsumerState<DogRegisterScreen2> createState() => _DogRegisterScreen2State();
}

class _DogRegisterScreen2State extends ConsumerState<DogRegisterScreen2> {
  final _heightController = TextEditingController();
  final _legLengthController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  XFile? selectedImage;
  String blood = '';

  final List<String> bloodTypes = [
    'IDA1+','IDA1-','IDA2','IDA3','IDA4','IDA5','IDA6','IDA7','IDA8'
  ];

  @override
  void dispose() {
    _heightController.dispose();
    _legLengthController.dispose();
    _registrationNumberController.dispose();
    super.dispose();
  }

  void _saveAndNavigate() {
    // 상태 저장
    ref.read(dogRegisterProvider.notifier).saveAdditionalInfo(
      bloodType: blood,
      registrationNumber: _registrationNumberController.text,
      image: selectedImage?.path,
    );

    // 성별에 따라 다른 화면으로 이동
    final dog = ref.read(dogRegisterProvider);
    if (dog?.gender == '여') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MenstruationDetailScreen1()),
      );
    } else {
      // 강아지 등록 API 호출
      ref.read(dogRegisterProvider.notifier).registerDog().then((registered) {
        if (registered != null) {
          // TODO: 홈 화면으로 이동
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Stack(
        children: [
          ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(height: 50.0),
              _buildImagePicker(),
              const SizedBox(height: 20.0),
              _buildBasicInfoRow(),
              const SizedBox(height: 10.0),
            ],
          ),
          Positioned(
            bottom: 35.0,
            left: 0,
            right: 0,
            child: Center(
              child: Center(
                child: SubmitButton(
                  text: '완료',
                  onPressed: _saveAndNavigate,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    final imagePicker = ImagePicker();
    return GestureDetector(
      onTap: () async {
        final image = await imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            selectedImage = image;
          });
        }
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: selectedImage != null
                  ? FileImage(File(selectedImage!.path))
                  : const AssetImage('assets/img/runningDog.jpg') as ImageProvider,
            ),
          ),
          Positioned(
            left: 65,
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomTextFormField(
          controller: _heightController,
          labelText: '',
          width: 310,
          hintText: '신장',
          height: 65,
        ),
        const SizedBox(height: 10.0),
        CustomTextFormField(
          controller: _legLengthController,
          labelText: '',
          width: 310,
          hintText: '다리길이',
          height: 65,
        ),
        const SizedBox(height: 10.0),
        CustomDropdownFormField(
          title: '',
          selectedValue: blood,
          options: bloodTypes,
          onChanged: (String value) {
            setState(() {
              blood = value;
            });
          },
          hintText: '혈액형',
          width: 310,
          height: 55,
        ),
        const SizedBox(height: 20.0),
        CustomTextFormField(
          controller: _registrationNumberController,
          labelText: '',
          isNumber: true,
          width: 310,
          hintText: '등록번호',
          height: 65,
        ),
        SizedBox(height: 125.0),
      ],
    );
  }
}