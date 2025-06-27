import 'dart:convert';
import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:zaika/common/widgets/confirmation_dialog_widget.dart';
import 'package:zaika/common/widgets/custom_tool_tip.dart';
import 'package:zaika/common/widgets/validate_check.dart';
import 'package:zaika/features/auth/domain/models/restaurant_body_model.dart';
import 'package:zaika/features/auth/domain/models/translation_body_model.dart';
import 'package:zaika/features/auth/widgets/cuisine_widget.dart';
import 'package:zaika/features/business/widgets/base_card_widget.dart';
import 'package:zaika/features/business/widgets/package_card_widget.dart';
import 'package:zaika/features/business/widgets/web_business_plan_widget.dart';
import 'package:zaika/features/dashboard/screens/dashboard_screen.dart';
import 'package:zaika/features/language/controllers/localization_controller.dart';
import 'package:zaika/features/splash/controllers/splash_controller.dart';
import 'package:zaika/features/splash/domain/models/config_model.dart';
import 'package:zaika/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:zaika/features/auth/controllers/restaurant_registration_controller.dart';
import 'package:zaika/features/auth/widgets/custom_time_picker_widget.dart';
import 'package:zaika/features/auth/widgets/pass_view_widget.dart';
import 'package:zaika/features/auth/widgets/registration_stepper_widget.dart';
import 'package:zaika/features/auth/widgets/restaurant_additional_data_section_widget.dart';
import 'package:zaika/features/auth/widgets/select_location_view_widget.dart';
import 'package:zaika/features/cuisine/controllers/cuisine_controller.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/images.dart';
import 'package:zaika/util/styles.dart';
import 'package:zaika/common/widgets/custom_app_bar_widget.dart';
import 'package:zaika/common/widgets/custom_button_widget.dart';
import 'package:zaika/common/widgets/custom_snackbar_widget.dart';
import 'package:zaika/common/widgets/custom_text_field_widget.dart';
import 'package:zaika/common/widgets/footer_view_widget.dart';
import 'package:zaika/common/widgets/menu_drawer_widget.dart';
import 'package:zaika/common/widgets/web_page_title_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/api_checker.dart';

class RestaurantRegistrationScreen extends StatefulWidget {
  const RestaurantRegistrationScreen({super.key});

  @override
  State<RestaurantRegistrationScreen> createState() => _RestaurantRegistrationScreenState();
}

class _RestaurantRegistrationScreenState extends State<RestaurantRegistrationScreen> with TickerProviderStateMixin {
  final List<TextEditingController> _nameController = [];
  final List<TextEditingController> _addressController = [];
  final TextEditingController _vatController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();
  final List<FocusNode> _nameFocus = [];
  final List<FocusNode> _addressFocus = [];
  final FocusNode _vatFocus = FocusNode();
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _cuisineFocus = FocusNode();
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  TabController? _tabController;
  final List<Tab> _tabs =[];
  bool firstTime = true;
  String? _countryDialCode;
  final ScrollController _scrollController = ScrollController();
  GlobalKey<FormState>? _formKeyLogin;
  GlobalKey<FormState>? _formKeySecond;
  final JustTheController tooltipController = JustTheController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _languageList!.length, initialIndex: 0, vsync: this);
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    for (var language in _languageList) {
      if (kDebugMode) {
        print(language);
      }
      _nameController.add(TextEditingController());
      _addressController.add(TextEditingController());
      _nameFocus.add(FocusNode());
      _addressFocus.add(FocusNode());
    }
    Get.find<RestaurantRegistrationController>().setRestaurantAdditionalJoinUsPageData(isUpdate: false);
    Get.find<RestaurantRegistrationController>().storeStatusChange(0.1, isUpdate: false);
    Get.find<RestaurantRegistrationController>().getZoneList();
    Get.find<CuisineController>().getCuisineList();
    if(Get.find<DeliverymanRegistrationController>().showPassView){
      Get.find<DeliverymanRegistrationController>().showHidePassView();
    }

    Get.find<RestaurantRegistrationController>().resetBusiness();
    Get.find<RestaurantRegistrationController>().getPackageList(isUpdate: false);

    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }
    _formKeyLogin = GlobalKey<FormState>();
    _formKeySecond = GlobalKey<FormState>();
  }

  Future<void> _showBackPressedDialogue(String title)async {
    Get.dialog(ConfirmationDialogWidget(icon: Images.support,
      title: title,
      description: 'are_you_sure_to_go_back'.tr, isLogOut: true,
      onYesPressed: () {
        if(Get.isDialogOpen!){
          Get.back();
        }
        if(ResponsiveHelper.isDesktop(Get.context)) {
          Get.back();
        }else {
          Get.off(() => const DashboardScreen(pageIndex: 4));
        }
      },
    ), useSafeArea: false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantRegistrationController>(builder: (restaurantRegController) {

      if(restaurantRegController.restaurantAddress != null){
        _addressController[0].text = restaurantRegController.restaurantAddress.toString();
      }
      
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async{
          if(restaurantRegController.storeStatus == 0.6 && firstTime){
            restaurantRegController.storeStatusChange(0.1);
            firstTime = false;
          }else if(restaurantRegController.storeStatus == 0.9){
            restaurantRegController.storeStatusChange(0.6);
          }else{
            await _showBackPressedDialogue('your_registration_not_setup_yet'.tr);
          }
        },
        child: Scaffold(
          endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
          appBar: CustomAppBarWidget(title: 'restaurant_registration'.tr, onBackPressed: () async {
            if(restaurantRegController.storeStatus != 0.1 && firstTime){
              restaurantRegController.storeStatusChange(0.1);
              firstTime = false;
            }else{
              await _showBackPressedDialogue('your_registration_not_setup_yet'.tr);
            }
          }),
          body: SafeArea(
            child: Center(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                
                WebScreenTitleWidget( title: 'join_as_a_restaurant'.tr ),

                ResponsiveHelper.isDesktop(context) ? Center(child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 35),
                    child: RegistrationStepperWidget(status: restaurantRegController.storeStatus == 0.9 ? 'business' : ''),
                  ),
                )) : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical:  Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      restaurantRegController.storeStatus == 0.1 ? 'provide_store_information_to_proceed_next'.tr : restaurantRegController.storeStatus == 0.6 ? 'provide_owner_information_to_confirm'.tr : 'you_are_one_step_away_choose_your_business_plan'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    LinearProgressIndicator(
                      backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                      value: restaurantRegController.storeStatus,
                    ),
                  ]),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                    child: FooterViewWidget(
                      child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: ResponsiveHelper.isDesktop(context) ? webView(restaurantRegController) : Column(children: [
                          
                          Visibility(
                            visible: restaurantRegController.storeStatus == 0.1,
                            child: Form(
                              key: _formKeyLogin,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                Text('restaurant_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                                  child: Column(children: [

                                    SizedBox(
                                      height: 40,
                                      child: TabBar(
                                        tabAlignment: TabAlignment.start,
                                        controller: _tabController,
                                        indicatorColor: Theme.of(context).primaryColor,
                                        indicatorWeight: 3,
                                        labelColor: Theme.of(context).primaryColor,
                                        unselectedLabelColor: Theme.of(context).disabledColor,
                                        unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                        labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                                        labelPadding: const EdgeInsets.only(right: Dimensions.radiusDefault),
                                        isScrollable: true,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        tabs: _tabs,
                                        onTap: (int ? value) {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                                      child: Divider(height: 0),
                                    ),

                                    CustomTextFieldWidget(
                                      titleText: 'write_restaurant_name'.tr,
                                      errorText: ApiChecker.errors['name'],
                                      controller: _nameController[_tabController!.index],
                                      focusNode: _nameFocus[_tabController!.index],
                                      nextFocus: _tabController!.index != _languageList!.length-1 ? _addressFocus[_tabController!.index] : _addressFocus[0],
                                      inputType: TextInputType.name,
                                      prefixImage: Images.shopIcon,
                                      capitalization: TextCapitalization.words,
                                      labelText: '${'store_name'.tr} (${_languageList[_tabController!.index].value!})',
                                      required: true,
                                      validator: (value) => ValidateCheck.validateEmptyText(value, "restaurant_name_field_is_required".tr),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                                    Row(children: [
                                      Expanded(flex: 4,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('restaurant_logo'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                            const SizedBox(height: Dimensions.paddingSizeDefault),

                                            Align(alignment: Alignment.center, child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Stack(children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                      child: restaurantRegController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                                                        restaurantRegController.pickedLogo!.path, width: 150, height: 120, fit: BoxFit.cover,
                                                      ) : Image.file(
                                                        File(restaurantRegController.pickedLogo!.path), width: 150, height: 120, fit: BoxFit.cover,
                                                      ) : SizedBox(
                                                        width: 150, height: 120,
                                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                                          Icon(CupertinoIcons.photo_camera_solid, size: 38, color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),
                                                          const SizedBox(height: Dimensions.paddingSizeSmall),

                                                          Text(
                                                            'upload_store_logo'.tr,
                                                            style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                                          Text(
                                                            '(${'1_1_ratio'.tr})',
                                                            style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.6), fontSize: Dimensions.fontSizeSmall - 2), textAlign: TextAlign.center,
                                                          ),

                                                        ]),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0, right: 0, top: 0, left: 0,
                                                    child: InkWell(
                                                      onTap: () => restaurantRegController.pickImage(true, false),
                                                      child: DottedBorder(
                                                        color: Theme.of(context).primaryColor,
                                                        strokeWidth: 1,
                                                        strokeCap: StrokeCap.butt,
                                                        dashPattern: const [5, 5],
                                                        padding: const EdgeInsets.all(0),
                                                        borderType: BorderType.RRect,
                                                        radius: const Radius.circular(Dimensions.radiusDefault),
                                                        child: Center(
                                                          child: Visibility(
                                                            visible: restaurantRegController.pickedLogo != null,
                                                            child: Container(
                                                              padding: const EdgeInsets.all(25),
                                                              decoration: BoxDecoration(
                                                                border: Border.all(width: 2, color: Colors.white),
                                                                shape: BoxShape.circle,
                                                              ),
                                                              child: const Icon(CupertinoIcons.photo_camera_solid, color: Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                if (ApiChecker.errors['logo'] != null)
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0),
                                                    child: Text(
                                                      ApiChecker.errors['logo']!,
                                                      style: TextStyle(color: Colors.red, fontSize: 12),
                                                    ),
                                                  ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeDefault),

                                      Expanded(flex: 6,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('restaurant_cover'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                            const SizedBox(height: Dimensions.paddingSizeDefault),

                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Stack(children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                      child: restaurantRegController.pickedCover != null ? GetPlatform.isWeb ? Image.network(
                                                        restaurantRegController.pickedCover!.path, width: context.width, height: 120, fit: BoxFit.cover,
                                                      ) : Image.file(
                                                        File(restaurantRegController.pickedCover!.path), width: context.width, height: 120, fit: BoxFit.cover,
                                                      ) : SizedBox(
                                                        width: context.width, height: 120,
                                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                                          Icon(CupertinoIcons.photo_camera_solid, size: 38, color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),

                                                          Text(
                                                            'upload_store_cover'.tr,
                                                            style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                                                          ),

                                                          Text(
                                                            'upload_jpg_png_gif_maximum_2_mb'.tr,
                                                            style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.6), fontSize: Dimensions.fontSizeSmall - 2),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                                          Text(
                                                            '(${'1_2_ratio'.tr})',
                                                            style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.6), fontSize: Dimensions.fontSizeSmall - 2), textAlign: TextAlign.center,
                                                          ),

                                                        ]),
                                                      ),
                                                    ),
                                                  ),


                                                  Positioned(
                                                    bottom: 0, right: 0, top: 0, left: 0,
                                                    child: InkWell(
                                                      onTap: () => restaurantRegController.pickImage(false, false),
                                                      child: DottedBorder(
                                                        color: Theme.of(context).primaryColor,
                                                        strokeWidth: 1,
                                                        strokeCap: StrokeCap.butt,
                                                        dashPattern: const [5, 5],
                                                        padding: const EdgeInsets.all(0),
                                                        borderType: BorderType.RRect,
                                                        radius: const Radius.circular(Dimensions.radiusDefault),
                                                        child: Center(
                                                          child: Visibility(
                                                            visible: restaurantRegController.pickedCover != null,
                                                            child: Container(
                                                              padding: const EdgeInsets.all(25),
                                                              decoration: BoxDecoration(
                                                                border: Border.all(width: 3, color: Colors.white),
                                                                shape: BoxShape.circle,
                                                              ),
                                                              child: const Icon(CupertinoIcons.photo_camera_solid, color: Colors.white, size: 50),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                if (ApiChecker.errors['cover_photo'] != null)
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0),
                                                    child: Text(
                                                      ApiChecker.errors['cover_photo']!,
                                                      style: TextStyle(color: Colors.red, fontSize: 12),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ]),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                Text('location_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                restaurantRegController.zoneList != null ? SelectLocationViewWidget(
                                  fromView: true, addressController: _addressController[0], addressFocus: _addressFocus[0],
                                ) : const Center(child: CircularProgressIndicator()),

                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                Text('restaurant_preference'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                                  child: Column(children: [

                                    CuisineWidget(cuisineTextController: _cuisineController, cuisineFocus: _cuisineFocus),
                                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                                    CustomTextFieldWidget(
                                      titleText: 'write_vat_tax_amount'.tr,
                                      errorText: ApiChecker.errors['vat'],
                                      controller: _vatController,
                                      focusNode: _vatFocus,
                                      inputAction: TextInputAction.done,
                                      inputType: TextInputType.number,
                                      prefixImage: Images.vatTaxIcon,
                                      isAmount: true,
                                      suffixChild: CustomToolTip(
                                        message: 'please_provide_vat_tax_amount'.tr,
                                        preferredDirection: AxisDirection.down,
                                        iconColor: Theme.of(context).disabledColor,
                                      ),
                                      labelText: 'vat_tax'.tr,
                                      required: true,
                                      validator: (value) => ValidateCheck.validateEmptyText(value, "restaurant_vat_tax_field_is_required".tr),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                                    InkWell(
                                      onTap: () {
                                        Get.dialog(const CustomTimePickerWidget());
                                      },
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                              border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                            child: Row(children: [
                                              Expanded(child: Text(
                                                '${restaurantRegController.storeMinTime} : ${restaurantRegController.storeMaxTime} ${restaurantRegController.storeTimeUnit}',
                                                style: robotoMedium,
                                              )),
                                              Icon(Icons.access_time_filled, color: Theme.of(context).primaryColor,)
                                            ]),
                                          ),

                                          Positioned(
                                            left: 10, top: -15,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                              ),
                                              padding: const EdgeInsets.all(5),
                                              child: Text('select_time'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),

                              ]),
                            ),
                          ),

                          Visibility(
                            visible: restaurantRegController.storeStatus == 0.6,
                            child: Form(
                              key: _formKeySecond,
                              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

                                Row(children: [
                                  Text('owner_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  CustomToolTip(
                                    message: 'this_info_will_need_for_restaurant_app_and_panel_login'.tr,
                                    tooltipController: tooltipController,
                                    preferredDirection: AxisDirection.down,
                                  ),
                                ]),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    CustomTextFieldWidget(
                                      titleText: 'write_first_name'.tr,
                                      errorText: ApiChecker.errors['fName'],
                                      controller: _fNameController,
                                      focusNode: _fNameFocus,
                                      nextFocus: _lNameFocus,
                                      inputType: TextInputType.name,
                                      capitalization: TextCapitalization.words,
                                      prefixIcon: CupertinoIcons.person_crop_circle_fill,
                                      iconSize: 25,
                                      required: true,
                                      labelText: 'first_name'.tr,
                                      validator: (value) => ValidateCheck.validateEmptyText(value, "first_name_field_is_required".tr),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                                    CustomTextFieldWidget(
                                      titleText: 'write_last_name'.tr,
                                      errorText: ApiChecker.errors['lName'],
                                      controller: _lNameController,
                                      focusNode: _lNameFocus,
                                      nextFocus: _phoneFocus,
                                      prefixIcon: CupertinoIcons.person_crop_circle_fill,
                                      iconSize: 25,
                                      inputType: TextInputType.name,
                                      capitalization: TextCapitalization.words,
                                      required: true,
                                      labelText: 'last_name'.tr,
                                      validator: (value) => ValidateCheck.validateEmptyText(value, "last_name_field_is_required".tr),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                                    CustomTextFieldWidget(
                                      titleText: ResponsiveHelper.isDesktop(context) ? 'phone'.tr : 'enter_phone_number'.tr,
                                      controller: _phoneController,
                                      errorText: ApiChecker.errors['phone'],
                                      focusNode: _phoneFocus,
                                      nextFocus: _emailFocus,
                                      inputType: TextInputType.phone,
                                      isPhone: true,
                                      showTitle: ResponsiveHelper.isDesktop(context),
                                      onCountryChanged: (CountryCode countryCode) {
                                        _countryDialCode = countryCode.dialCode;
                                      },
                                      countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                                          : Get.find<LocalizationController>().locale.countryCode,
                                      required: true,
                                      labelText: 'phone'.tr,
                                      validator: (value) => ValidateCheck.validateEmptyText(value, null),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                                    CustomTextFieldWidget(
                                      titleText: 'write_email'.tr,
                                      errorText: ApiChecker.errors['email'],
                                      controller: _emailController,
                                      focusNode: _emailFocus,
                                      nextFocus: _passwordFocus,
                                      inputType: TextInputType.emailAddress,
                                      prefixIcon: Icons.email,
                                      iconSize: 25,
                                      required: true,
                                      labelText: 'email'.tr,
                                      validator: (value) => ValidateCheck.validateEmail(value),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                                    GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanRegiController) {
                                      return Column(children: [
                                        CustomTextFieldWidget(
                                          titleText: '8+characters'.tr,
                                          errorText: ApiChecker.errors['password'],
                                          controller: _passwordController,
                                          focusNode: _passwordFocus,
                                          nextFocus: _confirmPasswordFocus,
                                          inputType: TextInputType.visiblePassword,
                                          prefixIcon: Icons.lock,
                                          iconSize: 25,
                                          isPassword: true,
                                          onChanged: (value){
                                            if(value != null && value.isNotEmpty){
                                              if(!deliverymanRegiController.showPassView){
                                                deliverymanRegiController.showHidePassView();
                                              }
                                              deliverymanRegiController.validPassCheck(value);
                                            }else{
                                              if(deliverymanRegiController.showPassView){
                                                deliverymanRegiController.showHidePassView();
                                              }
                                            }
                                          },
                                          required: true,
                                          labelText: 'password'.tr,
                                          validator: (value) => ValidateCheck.validateEmptyText(value, "password_field_is_required".tr),
                                        ),
                                        deliverymanRegiController.showPassView ? const PassViewWidget() : const SizedBox(),

                                      ]);
                                    }),

                                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                                    CustomTextFieldWidget(
                                      titleText: '8+characters'.tr,
                                      controller: _confirmPasswordController,
                                      errorText: ApiChecker.errors['confirm_password'],
                                      focusNode: _confirmPasswordFocus,
                                      inputType: TextInputType.visiblePassword,
                                      inputAction: TextInputAction.done,
                                      prefixIcon: Icons.lock,
                                      iconSize: 25,
                                      isPassword: true,
                                      required: true,
                                      labelText: 'confirm_password'.tr,
                                      validator: (value) => ValidateCheck.validateEmptyText(value, "password_field_is_required".tr),
                                    ),
                                    // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                  ]),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                restaurantRegController.dataList!.isNotEmpty ? Text('additional_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)) : const SizedBox(),
                                SizedBox(height: restaurantRegController.dataList!.isNotEmpty ? Dimensions.paddingSizeLarge : 0),

                                restaurantRegController.dataList!.isNotEmpty ? RestaurantAdditionalDataSectionWidget(restaurantRegiController: restaurantRegController, scrollController: _scrollController) : const SizedBox(),

                              ]),
                            ),
                          ),

                          Visibility(
                            visible: restaurantRegController.storeStatus == 0.9,
                            child: Column(children: [

                              Padding(
                                padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeOverLarge),
                                child: Center(child: Text('choose_your_business_plan'.tr, style: robotoBold)),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                child: Row(children: [

                                  Get.find<SplashController>().configModel!.commissionBusinessModel != 0 ? Expanded(
                                    child: BaseCardWidget(restaurantRegistrationController: restaurantRegController, title: 'commission_base'.tr,
                                      index: 0, onTap: ()=> restaurantRegController.setBusiness(0),
                                    ),
                                  ) : const SizedBox(),
                                  SizedBox(width: Get.find<SplashController>().configModel!.commissionBusinessModel != 0 ? Dimensions.paddingSizeDefault : 0),

                                  Get.find<SplashController>().configModel!.subscriptionBusinessModel != 0 ? Expanded(
                                    child: BaseCardWidget(restaurantRegistrationController: restaurantRegController, title: 'subscription_base'.tr,
                                      index: 1, onTap: ()=> restaurantRegController.setBusiness(1),
                                    ),
                                  ) : const SizedBox(),

                                ]),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                              restaurantRegController.businessIndex == 0 ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                child: Text(
                                  "${'restaurant_will_pay'.tr} ${Get.find<SplashController>().configModel!.adminCommission}% ${'commission_to'.tr} ${Get.find<SplashController>().configModel!.businessName} ${'from_each_order_You_will_get_access_of_all'.tr}",
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.justify, textScaler: const TextScaler.linear(1.1),
                                ),
                              ) : Column(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                  child: Text(
                                    'run_restaurant_by_purchasing_subscription_packages'.tr,
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.justify, textScaler: const TextScaler.linear(1.1),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                restaurantRegController.packageModel != null ? SizedBox(
                                  height: 440,
                                  child: restaurantRegController.packageModel!.packages!.isNotEmpty ? Swiper(
                                    itemCount: restaurantRegController.packageModel!.packages!.length,
                                    viewportFraction: restaurantRegController.packageModel!.packages!.length > 1 ? 0.7 : 1,
                                    physics: restaurantRegController.packageModel!.packages!.length > 1 ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return PackageCardWidget(
                                        canSelect: restaurantRegController.activeSubscriptionIndex == index,
                                        packages: restaurantRegController.packageModel!.packages![index],
                                      );
                                    },
                                    onIndexChanged: (index) {
                                      restaurantRegController.selectSubscriptionCard(index);
                                    },

                                  ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(Images.emptyFoodIcon, height: 150),
                                      const SizedBox(height: Dimensions.paddingSizeLarge),
                                      Text('no_package_available'.tr, style: robotoMedium),
                                    ]),
                                  ),
                                ) : const CircularProgressIndicator(),

                              ]),

                            ]),
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          
                        ]),
                      ),
                    ),
                  ),
                ),

                ResponsiveHelper.isDesktop(context) ? const SizedBox() : buttonView(),

              ]),
            ),
          ),
        ),
      );
    });
  }

  Widget webView(RestaurantRegistrationController restaurantRegistrationController){
    return Form(
      key: _formKeySecond,
      child: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

          restaurantRegistrationController.storeStatus != 0.9 ? Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      height: 40,
                      width: 500,
                      color: Colors.transparent,
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        controller: _tabController,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorWeight: 3,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Theme.of(context).disabledColor,
                        unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                        labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        labelPadding: const EdgeInsets.symmetric(horizontal: Dimensions.radiusDefault, vertical: 0 ),
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: _tabs,
                        onTap: (int ? value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Expanded(
                      child: Column( children: [
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                        CustomTextFieldWidget(
                          hintText: 'write_restaurant_name'.tr,
                          controller: _nameController[_tabController!.index],
                          focusNode: _nameFocus[_tabController!.index],
                          nextFocus: _tabController!.index != _languageList!.length-1 ? _addressFocus[_tabController!.index] : _addressFocus[0],
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                          prefixImage: Images.shopIcon,
                          labelText: '${'store_name'.tr} (${_languageList[_tabController!.index].value!})',
                          required: true,
                          validator: (value) => ValidateCheck.validateEmptyText(value, "restaurant_name_field_is_required".tr),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextFieldWidget(
                          hintText: 'write_restaurant_address'.tr,
                          controller: _addressController[0],
                          focusNode: _addressFocus[0],
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.text,
                          capitalization: TextCapitalization.sentences,
                          maxLines: 3,
                          required: true,
                          labelText: 'restaurant_address'.tr,
                          validator: (value) => ValidateCheck.validateEmptyText(value, "restaurant_address_field_is_required".tr),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CuisineWidget(cuisineTextController: _cuisineController, cuisineFocus: _cuisineFocus),

                      ]),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraOverLarge),

                    Expanded(
                      child: Column(children: [
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                        restaurantRegistrationController.zoneList != null ? SelectLocationViewWidget(fromView: true, addressController: _addressController[0], addressFocus: _addressFocus[0]) : const Center(child: CircularProgressIndicator()),
                      ]),
                    ),
                  ]),
                  // const SizedBox(height: Dimensions.paddingSizeSmall),
                ]),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Column(children: [

                  Row(children: [
                    const Icon(Icons.person),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text('general_information'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  ]),
                  const Divider(),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: Column(children: [

                      CustomTextFieldWidget(
                        hintText: 'write_vat_tax_amount'.tr,
                        controller: _vatController,
                        focusNode: _vatFocus,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.number,
                        prefixImage: Images.vatTaxIcon,
                        isAmount: true,
                        labelText: 'vat_tax'.tr,
                        required: true,
                        validator: (value) => ValidateCheck.validateEmptyText(value, "restaurant_vat_tax_field_is_required".tr),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

                      InkWell(
                        onTap: () {
                          Get.dialog(const CustomTimePickerWidget());
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                              child: Row(children: [
                                Expanded(child: Text(
                                  '${restaurantRegistrationController.storeMinTime} : ${restaurantRegistrationController.storeMaxTime} ${restaurantRegistrationController.storeTimeUnit}',
                                  style: robotoMedium,
                                )),
                                Icon(Icons.access_time_filled, color: Theme.of(context).primaryColor,)
                              ]),
                            ),

                            Positioned(
                              left: 10, top: -15,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                ),
                                padding: const EdgeInsets.all(5),
                                child: Text('select_time'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ])),

                    Expanded(child:  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Expanded(flex: 4, child:  Align(alignment: Alignment.center, child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: restaurantRegistrationController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                            restaurantRegistrationController.pickedLogo!.path, width: 150, height: 120, fit: BoxFit.cover,
                          ) : Image.file(
                            File(restaurantRegistrationController.pickedLogo!.path), width: 150, height: 120, fit: BoxFit.cover,
                          ) : SizedBox(
                            width: 150, height: 120,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(CupertinoIcons.camera_fill, color: Theme.of(context).disabledColor.withValues(alpha: 0.8), size: 38),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Text('upload_store_logo'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeExtraSmall)),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Text(
                                'upload_jpg_png_gif_maximum_2_mb'.tr,
                                style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.6), fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                          ),
                        ),
                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: InkWell(
                            onTap: () => restaurantRegistrationController.pickImage(true, false),
                            child: DottedBorder(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.butt,
                              dashPattern: const [5, 5],
                              padding: const EdgeInsets.all(0),
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.radiusDefault),
                              child: Center(
                                child: Visibility(
                                  visible: restaurantRegistrationController.pickedLogo != null,
                                  child: Container(
                                    padding: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2, color: Colors.white),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(flex: 6, child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: restaurantRegistrationController.pickedCover != null ? GetPlatform.isWeb ? Image.network(
                            restaurantRegistrationController.pickedCover!.path, width: context.width, height: 120, fit: BoxFit.cover,
                          ) : Image.file(
                            File(restaurantRegistrationController.pickedCover!.path), width: context.width, height: 120, fit: BoxFit.cover,
                          ) : SizedBox(
                            width: context.width, height: 120,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              Icon(CupertinoIcons.camera_fill, color: Theme.of(context).disabledColor.withValues(alpha: 0.8), size: 38),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Text('upload_store_cover'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeExtraSmall)),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Text(
                                'upload_jpg_png_gif_maximum_2_mb'.tr,
                                style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.6), fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                          ),
                        ),
                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: InkWell(
                            onTap: () => restaurantRegistrationController.pickImage(false, false),
                            child: DottedBorder(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.butt,
                              dashPattern: const [5, 5],
                              padding: const EdgeInsets.all(0),
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.radiusDefault),
                              child: Center(
                                child: Visibility(
                                  visible: restaurantRegistrationController.pickedCover != null,
                                  child: Container(
                                    padding: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 3, color: Colors.white),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 50),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),
                    ])),
                  ]),

                ]),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Column(children: [

                  Row(children: [
                    const Icon(Icons.person),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text('owner_information'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  ]),
                  const Divider(),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Row(children: [
                    Expanded(child: CustomTextFieldWidget(
                      hintText: 'write_first_name'.tr,
                      controller: _fNameController,
                      focusNode: _fNameFocus,
                      nextFocus: _lNameFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                      prefixIcon: CupertinoIcons.person_crop_circle_fill,
                      iconSize: 25,
                      required: true,
                      labelText: 'first_name'.tr,
                      validator: (value) => ValidateCheck.validateEmptyText(value, "first_name_field_is_required".tr),
                    )),
                    const SizedBox(width: Dimensions.paddingSizeLarge),

                    Expanded(child: CustomTextFieldWidget(
                      hintText: 'write_last_name'.tr,
                      controller: _lNameController,
                      focusNode: _lNameFocus,
                      nextFocus: _phoneFocus,
                      inputType: TextInputType.name,
                      prefixIcon: CupertinoIcons.person_crop_circle_fill,
                      iconSize: 25,
                      capitalization: TextCapitalization.words,
                      required: true,
                      labelText: 'last_name'.tr,
                      validator: (value) => ValidateCheck.validateEmptyText(value, "last_name_field_is_required".tr),
                    )),
                    const SizedBox(width: Dimensions.paddingSizeLarge),

                    Expanded(
                      child: CustomTextFieldWidget(
                        hintText: ResponsiveHelper.isDesktop(context) ? 'phone'.tr : 'enter_phone_number'.tr,
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        nextFocus: _emailFocus,
                        inputType: TextInputType.phone,
                        isPhone: true,
                        onCountryChanged: (CountryCode countryCode) {
                          _countryDialCode = countryCode.dialCode;
                        },
                        countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                            : Get.find<LocalizationController>().locale.countryCode,
                        required: true,
                        labelText: 'phone'.tr,
                        validator: (value) => ValidateCheck.validateEmptyText(value, null),
                      ),
                    ),
                  ]),
                ]),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Column(children: [

                  Row(children: [
                    const Icon(Icons.lock),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text('login_info'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  ]),
                  const Divider(),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: CustomTextFieldWidget(
                        hintText: 'write_email'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        iconSize: 25,
                        required: true,
                        labelText: 'email'.tr,
                        validator: (value) => ValidateCheck.validateEmail(value),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeLarge),

                    Expanded(
                      child: GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanRegiController) {
                        return Column(children: [
                          CustomTextFieldWidget(
                            hintText: '8+characters'.tr,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            nextFocus: _confirmPasswordFocus,
                            inputType: TextInputType.visiblePassword,
                            prefixIcon: Icons.lock,
                            iconSize: 25,
                            isPassword: true,
                            onChanged: (value){
                              if(value != null && value.isNotEmpty){
                                if(!deliverymanRegiController.showPassView){
                                  deliverymanRegiController.showHidePassView();
                                }
                                deliverymanRegiController.validPassCheck(value);
                              }else{
                                if(deliverymanRegiController.showPassView){
                                  deliverymanRegiController.showHidePassView();
                                }
                              }
                            },
                            required: true,
                            labelText: 'password'.tr,
                            validator: (value) => ValidateCheck.validateEmptyText(value, "password_field_is_required".tr),
                          ),
                          deliverymanRegiController.showPassView ? const PassViewWidget() : const SizedBox(),

                        ]);
                      }),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeLarge),

                    Expanded(child: CustomTextFieldWidget(
                      titleText: '8+characters'.tr,
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      inputType: TextInputType.visiblePassword,
                      inputAction: TextInputAction.done,
                      prefixIcon: Icons.lock,
                      iconSize: 25,
                      isPassword: true,
                      required: true,
                      labelText: 'confirm_password'.tr,
                      validator: (value) => ValidateCheck.validateEmptyText(value, "password_field_is_required".tr),
                    )),
                  ]),
                ]),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Column(children: [

                  restaurantRegistrationController.dataList!.isNotEmpty ? Row(children: [
                    const Icon(Icons.person),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text('additional_information'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  ]) : const SizedBox(),
                  restaurantRegistrationController.dataList!.isNotEmpty ? const Divider() : const SizedBox(),

                  restaurantRegistrationController.dataList!.isNotEmpty ? RestaurantAdditionalDataSectionWidget(restaurantRegiController: restaurantRegistrationController, scrollController: _scrollController) : const SizedBox(),

                ]),
              ),
            ],
          ) : const SizedBox(),

          restaurantRegistrationController.storeStatus == 0.9 ? const WebBusinessPlanWidget() : const SizedBox(),
          SizedBox(height: 30),

          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(color: Theme.of(context).hintColor),
              ),
              width: 165,
              child: CustomButtonWidget(
                transparent: true,
                textColor: Theme.of(context).disabledColor,
                radius: Dimensions.radiusSmall,
                onPressed: () {

                  if(restaurantRegistrationController.storeStatus == 0.9){
                    restaurantRegistrationController.storeStatusChange(0.6);
                  }else {
                    _phoneController.text = '';
                    _emailController.text = '';
                    _fNameController.text = '';
                    _lNameController.text = '';
                    _lNameController.text = '';
                    _vatController.text = '';
                    _passwordController.text = '';
                    _confirmPasswordController.text = '';
                    for (int i = 0; i < _nameController.length; i++) {
                      _nameController[i].text = '';
                    }
                    for (int i = 0; i < _addressController.length; i++) {
                      _addressController[i].text = '';
                    }
                    restaurantRegistrationController.resetRestaurantRegistration();

                    restaurantRegistrationController.setRestaurantAdditionalJoinUsPageData(isUpdate: true);
                  }
                },
                buttonText: restaurantRegistrationController.storeStatus == 0.9 ? 'back'.tr : 'reset'.tr,
                isBold: false,
                fontSize: Dimensions.fontSizeSmall,
              ),
            ),

            SizedBox(width: (restaurantRegistrationController.storeStatus == 0.9) && (Get.find<SplashController>().configModel!.commissionBusinessModel == 0) &&
                restaurantRegistrationController.packageModel!.packages!.isEmpty ? 0 : Dimensions.paddingSizeLarge),

            (restaurantRegistrationController.storeStatus == 0.9) && (Get.find<SplashController>().configModel!.commissionBusinessModel == 0) &&
             restaurantRegistrationController.packageModel!.packages!.isEmpty ? const SizedBox() : SizedBox(width: 165, child: buttonView()),
          ]),

        ]),
      ),
    );
  }

  Widget buttonView(){
    return GetBuilder<RestaurantRegistrationController>(builder: (restaurantRegiController){
      return Column(
        children: [
          CustomButtonWidget(
            radius: Dimensions.radiusSmall,
            isBold: ResponsiveHelper.isDesktop(context) ? false : true,
            fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeSmall : Dimensions.fontSizeLarge,
            isLoading: restaurantRegiController.isLoading,
            margin: EdgeInsets.all((ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? 0 : Dimensions.paddingSizeSmall),
            buttonText: restaurantRegiController.storeStatus == 0.1 && !ResponsiveHelper.isDesktop(context) ? 'next'.tr : 'submit'.tr,
            onPressed: (restaurantRegiController.storeStatus == 0.1 && !ResponsiveHelper.isDesktop(context) && !restaurantRegiController.inZone)
                || (ResponsiveHelper.isDesktop(context) && !restaurantRegiController.inZone) ? null : () {
              bool defaultNameNull = false;
              bool defaultAddressNull = false;
              bool customFieldEmpty = false;
              for(int index=0; index<_languageList!.length; index++) {
                if(_languageList[index].key == 'en') {
                  if (_nameController[index].text.trim().isEmpty) {
                    defaultNameNull = true;
                  }
                  if(_addressController[index].text.trim().isEmpty){
                    defaultAddressNull = true;
                  }
                  break;
                }
              }

              Map<String, dynamic> additionalData = {};
              List<FilePickerResult> additionalDocuments = [];
              List<String> additionalDocumentsInputType = [];

              if(restaurantRegiController.storeStatus != 0.1 || ResponsiveHelper.isDesktop(context)){
                for (DataModel data in restaurantRegiController.dataList!) {
                  bool isTextField = data.fieldType == 'text' || data.fieldType == 'number' || data.fieldType == 'email' || data.fieldType == 'phone';
                  bool isDate = data.fieldType == 'date';
                  bool isCheckBox = data.fieldType == 'check_box';
                  bool isFile = data.fieldType == 'file';
                  int index = restaurantRegiController.dataList!.indexOf(data);
                  bool isRequired = data.isRequired == 1;

                  if(isTextField) {
                    if (kDebugMode) {
                      print('=====check text field : ${restaurantRegiController.additionalList![index].text == ''}');
                    }
                    if(restaurantRegiController.additionalList![index].text != '') {
                      additionalData.addAll({data.inputData! : restaurantRegiController.additionalList![index].text});
                    } else {
                      if(isRequired) {
                        customFieldEmpty = true;
                        showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
                        break;
                      }
                    }
                  } else if(isDate) {
                    if (kDebugMode) {
                      print('---check date : ${restaurantRegiController.additionalList![index]}');
                    }
                    if(restaurantRegiController.additionalList![index] != null) {
                      additionalData.addAll({data.inputData! : restaurantRegiController.additionalList![index]});
                    } else {
                      if(isRequired) {
                        customFieldEmpty = true;
                        showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
                        break;
                      }
                    }
                  } else if(isCheckBox) {
                    List<String> checkData = [];
                    bool noNeedToGoElse = false;
                    for(var e in restaurantRegiController.additionalList![index]) {
                      if(e != 0) {
                        checkData.add(e);
                        customFieldEmpty = false;
                        noNeedToGoElse = true;
                      } else if(!noNeedToGoElse && isRequired) {
                        customFieldEmpty = true;
                      }
                    }
                    if(customFieldEmpty && isRequired) {
                      showCustomSnackBar( '${'please_set_data_in'.tr} ${restaurantRegiController.dataList![index].inputData!.replaceAll('_', ' ')} ${'field'.tr}');
                      break;
                    } else {
                      additionalData.addAll({data.inputData! : checkData});
                    }

                  } else if(isFile) {
                    if (kDebugMode) {
                      print('---check file : ${restaurantRegiController.additionalList![index]}');
                    }
                    if(restaurantRegiController.additionalList![index].length == 0 && isRequired) {
                      customFieldEmpty = true;
                      showCustomSnackBar('${'please_add'.tr} ${restaurantRegiController.dataList![index].inputData!.replaceAll('_', ' ')}');
                      break;
                    } else {
                      restaurantRegiController.additionalList![index].forEach((file) {
                        additionalDocuments.add(file);
                        additionalDocumentsInputType.add(restaurantRegiController.dataList![index].inputData!);
                      });

                    }
                  }

                }
              }

              String vat = _vatController.text.trim();
              String minTime = restaurantRegiController.storeMinTime;
              String maxTime = restaurantRegiController.storeMaxTime;
              String fName = _fNameController.text.trim();
              String lName = _lNameController.text.trim();
              String phone = _phoneController.text.trim();
              String email = _emailController.text.trim();
              String password = _passwordController.text.trim();
              String confirmPassword = _confirmPasswordController.text.trim();
              String phoneWithCountryCode = _countryDialCode != null ? _countryDialCode! + phone : phone;
              bool valid = false;
              try {
                double.parse(maxTime);
                double.parse(minTime);
                valid = true;
              } on FormatException {
                valid = false;
              }

              if(restaurantRegiController.storeStatus == 0.1 || restaurantRegiController.storeStatus == 0.6) {
                if(restaurantRegiController.storeStatus == 0.1 && !ResponsiveHelper.isDesktop(context)){
                  if(_formKeyLogin!.currentState!.validate()){
                    if(defaultNameNull) {
                      showCustomSnackBar('enter_restaurant_name'.tr);
                    }else if(restaurantRegiController.pickedLogo == null){
                      showCustomSnackBar('select_restaurant_logo'.tr);
                    }else if(restaurantRegiController.pickedCover == null) {
                      showCustomSnackBar('select_restaurant_cover_photo'.tr);
                    }else if(defaultAddressNull) {
                      showCustomSnackBar('enter_restaurant_address'.tr);
                    }else if(restaurantRegiController.selectedZoneIndex == -1) {
                      showCustomSnackBar('please_select_zone_for_the_restaurant'.tr);
                    }else if(vat.isEmpty) {
                      showCustomSnackBar('enter_vat_amount'.tr);
                    }else if(minTime.isEmpty) {
                      showCustomSnackBar('enter_minimum_delivery_time'.tr);
                    }else if(maxTime.isEmpty) {
                      showCustomSnackBar('enter_maximum_delivery_time'.tr);
                    }else if(!valid) {
                      showCustomSnackBar('please_enter_the_max_min_delivery_time'.tr);
                    }else if(valid && double.parse(minTime) > double.parse(maxTime)) {
                      showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
                    }else if(restaurantRegiController.restaurantLocation == null) {
                      showCustomSnackBar('set_store_location'.tr);
                    }else{
                      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                      restaurantRegiController.storeStatusChange(0.6);
                      firstTime = true;
                    }
                  }
                }else{
                  if(ResponsiveHelper.isDesktop(context)){
                    if(defaultNameNull) {
                      showCustomSnackBar('enter_restaurant_name'.tr);
                    }else if(restaurantRegiController.pickedLogo == null){
                      showCustomSnackBar('select_restaurant_logo'.tr);
                    }else if(restaurantRegiController.pickedCover == null) {
                      showCustomSnackBar('select_restaurant_cover_photo'.tr);
                    }else if(defaultAddressNull) {
                      showCustomSnackBar('enter_restaurant_address'.tr);
                    }else if(restaurantRegiController.selectedZoneIndex == -1) {
                      showCustomSnackBar('please_select_zone_for_the_restaurant'.tr);
                    }else if(vat.isEmpty) {
                      showCustomSnackBar('enter_vat_amount'.tr);
                    }else if(minTime.isEmpty) {
                      showCustomSnackBar('enter_minimum_delivery_time'.tr);
                    }else if(maxTime.isEmpty) {
                      showCustomSnackBar('enter_maximum_delivery_time'.tr);
                    }else if(!valid) {
                      showCustomSnackBar('please_enter_the_max_min_delivery_time'.tr);
                    }else if(valid && double.parse(minTime) > double.parse(maxTime)) {
                      showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
                    }else if(restaurantRegiController.restaurantLocation == null) {
                      showCustomSnackBar('set_store_location'.tr);
                    }else if(fName.isEmpty) {
                      showCustomSnackBar('enter_your_first_name'.tr);
                    }else if(lName.isEmpty) {
                      showCustomSnackBar('enter_your_last_name'.tr);
                    }else if(phone.isEmpty) {
                      showCustomSnackBar('enter_phone_number'.tr);
                    }else if(email.isEmpty) {
                      showCustomSnackBar('enter_email_address'.tr);
                    }else if(!GetUtils.isEmail(email)) {
                      showCustomSnackBar('enter_a_valid_email_address'.tr);
                    }else if(password.isEmpty) {
                      showCustomSnackBar('enter_password'.tr);
                    }else if(password.length < 6) {
                      showCustomSnackBar('password_should_be'.tr);
                    }else if(password != confirmPassword) {
                      showCustomSnackBar('confirm_password_does_not_matched'.tr);
                    }else if(customFieldEmpty) {
                      if (kDebugMode) {
                        print('not provide addition data');
                      }
                    }else{
                      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                      restaurantRegiController.storeStatusChange(0.9);
                    }
                  }
                  if((restaurantRegiController.storeStatus == 0.6 && _formKeySecond!.currentState!.validate() && !ResponsiveHelper.isDesktop(context))){
                    if(fName.isEmpty) {
                      showCustomSnackBar('enter_your_first_name'.tr);
                    }else if(lName.isEmpty) {
                      showCustomSnackBar('enter_your_last_name'.tr);
                    }else if(phone.isEmpty) {
                      showCustomSnackBar('enter_phone_number'.tr);
                    }else if(email.isEmpty) {
                      showCustomSnackBar('enter_email_address'.tr);
                    }else if(!GetUtils.isEmail(email)) {
                      showCustomSnackBar('enter_a_valid_email_address'.tr);
                    }else if(password.isEmpty) {
                      showCustomSnackBar('enter_password'.tr);
                    }else if(password.length < 6) {
                      showCustomSnackBar('password_should_be'.tr);
                    }else if(password != confirmPassword) {
                      showCustomSnackBar('confirm_password_does_not_matched'.tr);
                    }else if(customFieldEmpty) {
                      if (kDebugMode) {
                        print('not provide addition data');
                      }
                    }else {
                      restaurantRegiController.storeStatusChange(0.9);
                    }
                  }
                }
              }else {
                List<TranslationBodyModel> translation = [];
                for(int index=0; index<_languageList.length; index++) {
                  translation.add(TranslationBodyModel(
                    locale: _languageList[index].key, key: 'name',
                    value: _nameController[index].text.trim().isNotEmpty ? _nameController[index].text.trim()
                        : _nameController[0].text.trim(),
                  ));
                  translation.add(TranslationBodyModel(
                    locale: _languageList[index].key, key: 'address',
                    value: _addressController[index].text.trim().isNotEmpty ? _addressController[index].text.trim()
                        : _addressController[0].text.trim(),
                  ));
                }

                List<String> cuisines = [];
                for (var index in Get.find<CuisineController>().selectedCuisines!) {
                  cuisines.add(Get.find<CuisineController>().cuisineModel!.cuisines![index].id.toString());
                }

                Map<String, String> data = {};

                data.addAll(RestaurantBodyModel(
                  deliveryTimeType: restaurantRegiController.storeTimeUnit,
                  translation: jsonEncode(translation), vat: vat, minDeliveryTime: minTime,
                  maxDeliveryTime: maxTime, lat: restaurantRegiController.restaurantLocation!.latitude.toString(), email: email,
                  lng: restaurantRegiController.restaurantLocation!.longitude.toString(), fName: fName, lName: lName, phone: phoneWithCountryCode,
                  password: password, zoneId: restaurantRegiController.zoneList![restaurantRegiController.selectedZoneIndex!].id.toString(),
                  cuisineId: cuisines,
                  businessPlan: restaurantRegiController.businessIndex == 0 ? 'commission' : 'subscription',
                  packageId: restaurantRegiController.businessIndex == 0 ? '' : restaurantRegiController.packageModel!.packages![restaurantRegiController.activeSubscriptionIndex].id!.toString(),
                ).toJson());

                data.addAll({
                  'additional_data': jsonEncode(additionalData),
                });

                restaurantRegiController.registerRestaurant(data, additionalDocuments, additionalDocumentsInputType).then((value) {
                  if (!validateStep01()) {
                    restaurantRegiController.storeStatusChange(0.1);
                    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                    return;
                  }

                  if (!validateStep06()) {
                    restaurantRegiController.storeStatusChange(0.6);
                    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                    return;
                  }
                },);
              }

            },
          ),
        ],
      );
    });
  }

  bool validateStep01(){
    if (ApiChecker.errors['name'] != null){
      return false;
    }
    if (ApiChecker.errors['vat'] != null){
      return false;
    }
    if (ApiChecker.errors['logo'] != null){
      return false;
    }
    if (ApiChecker.errors['cover_photo'] != null){
      return false;
    }
    return true;
  }
  bool validateStep06(){
    if (ApiChecker.errors['email'] != null){
      return false;
    }if (ApiChecker.errors['fName'] != null){
      return false;
    }
    if (ApiChecker.errors['lName'] != null){
      return false;
    }

    if(ApiChecker.errors['phone'] != null){
      return false;
    }
    if(ApiChecker.errors['password'] != null){
      return false;
    }
    if(ApiChecker.errors['confirm_password'] != null){
      return false;
    }
    return true;
  }
}
