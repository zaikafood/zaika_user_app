class ConfigModel {
  String? businessName;
  String? logoFullUrl;
  String? address;
  String? phone;
  String? email;
  String? currencySymbol;
  bool? cashOnDelivery;
  bool? digitalPayment;
  String? termsAndConditions;
  String? privacyPolicy;
  String? aboutUs;
  String? country;
  DefaultLocation? defaultLocation;
  String? appUrlAndroid;
  String? appUrlIos;
  bool? customerVerification;
  bool? orderDeliveryVerification;
  String? currencySymbolDirection;
  double? appMinimumVersionAndroid;
  double? appMinimumVersionIos;
  double? freeDeliveryOver;
  bool? demo;
  bool? maintenanceMode;
  int? popularFood;
  int? popularRestaurant;
  int? mostReviewedFoods;
  int? newRestaurant;
  String? orderConfirmationModel;
  bool? showDmEarning;
  bool? canceledByDeliveryman;
  bool? canceledByRestaurant;
  String? timeformat;
  bool? toggleVegNonVeg;
  bool? toggleDmRegistration;
  bool? toggleRestaurantRegistration;
  List<SocialLogin>? socialLogin;
  List<SocialLogin>? appleLogin;
  int? scheduleOrderSlotDuration;
  int? digitAfterDecimalPoint;
  int? loyaltyPointExchangeRate;
  double? loyaltyPointItemPurchasePoint;
  int? loyaltyPointStatus;
  int? minimumPointToTransfer;
  int? customerWalletStatus;
  int? dmTipsStatus;
  int? refEarningStatus;
  double? refEarningExchangeRate;
  int? theme;
  BusinessPlan? businessPlan;
  double? adminCommission;
  bool? refundStatus;
  int? refundPolicyStatus;
  String? refundPolicyData;
  int? cancellationPolicyStatus;
  String? cancellationPolicyData;
  int? shippingPolicyStatus;
  String? shippingPolicyData;
  int? freeTrialPeriodStatus;
  int? freeTrialPeriodDay;
  int? taxIncluded;
  String? cookiesText;
  List<Language>? language;
  bool? takeAway;
  bool? homeDelivery;
  bool? dineIn;
  bool? repeatOrderOption;
  List<SocialMedia>? socialMedia;
  String? footerText;
  LandingPageLinks? landingPageLinks;
  List<PaymentBody>? activePaymentMethodList;
  DigitalPaymentInfo? digitalPaymentInfo;
  bool? addFundStatus;
  bool? partialPaymentStatus;
  String? partialPaymentMethod;
  bool? additionalChargeStatus;
  String? additionalChargeName;
  double? additionCharge;
  BannerData? bannerData;
  bool? offlinePaymentStatus;
  bool? freeDeliveryDistanceStatus;
  double? freeDeliveryDistance;
  bool? instantOrder;
  bool? customerDateOrderStatus;
  int? customerOrderDate;
  RestaurantAdditionalJoinUsPageData? restaurantAdditionalJoinUsPageData;
  DeliverymanAdditionalJoinUsPageData? deliverymanAdditionalJoinUsPageData;
  bool? guestCheckoutStatus;
  String? favIconFullUrl;
  bool? extraPackagingChargeStatus;
  bool? countryPickerStatus;
  MaintenanceModeData? maintenanceModeData;
  CentralizeLoginSetup? centralizeLoginSetup;
  bool? firebaseOtpVerification;
  int? subscriptionFreeTrialDays;
  bool? subscriptionFreeTrialStatus;
  int? subscriptionBusinessModel;
  int? commissionBusinessModel;
  String? subscriptionFreeTrialType;
  bool? dineInOrderOption;

  ConfigModel({
    this.businessName,
    this.logoFullUrl,
    this.address,
    this.phone,
    this.email,
    this.currencySymbol,
    this.cashOnDelivery,
    this.digitalPayment,
    this.termsAndConditions,
    this.privacyPolicy,
    this.aboutUs,
    this.country,
    this.defaultLocation,
    this.appUrlAndroid,
    this.appUrlIos,
    this.customerVerification,
    this.orderDeliveryVerification,
    this.currencySymbolDirection,
    this.appMinimumVersionAndroid,
    this.appMinimumVersionIos,
    this.freeDeliveryOver,
    this.demo,
    this.maintenanceMode,
    this.popularFood,
    this.popularRestaurant,
    this.mostReviewedFoods,
    this.newRestaurant,
    this.orderConfirmationModel,
    this.showDmEarning,
    this.canceledByDeliveryman,
    this.canceledByRestaurant,
    this.timeformat,
    this.toggleVegNonVeg,
    this.toggleDmRegistration,
    this.toggleRestaurantRegistration,
    this.socialLogin,
    this.appleLogin,
    this.scheduleOrderSlotDuration,
    this.digitAfterDecimalPoint,
    this.loyaltyPointExchangeRate,
    this.loyaltyPointItemPurchasePoint,
    this.loyaltyPointStatus,
    this.minimumPointToTransfer,
    this.customerWalletStatus,
    this.dmTipsStatus,
    this.refEarningStatus,
    this.refEarningExchangeRate,
    this.theme,
    this.businessPlan,
    this.adminCommission,
    this.refundStatus,
    this.refundPolicyStatus,
    this.refundPolicyData,
    this.cancellationPolicyStatus,
    this.cancellationPolicyData,
    this.shippingPolicyStatus,
    this.shippingPolicyData,
    this.freeTrialPeriodStatus,
    this.freeTrialPeriodDay,
    this.taxIncluded,
    this.cookiesText,
    this.language,
    this.takeAway,
    this.homeDelivery,
    this.dineIn,
    this.repeatOrderOption,
    this.socialMedia,
    this.footerText,
    this.landingPageLinks,
    this.activePaymentMethodList,
    this.digitalPaymentInfo,
    this.addFundStatus,
    this.partialPaymentStatus,
    this.partialPaymentMethod,
    this.additionalChargeStatus,
    this.additionalChargeName,
    this.additionCharge,
    this.bannerData,
    this.offlinePaymentStatus,
    this.freeDeliveryDistanceStatus,
    this.freeDeliveryDistance,
    this.instantOrder,
    this.customerDateOrderStatus,
    this.customerOrderDate,
    this.restaurantAdditionalJoinUsPageData,
    this.deliverymanAdditionalJoinUsPageData,
    this.guestCheckoutStatus,
    this.favIconFullUrl,
    this.extraPackagingChargeStatus,
    this.countryPickerStatus,
    this.maintenanceModeData,
    this.centralizeLoginSetup,
    this.firebaseOtpVerification,
    this.subscriptionFreeTrialDays,
    this.subscriptionFreeTrialStatus,
    this.subscriptionBusinessModel,
    this.commissionBusinessModel,
    this.subscriptionFreeTrialType,
    this.dineInOrderOption,
  });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    logoFullUrl = json['logo_full_url'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    currencySymbol = json['currency_symbol'];
    cashOnDelivery = json['cash_on_delivery'];
    digitalPayment = json['digital_payment'];
    termsAndConditions = json['terms_and_conditions'];
    privacyPolicy = json['privacy_policy'];
    aboutUs = json['about_us'];
    country = json['country'];
    defaultLocation = json['default_location'] != null ? DefaultLocation.fromJson(json['default_location']) : null;
    appUrlAndroid = json['app_url_android'];
    appUrlIos = json['app_url_ios'];
    customerVerification = json['customer_verification'];
    orderDeliveryVerification = json['order_delivery_verification'];
    currencySymbolDirection = json['currency_symbol_direction'];
    appMinimumVersionAndroid = json['app_minimum_version_android'] != null ? json['app_minimum_version_android'].toDouble() : 0.0;
    appMinimumVersionIos = json['app_minimum_version_ios'] != null ? json['app_minimum_version_ios'].toDouble() : 0.0;
    freeDeliveryOver = json['free_delivery_over'] != null ? double.parse(json['free_delivery_over'].toString()) : null;
    demo = json['demo'];
    maintenanceMode = json['maintenance_mode'];
    popularFood = json['popular_food'];
    popularRestaurant = json['popular_restaurant'];
    newRestaurant = json['new_restaurant'];
    mostReviewedFoods = json['most_reviewed_foods'];
    orderConfirmationModel = json['order_confirmation_model'];
    showDmEarning = json['show_dm_earning'];
    canceledByDeliveryman = json['canceled_by_deliveryman'];
    canceledByRestaurant = json['canceled_by_restaurant'];
    timeformat = json['timeformat'];
    toggleVegNonVeg = json['toggle_veg_non_veg'];
    toggleDmRegistration = json['toggle_dm_registration'];
    toggleRestaurantRegistration = json['toggle_restaurant_registration'];
    if (json['social_login'] != null) {
      socialLogin = <SocialLogin>[];
      json['social_login'].forEach((v) {
        socialLogin!.add(SocialLogin.fromJson(v));
      });
    }
    if (json['apple_login'] != null) {
      appleLogin = <SocialLogin>[];
      json['apple_login'].forEach((v) {
        appleLogin!.add(SocialLogin.fromJson(v));
      });
    }
    scheduleOrderSlotDuration = json['schedule_order_slot_duration'] == 0 ? 30 : json['schedule_order_slot_duration'];
    digitAfterDecimalPoint = json['digit_after_decimal_point'];
    loyaltyPointExchangeRate = json['loyalty_point_exchange_rate'];
    loyaltyPointItemPurchasePoint = json['loyalty_point_item_purchase_point'].toDouble();
    loyaltyPointStatus = json['loyalty_point_status'];
    minimumPointToTransfer = json['minimum_point_to_transfer'];
    customerWalletStatus = json['customer_wallet_status'];
    dmTipsStatus = json['dm_tips_status'];
    refEarningStatus = json['ref_earning_status'];
    refEarningExchangeRate = json['ref_earning_exchange_rate'].toDouble();
    theme = json['theme'];
    businessPlan = json['business_plan'] != null ? BusinessPlan.fromJson(json['business_plan']) : null;
    adminCommission = json['admin_commission'].toDouble();
    refundStatus = json['refund_active_status'];
    refundPolicyStatus = json['refund_policy_status'];
    refundPolicyData = json['refund_policy_data'];
    cancellationPolicyStatus = json['cancellation_policy_status'];
    cancellationPolicyData = json['cancellation_policy_data'];
    shippingPolicyStatus = json['shipping_policy_status'];
    shippingPolicyData = json['shipping_policy_data'];
    freeTrialPeriodStatus = json['free_trial_period_status'];
    freeTrialPeriodDay = json['free_trial_period_data'];
    taxIncluded = json['tax_included'];
    cookiesText = json['cookies_text'];
    if (json['language'] != null) {
      language = [];
      json['language'].forEach((v) {
        language!.add(Language.fromJson(v));
      });
    }
    takeAway = json['take_away'];
    homeDelivery = json['home_delivery'];
    dineIn = json['dine_in_order_option'] == 1;
    repeatOrderOption = json['repeat_order_option'];
    if (json['social_media'] != null) {
      socialMedia = <SocialMedia>[];
      json['social_media'].forEach((v) {
        socialMedia!.add(SocialMedia.fromJson(v));
      });
    }
    footerText = json['footer_text'];
    landingPageLinks = json['landing_page_links'] != null ? LandingPageLinks.fromJson(json['landing_page_links']) : null;
    if (json['active_payment_method_list'] != null) {
      activePaymentMethodList = <PaymentBody>[];
      json['active_payment_method_list'].forEach((v) {
        activePaymentMethodList!.add(PaymentBody.fromJson(v));
      });
    }
    digitalPaymentInfo = json['digital_payment_info'] != null ? DigitalPaymentInfo.fromJson(json['digital_payment_info']) : null;
    addFundStatus = json['add_fund_status'] == 1;
    partialPaymentStatus = json['partial_payment_status'] == 1;
    partialPaymentMethod = json['partial_payment_method'];
    additionalChargeStatus = json['additional_charge_status'] == 1;
    additionalChargeName = json['additional_charge_name'];
    additionCharge = json['additional_charge']?.toDouble() ?? 0;
    bannerData = json['banner_data'] != null && json['banner_data'] != 'null' ? BannerData.fromJson(json['banner_data']) : null;
    offlinePaymentStatus = json['offline_payment_status'] == 1;
    freeDeliveryDistanceStatus = json['free_delivery_distance_status'];
    freeDeliveryDistance = json['free_delivery_distance'] != null ? double.parse(json['free_delivery_distance'].toString()) : null;
    instantOrder = json['instant_order'];
    customerDateOrderStatus = json['customer_date_order_sratus'];
    customerOrderDate = json['customer_order_date'];
    restaurantAdditionalJoinUsPageData = json['restaurant_additional_join_us_page_data'] != null ? RestaurantAdditionalJoinUsPageData.fromJson(json['restaurant_additional_join_us_page_data']) : null;
    deliverymanAdditionalJoinUsPageData = json['deliveryman_additional_join_us_page_data'] != null ? DeliverymanAdditionalJoinUsPageData.fromJson(json['deliveryman_additional_join_us_page_data']) : null;
    guestCheckoutStatus = json['guest_checkout_status'] == 1;
    favIconFullUrl = json['fav_icon_full_url'];
    extraPackagingChargeStatus = json['extra_packaging_charge'];
    countryPickerStatus = json['country_picker_status'] == 1;
    maintenanceModeData = json['maintenance_mode_data'] != null ? MaintenanceModeData.fromJson(json['maintenance_mode_data']) : null;
    centralizeLoginSetup = json['centralize_login'] != null ? CentralizeLoginSetup.fromJson(json['centralize_login']) : null;
    firebaseOtpVerification = json['firebase_otp_verification'] == 1;
    subscriptionFreeTrialDays = json['subscription_free_trial_days'];
    subscriptionFreeTrialStatus = json['subscription_free_trial_status'] == 1 ? true : false;
    subscriptionBusinessModel = json['subscription_business_model'];
    commissionBusinessModel = json['commission_business_model'];
    subscriptionFreeTrialType = json['subscription_free_trial_type'];
    dineInOrderOption = json['dine_in_order_option'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_name'] = businessName;
    data['logo_full_url'] = logoFullUrl;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['currency_symbol'] = currencySymbol;
    data['cash_on_delivery'] = cashOnDelivery;
    data['digital_payment'] = digitalPayment;
    data['terms_and_conditions'] = termsAndConditions;
    data['privacy_policy'] = privacyPolicy;
    data['about_us'] = aboutUs;
    data['country'] = country;
    if (defaultLocation != null) {
      data['default_location'] = defaultLocation!.toJson();
    }
    data['app_url_android'] = appUrlAndroid;
    data['app_url_ios'] = appUrlIos;
    data['customer_verification'] = customerVerification;
    data['order_delivery_verification'] = orderDeliveryVerification;
    data['currency_symbol_direction'] = currencySymbolDirection;
    data['app_minimum_version_android'] = appMinimumVersionAndroid;
    data['app_minimum_version_ios'] = appMinimumVersionIos;
    data['free_delivery_over'] = freeDeliveryOver;
    data['demo'] = demo;
    data['maintenance_mode'] = maintenanceMode;
    data['popular_food'] = popularFood;
    data['popular_restaurant'] = popularRestaurant;
    data['new_restaurant'] = newRestaurant;
    data['most_reviewed_foods'] = mostReviewedFoods;
    data['order_confirmation_model'] = orderConfirmationModel;
    data['show_dm_earning'] = showDmEarning;
    data['canceled_by_deliveryman'] = canceledByDeliveryman;
    data['canceled_by_restaurant'] = canceledByRestaurant;
    data['timeformat'] = timeformat;
    data['toggle_veg_non_veg'] = toggleVegNonVeg;
    data['toggle_dm_registration'] = toggleDmRegistration;
    data['toggle_restaurant_registration'] = toggleRestaurantRegistration;
    if (socialLogin != null) {
      data['social_login'] = socialLogin!.map((v) => v.toJson()).toList();
    }
    if (appleLogin != null) {
      data['apple_login'] = appleLogin!.map((v) => v.toJson()).toList();
    }
    data['schedule_order_slot_duration'] = scheduleOrderSlotDuration;
    data['digit_after_decimal_point'] = digitAfterDecimalPoint;
    data['loyalty_point_exchange_rate'] = loyaltyPointExchangeRate;
    data['loyalty_point_item_purchase_point'] = loyaltyPointItemPurchasePoint;
    data['loyalty_point_status'] = loyaltyPointStatus;
    data['minimum_point_to_transfer'] = minimumPointToTransfer;
    data['customer_wallet_status'] = customerWalletStatus;
    data['dm_tips_status'] = dmTipsStatus;
    data['ref_earning_status'] = refEarningStatus;
    data['ref_earning_exchange_rate'] = refEarningExchangeRate;
    data['theme'] = theme;
    data['refund_active_status'] = refundStatus;
    data['tax_included'] = taxIncluded;
    data['cookies_text'] = cookiesText;
    if (language != null) {
      data['language'] = language!.map((v) => v.toJson()).toList();
    }
    data['take_away'] = takeAway;
    data['home_delivery'] = homeDelivery;
    data['dine_in_order_option'] = dineIn;
    data['repeat_order_option'] = repeatOrderOption;
    if (socialMedia != null) {
      data['social_media'] = socialMedia!.map((v) => v.toJson()).toList();
    }
    data['footer_text'] = footerText;
    if (landingPageLinks != null) {
      data['landing_page_links'] = landingPageLinks!.toJson();
    }
    if (activePaymentMethodList != null) {
      data['active_payment_method_list'] = activePaymentMethodList!.map((v) => v.toJson()).toList();
    }
    if (digitalPaymentInfo != null) {
      data['digital_payment_info'] = digitalPaymentInfo!.toJson();
    }
    data['add_fund_status'] = addFundStatus;
    data['partial_payment_status'] = partialPaymentStatus;
    data['partial_payment_method'] = partialPaymentMethod;
    data['additional_charge_status'] = additionalChargeStatus;
    data['additional_charge_name'] = additionalChargeName;
    data['additional_charge'] = additionCharge;
    data['offline_payment_status'] = offlinePaymentStatus;
    data['free_delivery_distance'] = freeDeliveryDistance;
    data['instant_order'] = instantOrder;
    data['customer_date_order_sratus'] = customerDateOrderStatus;
    data['customer_order_date'] = customerOrderDate;
    if (restaurantAdditionalJoinUsPageData != null) {
      data['restaurant_additional_join_us_page_data'] = restaurantAdditionalJoinUsPageData!.toJson();
    }
    if (deliverymanAdditionalJoinUsPageData != null) {
      data['deliveryman_additional_join_us_page_data'] = deliverymanAdditionalJoinUsPageData!.toJson();
    }
    data['guest_checkout_status'] = guestCheckoutStatus;
    data['fav_icon_full_url'] = favIconFullUrl;
    data['extra_packaging_charge'] = extraPackagingChargeStatus;
    data['country_picker_status'] = countryPickerStatus;
    if (maintenanceModeData != null) {
      data['maintenance_mode_data'] = maintenanceModeData!.toJson();
    }
    data['centralizeLoginSetup'] = centralizeLoginSetup!.toJson();
    data['firebase_otp_verification'] = firebaseOtpVerification;
    data['subscription_free_trial_days'] = subscriptionFreeTrialDays;
    data['subscription_free_trial_status'] = subscriptionFreeTrialStatus;
    data['subscription_business_model'] = subscriptionBusinessModel;
    data['commission_business_model'] = commissionBusinessModel;
    data['subscription_free_trial_type'] = subscriptionFreeTrialType;
    return data;
  }
}

class DefaultLocation {
  String? lat = "19.9909631";
  String? lng = "73.8034808";

  DefaultLocation({this.lat, this.lng});

  DefaultLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Language {
  String? key;
  String? value;

  Language({this.key, this.value});

  Language.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}

class SocialLogin {
  String? loginMedium;
  bool? status;
  String? clientId;

  SocialLogin({this.loginMedium, this.status, this.clientId});

  SocialLogin.fromJson(Map<String, dynamic> json) {
    loginMedium = json['login_medium'];
    status = json['status'];
    clientId = json['client_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login_medium'] = loginMedium;
    data['status'] = status;
    data['client_id'] = clientId;
    return data;
  }
}

class BusinessPlan {
  int? commission;
  int? subscription;

  BusinessPlan({this.commission, this.subscription});

  BusinessPlan.fromJson(Map<String, dynamic> json) {
    commission = json['commission'];
    subscription = json['subscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commission'] = commission;
    data['subscription'] = subscription;
    return data;
  }
}

class SocialMedia {
  int? id;
  String? name;
  String? link;
  int? status;

  SocialMedia({
    this.id,
    this.name,
    this.link,
    this.status,
  });

  SocialMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    link = json['link'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['link'] = link;
    data['status'] = status;
    return data;
  }
}

class LandingPageLinks {
  String? appUrlAndroidStatus;
  String? appUrlAndroid;
  String? appUrlIosStatus;
  String? appUrlIos;

  LandingPageLinks({
    this.appUrlAndroidStatus,
    this.appUrlAndroid,
    this.appUrlIosStatus,
    this.appUrlIos,
  });

  LandingPageLinks.fromJson(Map<String, dynamic> json) {
    appUrlAndroidStatus = json['app_url_android_status'].toString();
    appUrlAndroid = json['app_url_android'];
    appUrlIosStatus = json['app_url_ios_status'].toString();
    appUrlIos = json['app_url_ios'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_url_android_status'] = appUrlAndroidStatus;
    data['app_url_android'] = appUrlAndroid;
    data['app_url_ios_status'] = appUrlIosStatus;
    data['app_url_ios'] = appUrlIos;
    return data;
  }
}

class PaymentBody {
  String? getWay;
  String? getWayTitle;
  String? getWayImageFullUrl;

  PaymentBody({this.getWay, this.getWayTitle, this.getWayImageFullUrl});

  PaymentBody.fromJson(Map<String, dynamic> json) {
    getWay = json['gateway'];
    getWayTitle = json['gateway_title'];
    getWayImageFullUrl = json['gateway_image_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gateway'] = getWay;
    data['gateway_title'] = getWayTitle;
    data['gateway_image_full_url'] = getWayImageFullUrl;
    return data;
  }
}

class DigitalPaymentInfo {
  bool? digitalPayment;
  bool? pluginPaymentGateways;
  bool? defaultPaymentGateways;

  DigitalPaymentInfo({this.digitalPayment, this.pluginPaymentGateways, this.defaultPaymentGateways});

  DigitalPaymentInfo.fromJson(Map<String, dynamic> json) {
    digitalPayment = json['digital_payment'];
    pluginPaymentGateways = json['plugin_payment_gateways'];
    defaultPaymentGateways = json['default_payment_gateways'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['digital_payment'] = digitalPayment;
    data['plugin_payment_gateways'] = pluginPaymentGateways;
    data['default_payment_gateways'] = defaultPaymentGateways;
    return data;
  }
}

class BannerData {
  String? promotionalBannerTitle;
  String? promotionalBannerImageFullUrl;

  BannerData({this.promotionalBannerTitle, this.promotionalBannerImageFullUrl});

  BannerData.fromJson(Map<String, dynamic> json) {
    promotionalBannerTitle = json['promotional_banner_title'];
    promotionalBannerImageFullUrl = json['promotional_banner_image_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotional_banner_title'] = promotionalBannerTitle;
    data['promotional_banner_image_full_url'] = promotionalBannerImageFullUrl;
    return data;
  }
}

class RestaurantAdditionalJoinUsPageData {
  List<DataModel>? data;

  RestaurantAdditionalJoinUsPageData({this.data});

  RestaurantAdditionalJoinUsPageData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataModel>[];
      json['data'].forEach((v) {
        data!.add(DataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliverymanAdditionalJoinUsPageData {
  List<DataModel>? data;

  DeliverymanAdditionalJoinUsPageData({this.data});

  DeliverymanAdditionalJoinUsPageData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataModel>[];
      json['data'].forEach((v) {
        data!.add(DataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataModel {
  String? fieldType;
  String? inputData;
  List<String>? checkData;
  MediaData? mediaData;
  String? placeholderData;
  int? isRequired;

  DataModel({this.fieldType, this.inputData, this.checkData, this.mediaData, this.placeholderData, this.isRequired});

  DataModel.fromJson(Map<String, dynamic> json) {
    fieldType = json['field_type'];
    inputData = json['input_data'];
    // checkData = json['check_data'].cast<String>();

    if (json['check_data'] != null) {
      checkData = [];
      json['check_data'].forEach((e) => checkData!.add(e));
    }
    mediaData = json['media_data'] != null ? MediaData.fromJson(json['media_data']) : null;
    placeholderData = json['placeholder_data'];
    isRequired = json['is_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field_type'] = fieldType;
    data['input_data'] = inputData;
    data['check_data'] = checkData;
    if (mediaData != null) {
      data['media_data'] = mediaData!.toJson();
    }
    data['placeholder_data'] = placeholderData;
    data['is_required'] = isRequired;
    return data;
  }
}

class MediaData {
  int? uploadMultipleFiles;
  int? image;
  int? pdf;
  int? docs;

  MediaData({
    this.uploadMultipleFiles,
    this.image,
    this.pdf,
    this.docs,
  });

  MediaData.fromJson(Map<String, dynamic> json) {
    uploadMultipleFiles = json['upload_multiple_files'];
    image = json['image'];
    pdf = json['pdf'];
    docs = json['docs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['upload_multiple_files'] = uploadMultipleFiles;
    data['image'] = image;
    data['pdf'] = pdf;
    data['docs'] = docs;
    return data;
  }
}

class MaintenanceModeData {
  List<String>? maintenanceSystemSetup;
  MaintenanceDurationSetup? maintenanceDurationSetup;
  MaintenanceMessageSetup? maintenanceMessageSetup;

  MaintenanceModeData({
    this.maintenanceSystemSetup,
    this.maintenanceDurationSetup,
    this.maintenanceMessageSetup,
  });

  MaintenanceModeData.fromJson(Map<String, dynamic> json) {
    maintenanceSystemSetup = json['maintenance_system_setup'].cast<String>();
    maintenanceDurationSetup = json['maintenance_duration_setup'] != null ? MaintenanceDurationSetup.fromJson(json['maintenance_duration_setup']) : null;
    maintenanceMessageSetup = json['maintenance_message_setup'] != null ? MaintenanceMessageSetup.fromJson(json['maintenance_message_setup']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_system_setup'] = maintenanceSystemSetup;
    if (maintenanceDurationSetup != null) {
      data['maintenance_duration_setup'] = maintenanceDurationSetup!.toJson();
    }
    if (maintenanceMessageSetup != null) {
      data['maintenance_message_setup'] = maintenanceMessageSetup!.toJson();
    }
    return data;
  }
}

class MaintenanceDurationSetup {
  String? maintenanceDuration;
  String? startDate;
  String? endDate;

  MaintenanceDurationSetup({
    this.maintenanceDuration,
    this.startDate,
    this.endDate,
  });

  MaintenanceDurationSetup.fromJson(Map<String, dynamic> json) {
    maintenanceDuration = json['maintenance_duration'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_duration'] = maintenanceDuration;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    return data;
  }
}

class MaintenanceMessageSetup {
  int? businessNumber;
  int? businessEmail;
  String? maintenanceMessage;
  String? messageBody;

  MaintenanceMessageSetup({this.businessNumber, this.businessEmail, this.maintenanceMessage, this.messageBody});

  MaintenanceMessageSetup.fromJson(Map<String, dynamic> json) {
    businessNumber = json['business_number'];
    businessEmail = json['business_email'];
    maintenanceMessage = json['maintenance_message'];
    messageBody = json['message_body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_number'] = businessNumber;
    data['business_email'] = businessEmail;
    data['maintenance_message'] = maintenanceMessage;
    data['message_body'] = messageBody;
    return data;
  }
}

class CentralizeLoginSetup {
  bool? manualLoginStatus;
  bool? otpLoginStatus;
  bool? socialLoginStatus;
  bool? googleLoginStatus;
  bool? facebookLoginStatus;
  bool? appleLoginStatus;
  bool? emailVerificationStatus;
  bool? phoneVerificationStatus;

  CentralizeLoginSetup({
    this.manualLoginStatus,
    this.otpLoginStatus,
    this.socialLoginStatus,
    this.googleLoginStatus,
    this.facebookLoginStatus,
    this.appleLoginStatus,
    this.emailVerificationStatus,
    this.phoneVerificationStatus,
  });

  CentralizeLoginSetup.fromJson(Map<String, dynamic> json) {
    manualLoginStatus = json['manual_login_status'] == 1;
    otpLoginStatus = json['otp_login_status'] == 1;
    socialLoginStatus = json['social_login_status'] == 1;
    googleLoginStatus = json['google_login_status'] == 1;
    facebookLoginStatus = json['facebook_login_status'] == 1;
    appleLoginStatus = json['apple_login_status'] == 1;
    emailVerificationStatus = json['email_verification_status'] == 1;
    phoneVerificationStatus = json['phone_verification_status'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['manual_login_status'] = manualLoginStatus;
    data['otp_login_status'] = otpLoginStatus;
    data['social_login_status'] = socialLoginStatus;
    data['google_login_status'] = googleLoginStatus;
    data['facebook_login_status'] = facebookLoginStatus;
    data['apple_login_status'] = appleLoginStatus;
    data['email_verification_status'] = emailVerificationStatus;
    data['phone_verification_status'] = phoneVerificationStatus;
    return data;
  }
}