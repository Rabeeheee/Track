
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:trackitapp/utils/colors.dart';

class CommonProgressIndicator extends StatelessWidget {
  final double progressValue;

  const CommonProgressIndicator({
    super.key,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: progressValue,
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
        ),
      ),
    );
  }
}
