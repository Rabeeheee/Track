import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:provider/provider.dart';
import 'package:trackit/utils/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      title: Text(
        'Habit',
        style: TextStyle(
          color: themeProvider.themeData.canvasColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Iconify(
            GameIcons.progression,
            color: themeProvider.themeData.canvasColor,
          ),
        ),
        Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: themeProvider.themeData.canvasColor,
            ),
          );
        }),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
