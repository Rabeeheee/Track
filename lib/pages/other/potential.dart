import 'package:flutter/material.dart';
import 'package:trackitapp/pages/widgets/bottomnav.dart';
import 'package:trackitapp/utils/colors.dart';

class PotentialScreen extends StatelessWidget {
  final Map<String, double> adjustedRatings;

  const PotentialScreen({super.key, required this.adjustedRatings});

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    Size screenSize = MediaQuery.of(context).size;
    // ignore: deprecated_member_use
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    int crossAxisCount = screenSize.width > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: 0.05 * screenSize.height,
          left: 0.05 * screenSize.width,
          right: 0.05 * screenSize.width,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Potential Rating',
              style: TextStyle(
                fontFamily: 'Fonts',
                color: AppColors.secondaryColor,
                fontSize:
                    26 * textScaleFactor * (screenSize.width > 600 ? 1.2 : 1.0),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Based on your answers, this is your potential TrackIt rating, reflecting your possible lifestyle and habits.',
              style: TextStyle(
                color: Colors.white,
                fontSize:
                    14 * textScaleFactor * (screenSize.width > 600 ? 1.2 : 1.0),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 165 / 115,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  String title;
                  double rating;

                  switch (index) {
                    case 0:
                      title = 'Overall';
                      rating = adjustedRatings['overallRating'] ?? 0;
                      break;
                    case 1:
                      title = 'Wisdom';
                      rating = adjustedRatings['wisdomRating'] ?? 0;
                      break;
                    case 2:
                      title = 'Strength';
                      rating = adjustedRatings['strengthRating'] ?? 0;
                      break;
                    case 3:
                      title = 'Focus';
                      rating = adjustedRatings['focusRating'] ?? 0;
                      break;
                    case 4:
                      title = 'Confidence';
                      rating = adjustedRatings['confidenceRating'] ?? 0;
                      break;
                    case 5:
                      title = 'Discipline';
                      rating = adjustedRatings['disciplineRating'] ?? 0;
                      break;
                    default:
                      title = '';
                      rating = 0;
                  }

                  Color backgroundColor;
                  Color textColor;
                  Color progressColor;
                  Color progressBack;
                  Color addColor;

                  if (index == 0) {
                    backgroundColor = Colors.green;
                    textColor = Colors.white;
                    progressColor = Colors.white;
                    progressBack = const Color.fromARGB(185, 76, 175, 79);
                    addColor = Colors.yellow;
                  } else {
                    backgroundColor = Colors.white;
                    textColor = Colors.black;
                    progressColor = Colors.green;
                    progressBack = const Color.fromARGB(137, 255, 255, 255);
                    addColor = Colors.green;
                  }

                  return ConstrainedBox(
                    constraints: const BoxConstraints(),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 900),
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: backgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Icon(
                                    Icons.gpp_good_rounded,
                                    color: textColor,
                                    size: 25 *
                                        textScaleFactor, // Responsive icon size
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 18 *
                                          textScaleFactor *
                                          (screenSize.width > 600 ? 1.2 : 1.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    // ignore: unnecessary_string_interpolations
                                    '${(rating + 40).toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 27 *
                                          textScaleFactor *
                                          (screenSize.width > 600 ? 1.2 : 1.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '(+40)',
                                  style: TextStyle(
                                    color: addColor,
                                    fontSize: 18 *
                                        textScaleFactor *
                                        (screenSize.width > 600 ? 1.2 : 1.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: (rating + 40) / 100,
                                  backgroundColor: progressBack,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      progressColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 100, top: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.05 * screenSize.width,
                      vertical: 0.02 * screenSize.height,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNav(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View my program',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 16 *
                              textScaleFactor *
                              (screenSize.width > 600 ? 1.2 : 1.0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: AppColors.secondaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
