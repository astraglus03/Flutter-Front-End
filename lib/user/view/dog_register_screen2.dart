import 'dart:io';
import 'package:dimple/common/component/custom_dropdown_form_field.dart';
import 'package:dimple/common/component/custom_text_formfield.dart';
import 'package:dimple/common/component/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dimple/common/layout/default_layout.dart';

class DogRegisterScreen2 extends StatefulWidget {
  const DogRegisterScreen2({super.key});

  @override
  State<DogRegisterScreen2> createState() => _DogRegisterScreen2State();
}

class _DogRegisterScreen2State extends State<DogRegisterScreen2> {
  XFile? selectedImage;
  String blood='';

  final List<String> bloodTypes = [
    'IDA1+','IDA1-','IDA2','IDA3','IDA4','IDA5','IDA6','IDA7','IDA8'
  ];

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
                  onPressed: () {
                    // TODO: 반려견 등록 api 연동하기 + RootTab으로 가기.
                    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => MenstruationDetailScreen2()));
                  },
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
        CustomTextFormField(labelText: '' ,width: 310,hintText: '신장',height: 65,),
        const SizedBox(height: 10.0,),
        CustomTextFormField(labelText: '',width: 310,hintText: '다리길이',height: 65,),
        const SizedBox(height: 10.0,),
        CustomDropdownFormField(
          title: '',
          selectedValue: blood,
          options: bloodTypes,
          onChanged: (String value) {
            setState(() {
              blood = value;
            });
          },
          hintText: '성별',
          width: 310,
          height: 55,
        ),
        const SizedBox(height: 20.0,),
        CustomTextFormField(labelText: '',isNumber: true ,width: 310,hintText: '등록번호',height: 65,),
        SizedBox(height: 125.0,),
      ],
    );
  }
}