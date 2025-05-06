import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/styles.dart';
import 'package:flutter/material.dart';

class ProfileCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final String data;
  const ProfileCardWidget({super.key, required this.data, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), blurRadius: 4, spreadRadius: 0)],
        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(image, height: 30, width: 30),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Text(data, style: robotoBold.copyWith(
          fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color
        )),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Text(title, style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
        )),
      ]),
    );
  }
}