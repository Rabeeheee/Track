import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomAppBar({required this.title, this.leading, this.actions});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: themeProvider.themeData.canvasColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          fontFamily: 'Fonts'
        ),
      ),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
