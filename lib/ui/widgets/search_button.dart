import 'package:flutter/material.dart';
import 'package:simple_weather_app/core/const.dart';

class SearchButton extends StatelessWidget {
  final VoidCallback onTap;

  const SearchButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColor,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black45,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.search, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}