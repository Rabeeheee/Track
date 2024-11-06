  import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackitapp/utils/colors.dart';

import 'package:trackitapp/pages/other/servey.dart';


class Getstart extends StatelessWidget {
  final String username;
  const Getstart({super.key,required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(15, 255, 255, 255),
              Color.fromARGB(39, 0, 0, 0),
              Color.fromARGB(14, 255, 255, 255),
              Color.fromARGB(39, 0, 0, 0),
              Color.fromARGB(14, 255, 255, 255),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.feather,
                    size: 50,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'TrackIt',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.secondaryColor,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.secondaryColor,
                  ],
                ).createShader(
                  Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height),
                ),
                child: const Text(
                  '#Life reset app',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, 
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Text("Hello , $username \n To let you know your rating, let's \n go through some \n questions.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w400
              ),),
              const SizedBox(height: 15,),
             ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SurveyScreen(habitProgress: {},)));
                              },
                              // ignore: sort_child_properties_last
                              child: const Text(
                                'Get Started',
                                style: TextStyle(
                                  fontFamily: 'Fonts',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondaryColor,
                                foregroundColor: AppColors.backgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
