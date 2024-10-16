import 'package:flutter/material.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/utils/colors.dart';
import 'package:trackitapp/auth/getstart.dart';
import 'package:trackitapp/utils/login_manager.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final HiveService _hiveService = HiveService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(15, 255, 255, 255),
            const Color.fromARGB(39, 0, 0, 0),
            const Color.fromARGB(14, 255, 255, 255),
            const Color.fromARGB(39, 0, 0, 0),
            const Color.fromARGB(14, 255, 255, 255),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 60,
            left: 35,
            child: Text(
              'Login',
              style: TextStyle(
                fontFamily: 'Fonts',
                fontSize: 24,
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 300,
              height: 200,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Fonts',
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          height: 60,
                          child: TextFormField(
                            controller: _usernameController, 
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromARGB(103, 158, 158, 158),
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 8.0),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                               await _hiveService.saveUsername(_usernameController.text);
                               await LoginManager.setLoginStatus(true);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Getstart(
                                      username: _usernameController.text, 
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'Fonts',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: AppColors.secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
