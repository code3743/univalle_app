import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.scaffoldKey,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => scaffoldKey.currentState!.openDrawer(),
            icon: const Icon(
              Icons.menu,
              color: AppColors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Hero(
              tag: 'uv_logo',
              child: SvgPicture.asset(
                'assets/svg/logo.svg',
                height: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
