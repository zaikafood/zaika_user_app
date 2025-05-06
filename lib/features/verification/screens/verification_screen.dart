import 'dart:async';
import 'package:zaika/common/models/response_model.dart';
import 'package:zaika/common/widgets/custom_asset_image_widget.dart';
import 'package:zaika/features/auth/domain/centralize_login_enum.dart';
import 'package:zaika/features/auth/screens/new_user_setup_screen.dart';
import 'package:zaika/features/auth/widgets/sign_in/existing_user_bottom_sheet.dart';
import 'package:zaika/features/profile/controllers/profile_controller.dart';
import 'package:zaika/features/profile/domain/models/update_user_model.dart';
import 'package:zaika/features/splash/controllers/splash_controller.dart';
import 'package:zaika/features/auth/controllers/auth_controller.dart';
import 'package:zaika/features/verification/controllers/verification_controller.dart';
import 'package:zaika/features/verification/domein/model/verification_data_model.dart';
import 'package:zaika/features/verification/screens/new_pass_screen.dart';
import 'package:zaika/helper/auth_helper.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/images.dart';
import 'package:zaika/util/styles.dart';
import 'package:zaika/common/widgets/custom_app_bar_widget.dart';
import 'package:zaika/common/widgets/custom_button_widget.dart';
import 'package:zaika/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum VerificationTypeEnum{phone, email}

class VerificationScreen extends StatefulWidget {
  final String? number;
  final String? email;
  final bool fromSignUp;
  final String? token;
  final String? password;
  final String loginType;
  final String? firebaseSession;
  final bool fromForgetPassword;
  final UpdateUserModel? userModel;
  const VerificationScreen({super.key, required this.number, required this.password, required this.fromSignUp,
    required this.token, this.email, required this.loginType, this.firebaseSession, required this.fromForgetPassword, this.userModel});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  String? _number;
  String? _email;
  Timer? _timer;
  int _seconds = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<VerificationController>().updateVerificationCode('', canUpdate: false);
    if(widget.number != null) {
      _number = widget.number!.startsWith('+') ? widget.number : '+${widget.number!.substring(1, widget.number!.length)}';
    }
    _email = widget.email;
    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if(_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    double borderWidth = 0.7;
    return Scaffold(
      appBar: isDesktop ? null : CustomAppBarWidget(title: _email != null ? 'email_verification'.tr : 'phone_verification'.tr),
      backgroundColor: isDesktop ? Colors.transparent : null,
      body: SafeArea(child: Center(child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        child: Center(child: Container(
          width: context.width > 700 ? 500 : context.width,
          padding: context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
          decoration: context.width > 700 ? BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ) : null,
          child: GetBuilder<VerificationController>(builder: (verificationController) {
            return Column(children: [

              isDesktop ? Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: ()=> Get.back(), icon: const Icon(Icons.clear)),
              ) : const SizedBox(),

              isDesktop ? Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                child: Text(
                  'otp_verification'.tr, style: robotoRegular,
                ),
              ) : const SizedBox(),

              CustomAssetImageWidget(Images.otpVerification, height: 100),
              const SizedBox(height: Dimensions.paddingSizeOverLarge),

              Get.find<SplashController>().configModel!.demo! ? Text(
                'for_demo_purpose'.tr, style: robotoMedium,
              ) : SizedBox(
                width: 250,
                child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                  RichText(text: TextSpan(children: [
                    TextSpan(text: 'we_have_a_verification_code'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                    TextSpan(text: ' ${_email ?? _number}', style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                  ]), textAlign: TextAlign.center,),
                ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width > 850 ? 50 : Dimensions.paddingSizeDefault, vertical: 35),
                child: PinCodeTextField(
                  length: 6,
                  appContext: context,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.slide,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    fieldHeight: 60,
                    fieldWidth: 50,
                    borderWidth: borderWidth,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    selectedColor: Theme.of(context).primaryColor,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Theme.of(context).cardColor,
                    inactiveColor: Theme.of(context).disabledColor.withValues(alpha: 0.6),
                    activeColor: Theme.of(context).disabledColor,
                    activeFillColor: Theme.of(context).cardColor,
                    inactiveBorderWidth: borderWidth,
                    selectedBorderWidth: borderWidth,
                    disabledBorderWidth: borderWidth,
                    errorBorderWidth: borderWidth,
                    activeBorderWidth: borderWidth
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onChanged: verificationController.updateVerificationCode,
                  beforeTextPaste: (text) => true,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              GetBuilder<ProfileController>(
                  builder: (profileController) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : Dimensions.paddingSizeSmall),
                      child: CustomButtonWidget(
                        radius: Dimensions.radiusDefault,
                        buttonText: 'verify'.tr,
                        isLoading: verificationController.isLoading || profileController.isLoading,
                        onPressed: verificationController.verificationCode.length < 6 ? null : () {
                          if(widget.firebaseSession != null && widget.userModel == null) {
                            verificationController.verifyFirebaseOtp(
                              phoneNumber: _number!, session: widget.firebaseSession!, loginType: widget.loginType,
                              otp: verificationController.verificationCode, token: widget.token, isForgetPassPage: widget.fromForgetPassword,
                              isSignUpPage: widget.loginType == CentralizeLoginType.otp.name ? false : true,
                            ).then((value) {
                              if(value.isSuccess) {
                                _handleVerifyResponse(value, _number, _email);
                              }else {
                                showCustomSnackBar(value.message);
                              }
                            });
                          } else if(widget.userModel != null) {
                            widget.userModel!.otp = verificationController.verificationCode;
                            Get.find<ProfileController>().updateUserInfo(widget.userModel!, Get.find<AuthController>().getUserToken(), fromButton: true).then((response) async {
                              if(response.isSuccess) {
                                profileController.getUserInfo();
                                Get.back();
                                Get.back();
                                showCustomSnackBar(response.message, isError: false);
                              } else if(!response.isSuccess && response.updateProfileResponseModel != null){
                                showCustomSnackBar(response.updateProfileResponseModel!.message);
                              } else {
                                showCustomSnackBar(response.message);
                              }
                            });
                          }
                          else if(widget.fromSignUp) {
                            verificationController.verifyPhone(data: VerificationDataModel(
                              phone: _number, email: _email, verificationType: _number != null
                                ? VerificationTypeEnum.phone.name : VerificationTypeEnum.email.name,
                              otp: verificationController.verificationCode, loginType: widget.loginType,
                              guestId: AuthHelper.getGuestId(),
                            )).then((value) {
                              if(value.isSuccess) {
                                _handleVerifyResponse(value, _number, _email);
                              } else {
                                showCustomSnackBar(value.message);
                              }
                            });
                          } else {
                            verificationController.verifyToken(_number).then((value) {
                              if(value.isSuccess) {
                                if(ResponsiveHelper.isDesktop(Get.context!)){
                                  Get.dialog(Center(child: NewPassScreen(resetToken: verificationController.verificationCode, number : _number, fromPasswordChange: false, fromDialog: true )));
                                }else{
                                  Get.toNamed(RouteHelper.getResetPasswordRoute(_number, verificationController.verificationCode, 'reset-password'));
                                }
                              }else {
                                showCustomSnackBar(value.message);
                              }
                            });
                          }
                        },
                      ),
                    );
                  }
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 29 : Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    'did_not_receive_the_code'.tr,
                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                  ),
                  TextButton(
                    onPressed: _seconds < 1 ? () async {
                      if(widget.firebaseSession != null) {
                        await Get.find<AuthController>().firebaseVerifyPhoneNumber(_number!, widget.token, widget.loginType, fromSignUp: widget.fromSignUp, canRoute: false);
                        _startTimer();
                      } else {
                        _resendOtp();
                      }
                    } : null,
                    child: Text('${'resent_it'.tr}${_seconds > 0 ? ' (${_seconds}s)' : ''}', style: TextStyle(color: Theme.of(context).primaryColor),),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

            ]);
          }),
        )),
      ))),
    );
  }

  void _handleVerifyResponse(ResponseModel response, String? number, String? email) {
    if(response.authResponseModel != null && response.authResponseModel!.isExistUser != null) {
      if(ResponsiveHelper.isDesktop(context)) {
        Get.back();
        Get.dialog(Center(
          child: ExistingUserBottomSheet(
            userModel: response.authResponseModel!.isExistUser!, number: _number, email: _email,
            loginType: widget.loginType, otp: Get.find<VerificationController>().verificationCode,
          ),
        ));
      } else {
        Get.bottomSheet(ExistingUserBottomSheet(
          userModel: response.authResponseModel!.isExistUser!, number: _number, email: _email,
          loginType: widget.loginType, otp: Get.find<VerificationController>().verificationCode,
        ));
      }
    } else if(response.authResponseModel != null && !response.authResponseModel!.isPersonalInfo!) {
      if(ResponsiveHelper.isDesktop(context)) {
        Get.back();
        Get.dialog(NewUserSetupScreen(name: '', loginType: widget.loginType, phone: number, email: email));
      } else {
        Get.toNamed(RouteHelper.getNewUserSetupScreen(name: '', loginType: widget.loginType, phone: number, email: email));
      }
    } else {

      if(widget.fromForgetPassword) {
        Get.toNamed(RouteHelper.getResetPasswordRoute(_number, Get.find<VerificationController>().verificationCode, 'reset-password'));
      } else {
        Get.offNamed(RouteHelper.getAccessLocationRoute('verification'));
      }

      // showCustomSnackBar('successfully_verified'.tr, isError: false);

      // Future.delayed(const Duration(seconds: 1), () {
      //   if(widget.fromSignUp) {
      //     Get.offNamed(RouteHelper.getAccessLocationRoute('verification'));
      //     // Get.find<LocationController>().navigateToLocationScreen('verification', offAll: true);
      //   } else {
      //     Get.toNamed(RouteHelper.getResetPasswordRoute(_number, verificationController.verificationCode, 'reset-password'));
      //   }
      // });
    }
  }

  void _resendOtp() {
    if(widget.userModel != null) {
      Get.find<ProfileController>().updateUserInfo(widget.userModel!, Get.find<AuthController>().getUserToken(), fromVerification: true);
    } else if(widget.fromSignUp) {
      if(widget.loginType == CentralizeLoginType.otp.name) {
        Get.find<AuthController>().otpLogin(phone: _number!, otp: '', loginType: widget.loginType, verified: '').then((response) {
          if (response.isSuccess) {
            _startTimer();
            showCustomSnackBar('resend_code_successful'.tr, isError: false);
          } else {
            showCustomSnackBar(response.message);
          }
        });
      } else {
        Get.find<AuthController>().login(
          emailOrPhone: _number != null ? _number! : _email ?? '', password: widget.password!, loginType: widget.loginType,
          fieldType: _number != null ? VerificationTypeEnum.phone.name : VerificationTypeEnum.email.name,
        ).then((value) {
          if (value.isSuccess) {
            _startTimer();
            showCustomSnackBar('resend_code_successful'.tr, isError: false);
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    } else {
      Get.find<VerificationController>().forgetPassword(_number).then((value) {
        if (value.isSuccess) {
          _startTimer();
          showCustomSnackBar('resend_code_successful'.tr, isError: false);
        } else {
          showCustomSnackBar(value.message);
        }
      });
    }
  }
}
