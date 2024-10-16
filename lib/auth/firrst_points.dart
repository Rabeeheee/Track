import 'package:flutter/material.dart';
import 'package:trackitapp/utils/colors.dart';



class FirrstPoints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Screen App',
      theme: ThemeData(
        
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ScreenWithText(
              title: 'Screen 1',
             description: '',
             
            ),
        '/screen2': (context) => ScreenWithText(
              title: 'Screen 2',
              description: 'This is the description for Screen 2.',
              imagePath: 'assets/images/screen2_image.png',
              
            ),
        '/screen3': (context) => ScreenWithText(
              title: 'Screen 3',
              description: 'This is the description for Screen 3.',
              imagePath: 'assets/images/screen3_image.png',
            ),
        '/screen4': (context) => ScreenWithText(
              title: 'Screen 4',
              description: 'This is the description for Screen 4.',
            ),
        '/screen5': (context) => ScreenWithText(
              title: 'Screen 5',
              description: 'This is the description for Screen 5.',
            ),
        '/screen6': (context) => ScreenWithText(
              title: 'Screen 6',
              description: 'This is the description for Screen 6.',
              showCustomContainer: true,
            ),
      },
    );
  }
}

class ScreenWithText extends StatelessWidget {
  final String title;
  final String description;
  final String? imagePath; 
   final String? imagePath2; 
  final String? imagePath3;  
  final bool showCustomContainer;

  const ScreenWithText({
    Key? key,
    required this.title,
    required this.description,
    this.imagePath,
    this.imagePath2,
    this.imagePath3,
    this.showCustomContainer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dynamic content for TextSpan
    String Text1 = 'At some stage, most people will experience ';
    String Text2 = 'a lack of discipline, low energy, and a loss of direction and motivation ';
    String Text3 = 'in their lives. ';
    String Text4 = 'Alex is one of them\n ';
    String Text5 = '12 months ago,  ';
    String Text6 = 'he was at the lowest of his life,\n';
    String Text7 = 'feeling like a piece of sh*t every day.';
    String Text8 = 'a lack of discipline, low energy, and a loss of direction and motivation ';
    String Text9 = 'a lack of discipline, low energy, and a loss of direction and motivation ';
    String Text10 = 'a lack of discipline, low energy, and a loss of direction and motivation ';
    String Text11 = 'a lack of discipline, low energy, and a loss of direction and motivation ';
    
    return Scaffold(
      backgroundColor: AppColors.backgrey,
      body: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50, top: 110),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Using Text.rich with dynamic TextSpan content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(right: 300),
                child: Icon(Icons.star_rate_rounded,color: AppColors.primaryColor,
                ),
                
                ),
                 SizedBox(height: 10),
                 Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: Text1,
                      style: TextStyle(
                        color: Color.fromARGB(231, 255, 255, 255),
                        fontSize: 19,
                        fontFamily: 'Fonts',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: Text2,
                       style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 19,
                        fontFamily: 'Fonts',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: Text3,
                       style: TextStyle(
                        color: Color.fromARGB(231, 255, 255, 255),
                        fontSize: 19,
                        fontFamily: 'Fonts',
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ])
                 )

              ],
            ),
      
            SizedBox(height: 20),
      
            // Conditionally show image if imagePath is provided
            if (imagePath != null)
              Image.asset(
                imagePath!,
                height: 200,
              ),
      
            // Conditionally show custom container for Screen 6
            if (showCustomContainer)
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        '6',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Custom container with text and avatar for Screen 6',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      
            SizedBox(height: 20),
           
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 70),
                child: Text(
                  'Tap to continue',
                  style: TextStyle(color: AppColors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
