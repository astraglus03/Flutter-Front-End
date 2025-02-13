import 'dart:io';
import 'package:dimple/common/component/custom_dropdown_form_field.dart';
import 'package:dimple/common/component/custom_text_formfield.dart';
import 'package:dimple/common/component/submit_button.dart';
import 'package:dimple/register/view/menstruation_detail_screen1.dart';
import 'package:dimple/register/view/recent_check_screen.dart';
import 'package:dimple/register/view_models/dog_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _legLengthController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  String bloodType = '';

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

  bool _validateInputs() {
    if (_heightController.text.isEmpty ||
        _legLengthController.text.isEmpty ||
        _registrationNumberController.text.isEmpty ||
        bloodType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return false;
    }
    return true;
  }

  void _saveAndNavigate() {
    if (!_validateInputs()) return;

    ref.read(dogRegisterProvider.notifier).saveAdditionalInfo(
      height: int.parse(_heightController.text),
      legLength: int.parse(_legLengthController.text),
      bloodType: bloodType,
      registrationNumber: _registrationNumberController.text,
    );

    final dog = ref.read(dogRegisterProvider);
    if (dog?.gender == '여') {
      context.pushNamed(MenstruationDetailScreen1.routeName);
    } else {
      context.pushNamed(RecentCheckScreen.routeName);
    }
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
                _buildBasicInfoRow(),
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
          isNumber: true,
        ),
        const SizedBox(height: 10.0),
        CustomTextFormField(
          controller: _legLengthController,
          labelText: '',
          width: 310,
          hintText: '다리길이',
          height: 65,
          isNumber: true,
        ),
        const SizedBox(height: 10.0),
        CustomDropdownFormField(
          title: '',
          selectedValue: bloodType,
          options: bloodTypes,
          onChanged: (String value) {
            setState(() {
              bloodType = value;
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
      ],
    );
  }
}