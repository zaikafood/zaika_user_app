import 'package:flutter/cupertino.dart';
import 'package:zaika/common/widgets/custom_snackbar_widget.dart';
import 'package:zaika/features/auth/controllers/auth_controller.dart';
import 'package:zaika/features/cart/controllers/cart_controller.dart';
import 'package:zaika/features/language/controllers/localization_controller.dart';
import 'package:zaika/features/splash/controllers/splash_controller.dart';
import 'package:zaika/features/splash/controllers/theme_controller.dart';
import 'package:zaika/features/auth/widgets/auth_dialog_widget.dart';
import 'package:zaika/features/location/controllers/location_controller.dart';
import 'package:zaika/helper/address_helper.dart';
import 'package:zaika/helper/auth_helper.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/app_constants.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/images.dart';
import 'package:zaika/util/styles.dart';
import 'package:zaika/common/widgets/custom_dropdown_widget.dart';
import 'package:zaika/common/widgets/hover_widgets/text_hover_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebMenuBar extends StatelessWidget implements PreferredSizeWidget {
  final bool fromDineIn;
  const WebMenuBar({super.key, this.fromDineIn = false});

  @override
  Widget build(BuildContext context) {
    bool isSelectLanguage = false;

    return  Column(
      children: [
        Container(
          height: 40, width: double.infinity,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
          child: Center(
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: Row(children: [
                SizedBox(
                  width: 500,
                  child: AddressHelper.getAddressFromSharedPref() != null ? InkWell(
                    onTap: () => Get.find<SplashController>().navigateToLocationScreen('home'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: GetBuilder<LocationController>(builder: (locationController) {
                        return Row(children: [
                          Icon(
                            AddressHelper.getAddressFromSharedPref()!.addressType == 'home' ? CupertinoIcons.house_alt_fill
                                : AddressHelper.getAddressFromSharedPref()!.addressType == 'office' ? CupertinoIcons.bag_fill : CupertinoIcons.location_solid,
                            size: 16, color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Text(
                            AuthHelper.isLoggedIn() ? '${AddressHelper.getAddressFromSharedPref()!.addressType!.tr}: ' : '${'your_location'.tr}: ',
                            style: robotoMedium.copyWith(
                              color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall,
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),

                          Flexible(
                            child: Text(
                              AddressHelper.getAddressFromSharedPref()!.address!,
                              style: robotoRegular.copyWith(
                                color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeExtraSmall,
                              ),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down),
                        ]);
                      }),
                    ),
                  ) : const SizedBox(),
                ),

                const Spacer(),

                GetBuilder<LocalizationController>(builder: (localizationController) {

                  List<DropdownItem<int>> languageList = [];
                  List<DropdownItem<int>> joinUsList = [];

                  for(int index=0; index<AppConstants.languages.length; index++) {
                    languageList.add(DropdownItem<int>(value: index, child: Row(
                      children: [
                        SizedBox(height: 15, width: 15, child: Image.asset(AppConstants.languages[index].imageUrl!)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                          child: Text(AppConstants.languages[index].languageName!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),),
                        ),
                      ],
                    )));
                  }

                  if (Get.find<SplashController>().configModel!.toggleRestaurantRegistration!) {
                    joinUsList.add(DropdownItem<int>(
                      value: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                        child: Text(
                          AppConstants.joinDropdown[1].tr,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            fontWeight: FontWeight.w100,
                            color: Get.find<ThemeController>().darkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ));
                  }

                  if (Get.find<SplashController>().configModel!.toggleDmRegistration!) {
                    joinUsList.add(DropdownItem<int>(
                      value: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                        child: Text(
                          AppConstants.joinDropdown[2].tr,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            fontWeight: FontWeight.w100,
                            color: Get.find<ThemeController>().darkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ));
                  }

                  return Row(children: [
                    SizedBox(
                      width: 120,
                      child: CustomDropdown<int>(
                        onChange: (int? value, int index) {
                          localizationController.setLanguage(Locale(
                            AppConstants.languages[index].languageCode!,
                            AppConstants.languages[index].countryCode,
                          ));
                          localizationController.setSelectLanguageIndex(index);
                          isSelectLanguage = true;
                        },
                        dropdownButtonStyle: DropdownButtonStyle(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraSmall,
                            horizontal: Dimensions.paddingSizeExtraSmall,
                          ),
                          primaryColor: Theme.of(context).textTheme.bodyLarge!.color,

                        ),
                        dropdownStyle: DropdownStyle(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        ),
                        items: languageList,
                        child: Row(
                          children: [
                            SizedBox(height: 15, width: 15, child: Image.asset(isSelectLanguage ? AppConstants.languages[localizationController.selectedLanguageIndex].imageUrl! : AppConstants.languages[localizationController.selectedLanguageIndex].imageUrl!)),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                isSelectLanguage ? AppConstants.languages[localizationController.selectedLanguageIndex].languageName! : AppConstants.languages[localizationController.selectedLanguageIndex].languageName!,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Get.find<SplashController>().configModel!.toggleRestaurantRegistration! || Get.find<SplashController>().configModel!.toggleDmRegistration! ? ConstrainedBox (
                      constraints: const BoxConstraints(minWidth: 100, maxWidth: 170),
                      child: CustomDropdown<int>(
                        onChange: (int? value, int index) {
                          if(value == 1){
                            Get.toNamed(RouteHelper.getRestaurantRegistrationRoute());
                          } else if (value == 2) {
                            Get.toNamed(RouteHelper.getDeliverymanRegistrationRoute());
                          }
                        },
                        canAddValue: false,
                        dropdownButtonStyle: DropdownButtonStyle(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraSmall,
                            horizontal: Dimensions.paddingSizeExtraSmall,
                          ),
                          primaryColor: Theme.of(context).textTheme.bodyLarge!.color,

                        ),
                        dropdownStyle: DropdownStyle(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        ),
                        items: joinUsList,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.person, color: Get.find<ThemeController>().darkTheme ? Colors.white : Colors.black, size: 16,),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Text(AppConstants.joinDropdown[0].tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, fontWeight: FontWeight.w100, color: Get.find<ThemeController>().darkTheme ? Colors.white : Colors.black)),
                          ],
                        ),
                      ),

                    ) : SizedBox.shrink(),

                  ]);
                }),

                GetBuilder<ThemeController>(
                    builder: (themeController) {
                      return InkWell(
                        onTap: () => themeController.toggleTheme(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Icon(themeController.darkTheme ? CupertinoIcons.moon_stars_fill : CupertinoIcons.sun_min_fill, size: 18, color: Theme.of(context).primaryColor),
                        ),
                      );
                    }
                ),

                const SizedBox(width: Dimensions.paddingSizeSmall),

              ]),
            ),
          ),
        ),

        Container(
          width: double.infinity,
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Row(children: [
            InkWell(
              onTap: () => Get.toNamed(RouteHelper.getInitialRoute()),
              child: Row(children: [
                Image.asset(Images.logo, height: 30, width: 40),
               // Image.asset(Images.logoName, height: 40, width: 100),
              ]),
            ),

            const SizedBox(width: 20),

            Row(
              children: [
                MenuButton(title: 'home'.tr, onTap: () {
                  if(AddressHelper.getAddressFromSharedPref() != null) {
                    Get.toNamed(RouteHelper.getInitialRoute());
                  } else {
                    showCustomSnackBar('please_select_address_first'.tr,);
                  }
                }),
                const SizedBox(width: 20),

                MenuButton(title: 'categories'.tr, onTap: () {
                  if(AddressHelper.getAddressFromSharedPref() != null) {
                    Get.toNamed(RouteHelper.getCategoryRoute());
                  } else {
                    showCustomSnackBar('please_select_address_first'.tr,);
                  }
                }),
                const SizedBox(width: 20),

                MenuButton(title: 'cuisines'.tr, onTap: () {
                  if(AddressHelper.getAddressFromSharedPref() != null) {
                    Get.toNamed(RouteHelper.getCuisineRoute());
                  } else {
                    showCustomSnackBar('please_select_address_first'.tr,);
                  }
                }),
                const SizedBox(width: 20),

                MenuButton(title: 'restaurants'.tr, onTap: () {
                  if(AddressHelper.getAddressFromSharedPref() != null) {
                    Get.toNamed(RouteHelper.getAllRestaurantRoute('popular'));
                  } else {
                    showCustomSnackBar('please_select_address_first'.tr,);
                  }
                }),
                const SizedBox(width: 20),

                AuthHelper.isLoggedIn() ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: MenuButton(
                      title: 'favourite'.tr,
                      onTap: () {
                    if(AddressHelper.getAddressFromSharedPref() != null) {
                      Get.toNamed(RouteHelper.getFavouriteScreen());
                    } else {
                      showCustomSnackBar('please_select_address_first'.tr,);
                    }
                  }),
                ) : const SizedBox(),
              ],
            ),
            const Expanded(child: SizedBox()),

            MenuIconButton(icon: CupertinoIcons.search, onTap: () => Get.toNamed(RouteHelper.getSearchRoute())),
            const SizedBox(width: 20),

            MenuIconButton(icon: CupertinoIcons.bell_fill, onTap: () => Get.toNamed(RouteHelper.getNotificationRoute())),
            const SizedBox(width: 20),

            MenuIconButton(icon: Icons.shopping_cart, isCart: true, onTap: () => Get.toNamed(RouteHelper.getCartRoute(fromDineIn: fromDineIn))),
            const SizedBox(width: 20),

            GetBuilder<AuthController>(builder: (authController) {
              return InkWell(
                onTap: () {
                  if (authController.isLoggedIn()) {
                    Get.toNamed(RouteHelper.getProfileRoute());
                  }else{
                    Get.dialog(const Center(child: AuthDialogWidget(exitFromApp: false, backFromThis: false)), barrierDismissible: false,);
                  }
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Row(children: [
                    Icon(authController.isLoggedIn() ? CupertinoIcons.person_crop_square : CupertinoIcons.lock, size: 18, color: Get.find<ThemeController>().darkTheme ? Colors.white : Colors.black),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text(authController.isLoggedIn() ? 'profile'.tr : 'sign_in'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w100)),
                  ]),
                ),
              );
            }),

            MenuIconButton(icon: Icons.menu, onTap: () {
              Scaffold.of(context).openEndDrawer();
            }),
          ]),
          )),
        ),
      ],
    );
  }
  @override
  Size get preferredSize =>  const Size(Dimensions.webMaxWidth, 100);
}


class MenuButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const MenuButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextHoverWidget(builder: (hovered) {
      return InkWell(
        onTap: onTap as void Function()?,
        child: Text(title, style: robotoRegular.copyWith(color: hovered ? Theme.of(context).primaryColor : null)),
      );
    });
  }
}


class MenuIconButton extends StatelessWidget {
  final IconData icon;
  final bool isCart;
  final Function onTap;
  const MenuIconButton({super.key, required this.icon, this.isCart = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextHoverWidget(builder: (hovered) {
      return IconButton(
        onPressed: onTap as void Function()?,
        icon: GetBuilder<CartController>(builder: (cartController) {
          return Stack(clipBehavior: Clip.none, children: [
            Icon(
              icon,
              color: hovered ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color,
            ),
            (isCart && cartController.cartList.isNotEmpty) ? Positioned(
              top: -5, right: -5,
              child: Container(
                height: 15, width: 15, alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                child: Text(
                  cartController.cartList.length.toString(),
                  style: robotoRegular.copyWith(fontSize: 12, color: Theme.of(context).cardColor),
                ),
              ),
            ) : const SizedBox()
          ]);
        }),
      );
    });
  }
}

