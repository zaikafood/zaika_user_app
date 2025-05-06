import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaika/common/widgets/custom_button_widget.dart';
import 'package:zaika/common/widgets/custom_snackbar_widget.dart';
import 'package:zaika/features/splash/controllers/splash_controller.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/styles.dart';
class DemoResetDialogWidget extends StatefulWidget {
  const DemoResetDialogWidget({super.key});

  @override
  State<DemoResetDialogWidget> createState() => _DemoResetDialogWidgetState();
}

class _DemoResetDialogWidgetState extends State<DemoResetDialogWidget> {
  bool _isLoading = false;
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();

    _startTimer();

  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  void _startTimer() {
    _seconds = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if(_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
        _seconds = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
        ),
        width: 500,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error_outline, color: Theme.of(context).primaryColor, size: 55),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text('session_time_out'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text(
            'though_it_is_demo_text'.tr,
            textAlign: TextAlign.center,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

          CustomButtonWidget(isLoading: _isLoading, buttonText: 'okay'.tr, onPressed: () async {
            if (_seconds == 0) {
              setState(() {
                _isLoading = true;
              });
              await Get.find<SplashController>().getConfigData(fromDemoReset: true);

              setState(() {
                _isLoading = false;
              });

            } else {
              showCustomSnackBar('${'our_demo_system_is_resetting_please_wait'.tr} $_seconds ${'second'.tr}');
            }
          }),
        ]),
      ),
    );
  }
}
