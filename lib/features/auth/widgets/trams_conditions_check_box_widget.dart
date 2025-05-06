import 'package:flutter/gestures.dart';
import 'package:zaika/features/auth/controllers/auth_controller.dart';
import 'package:zaika/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TramsConditionsCheckBoxWidget extends StatelessWidget {
  final AuthController? authController;
  final bool fromDmRegistration;
  final DeliverymanRegistrationController? deliverymanRegistrationController;
  final bool fromSignUp;
  final bool fromDialog;
  const TramsConditionsCheckBoxWidget({super.key, this.authController,  this.fromSignUp = false, this.fromDialog = false,
    this.fromDmRegistration = false, this.deliverymanRegistrationController});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: /*fromSignUp || fromDmRegistration ?*/ MainAxisAlignment.start /*: MainAxisAlignment.center*/, children: [

      fromSignUp || fromDmRegistration ? Checkbox(
        activeColor: Theme.of(context).primaryColor,
        value: fromDmRegistration ? deliverymanRegistrationController?.acceptTerms : authController?.acceptTerms,
        onChanged: (bool? isChecked) => fromDmRegistration ? deliverymanRegistrationController?.toggleTerms() : authController?.toggleTerms(),
      ) : const SizedBox(),

      fromSignUp || fromDmRegistration ? const SizedBox() : Text( '* ', style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

      Flexible(
        child: RichText(
          text: TextSpan(children: [
            TextSpan(text: 'i_agree_with_all_the'.tr, style: robotoRegular.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraSmall : null, color: Theme.of(context).hintColor)),
            const TextSpan(text: ' '),
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
              text: 'terms_conditions'.tr,
              style: robotoMedium.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraSmall : null, color: Theme.of(context).primaryColor),
            ),
          ]),
        ),
      ),

    ]);
  }
}
