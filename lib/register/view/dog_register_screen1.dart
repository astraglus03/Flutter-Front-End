import 'dart:io';
import 'package:dimple/common/component/custom_dropdown_form_field.dart';
import 'package:dimple/common/component/custom_text_formfield.dart';
import 'package:dimple/common/component/submit_button.dart';
import 'package:dimple/common/view_model/go_router.dart';
import 'package:dimple/register/view/dog_register_screen2.dart';
import 'package:dimple/register/view_models/dog_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dimple/common/layout/default_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DogRegisterScreen1 extends ConsumerStatefulWidget {
  static String get routeName => '/dog-register1';
  const DogRegisterScreen1({super.key});

  @override
  ConsumerState<DogRegisterScreen1> createState() => _DogRegisterScreen1State();
}

class _DogRegisterScreen1State extends ConsumerState<DogRegisterScreen1> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  XFile? selectedImage;
  String breed = '';
  String isNeutered = '';
  String gender = '';

  final List<String> genderTypes = ['암컷', '수컷'];
  final List<String> neuteredTypes = ['O', 'X'];
  final List<String> dogBreeds = ['포메라니안', '푸들', '허스키', '말티즈', '시츄', '불독', '치와와', '골든리트리버'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    print(_nameController.text);
    print(_ageController.text);
    print(_weightController.text);
    print(gender);
    print(isNeutered);
    print(breed);
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        gender.isEmpty ||
        isNeutered.isEmpty ||
        breed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return false;
    }
    return true;
  }

  void _saveAndNavigate() {
    if (!_validateInputs()) return;

    ref.read(dogRegisterProvider.notifier).saveBasicInfo(
      image: selectedImage?.path,
      name: _nameController.text,
      age: int.parse(_ageController.text),
      weight: double.parse(_weightController.text),
      gender: gender == '암컷' ? '여' : '남',
      isNeutered: isNeutered == 'O',
      breed: breed,
    );

    context.pushNamed(DogRegisterScreen2.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 50.0),
                _buildImagePicker(),
                const SizedBox(height: 20.0),
                _buildBasicInfoRow(),
                const SizedBox(height: 10.0),
                _buildAdditionalInfoRow(),
                const SizedBox(height: 80.0),
              ],
            ),
          ),
          Positioned(
            bottom: 35.0,
            left: 0,
            right: 0,
            child: Center(
              child: SubmitButton(
                text: '다음',
                onPressed: _saveAndNavigate,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  '안녕하세요. 보조개입니다.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 50),
                SubmitButton(
                  text: '반려견 정보 입력하기',
                  onPressed: () => Navigator.of(context).pop(),
                  width: MediaQuery.of(context).size.width * 0.5,
                  fontSize: 14.0,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () async {
        final image = await ImagePicker().pickImage(source: ImageSource.gallery);
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
                  : const AssetImage('assets/img/runningDog.jpg'),
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
          controller: _nameController,
          labelText: '',
          width: 310,
          hintText: '이름',
          height: 65,
        ),
        const SizedBox(height: 10.0),
        CustomTextFormField(
          controller: _ageController,
          labelText: '',
          isNumber: true,
          width: 310,
          hintText: '나이',
          height: 65,
        ),
        const SizedBox(height: 10.0),
        CustomTextFormField(
          controller: _weightController,
          labelText: '',
          width: 310,
          hintText: '몸무게',
          height: 65,
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomDropdownFormField(
              title: '',
              selectedValue: gender,
              options: genderTypes,
              onChanged: (String value) {
                setState(() {
                  gender = value;
                });
              },
              hintText: '성별',
              height: 55,
            ),
            CustomDropdownFormField(
              title: '',
              selectedValue: isNeutered,
              options: neuteredTypes,
              onChanged: (value) {
                setState(() {
                  isNeutered = value;
                });
              },
              hintText: '중성화',
              height: 55,
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        CustomDropdownFormField(
          title: '',
          selectedValue: breed,
          options: dogBreeds,
          onChanged: (value) {
            setState(() {
              breed = value;
            });
          },
          hintText: '견종',
          width: 310,
          height: 55,
        ),
      ],
    );
  }
}
