import 'package:dimple/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Image.asset('assets/img/banreou.png', width: MediaQuery.of(context).size.width /2 ,
              ),
              const SizedBox(height: 16.0,),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
    ));
  }
}
