import 'package:zaika/util/app_constants.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TipsWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;
  final bool isSuggested;
  final int index;
  const TipsWidget({super.key, required this.title, required this.isSelected, required this.onTap, required this.isSuggested, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeExtraSmall, bottom: 0),
      child: Column(children: [

        InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: (index == 0 || index == AppConstants.tips.length -1) ? 6 : 5, horizontal: Dimensions.paddingSizeSmall),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              border: Border.all(color: Theme.of(context).disabledColor),
            ),
            child: Column(children: [
              Text(
                title, textDirection: TextDirection.ltr,
                style: robotoRegular.copyWith(
                  color: isSelected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyMedium!.color!,
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        isSuggested ? Text(
          'most_tipped'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: 10),
        ) : const SizedBox(),
      ]),
    );
  }
}
