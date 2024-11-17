import 'package:flutter/material.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/pages/widgets/overall_progress.dart';
import 'package:trackitapp/pages/widgets/weekly_progres.dart';

class ProgressScreen extends StatefulWidget {
  final double overallprogress;
  const ProgressScreen({super.key, required this.overallprogress});

  @override
  // ignore: library_private_types_in_public_api
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final OverallProgressState _overallprogress = OverallProgressState();

  @override
  void initState() {
    super.initState();
    _overallprogress.calculateOverallProgress();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Progress",
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 90));
          setState(() {
            _overallprogress.calculateOverallProgress();
          });
        },
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    OverallProgress(),
                    SizedBox(height: 13),
                    WeeklyProgressGraph(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
