import 'package:country_code_picker/country_code_picker.dart';
import 'package:get/get.dart';
import 'package:zaika/common/widgets/custom_asset_image_widget.dart';
import 'package:zaika/features/splash/controllers/splash_controller.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/styles.dart';
import 'package:zaika/common/widgets/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String titleText;
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final Function? onChanged;
  final Function? onSubmit;
  final bool isEnabled;
  final int maxLines;
  final TextCapitalization capitalization;
  final String? prefixImage;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double prefixSize;
  final TextAlign textAlign;
  final bool isAmount;
  final bool isNumber;
  final bool showTitle;
  final bool showBorder;
  final double iconSize;
  final bool divider;
  final bool isPhone;
  final String? countryDialCode;
  final Function(CountryCode countryCode)? onCountryChanged;
  final bool isRequired;
  final bool showLabelText;
  final bool required;
  final String? labelText;
  final String? Function(String?)? validator;
  final double? levelTextSize;
  final bool fromUpdateProfile;
  final bool fromDeliveryRegistration;
  final Widget? suffixChild;
  final String? suffixImage;
  final Function()? suffixOnPressed;
  final Function()? onTap;
  final String? errorText;

  const CustomTextFieldWidget({
    super.key,
    this.titleText = 'Write something...',
    this.hintText = '',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSubmit,
    this.onChanged,
    this.prefixImage,
    this.prefixIcon,
    this.capitalization = TextCapitalization.none,
    this.isPassword = false,
    this.prefixSize = Dimensions.paddingSizeSmall,
    this.textAlign = TextAlign.start,
    this.isAmount = false,
    this.isNumber = false,
    this.showTitle = false,
    this.showBorder = true,
    this.iconSize = 18,
    this.divider = false,
    this.isPhone = false,
    this.countryDialCode,
    this.onCountryChanged,
    this.isRequired = false,
    this.showLabelText = true,
    this.required = false,
    this.labelText,
    this.validator,
    this.suffixIcon,
    this.levelTextSize,
    this.fromUpdateProfile = false,
    this.fromDeliveryRegistration = false,
    this.suffixChild,
    this.suffixOnPressed,
    this.suffixImage,
    this.onTap,
    this.errorText,
  });

  @override
  CustomTextFieldWidgetState createState() => CustomTextFieldWidgetState();
}

class CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        widget.showTitle ? Text(widget.titleText, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)) : const SizedBox(),
        SizedBox(height: widget.showTitle ? ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraSmall : 0),

        InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(widget.focusNode);
          },
          child: TextFormField(
            maxLines: widget.maxLines,
            controller: widget.controller,
            focusNode: widget.focusNode,
            textAlign: widget.textAlign,
            validator: widget.validator,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
            textInputAction: widget.inputAction,
            keyboardType: widget.isAmount ? TextInputType.number : widget.inputType,
            cursorColor: Theme.of(context).primaryColor,
            textCapitalization: widget.capitalization,
            enabled: widget.isEnabled,
            autofocus: false,
            obscureText: widget.isPassword ? _obscureText : false,
            inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
                : widget.isAmount ? [FilteringTextInputFormatter.allow(RegExp(r'\d'))] : widget.isNumber ? [FilteringTextInputFormatter.allow(RegExp(r'\d'))] : null,
            decoration: InputDecoration(
              errorMaxLines: 2,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide(style: widget.showBorder ? BorderStyle.solid : BorderStyle.none, width: 0.3, color: Theme.of(context).disabledColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide(style: widget.showBorder ? BorderStyle.solid : BorderStyle.none, width: 1, color: Theme.of(context).primaryColor),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide(style: widget.showBorder ? BorderStyle.solid : BorderStyle.none, width: 0.3, color: Theme.of(context).primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide(style: widget.showBorder ? BorderStyle.solid : BorderStyle.none, color: Theme.of(context).colorScheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide(style: widget.showBorder ? BorderStyle.solid : BorderStyle.none, color: Theme.of(context).colorScheme.error),
              ),
              isDense: true,
              hintText: widget.hintText.isEmpty ? widget.titleText : widget.hintText,
              errorText: widget.errorText,
              fillColor: !widget.isEnabled ? Theme.of(context).disabledColor.withValues(alpha: 0.1) : Theme.of(context).cardColor,
              hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
              filled: true,
              labelStyle : widget.showLabelText ? robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).hintColor):null,
              errorStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              label: widget.showLabelText ? Text.rich(TextSpan(children: [
                TextSpan(
                  text: widget.labelText ?? '',
                  style: robotoRegular.copyWith(
                    fontSize: widget.levelTextSize ?? Dimensions.fontSizeLarge,
                    color: ((widget.focusNode?.hasFocus == true || widget.controller!.text.isNotEmpty ) &&  widget.isEnabled) ? Theme.of(context).textTheme.bodyLarge?.color :  Theme.of(context).hintColor.withValues(alpha: .75),
                  ),
                ),
                if(widget.required && widget.labelText != null)
                  TextSpan(text : ' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeLarge)),
                if(widget.isEnabled == false)
                  TextSpan(text: widget.fromUpdateProfile || widget.fromDeliveryRegistration ? '' : ' (${'non_changeable'.tr})', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).colorScheme.error)),
              ])) : null,
              prefixIcon: (widget.isPhone || widget.countryDialCode != null) ? SizedBox(width: 95, child: Row(children: [
                Container(
                  width: 85,height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radiusSmall),
                      bottomLeft: Radius.circular(Dimensions.radiusSmall),
                    ),
                  ),
                  margin: const EdgeInsets.only(right: 0),
                  padding: const EdgeInsets.only(left: 5),
                  child: Center(
                    child: CodePickerWidget(
                      flagWidth: 25,
                      padding: EdgeInsets.zero,
                      onChanged: widget.onCountryChanged,
                      initialSelection: widget.countryDialCode,
                      favorite: [widget.countryDialCode ?? ''],
                      countryFilter: [widget.countryDialCode!],
                      enabled: false,
                      // enabled: Get.find<SplashController>().configModel?.countryPickerStatus,
                      dialogBackgroundColor: Theme.of(context).cardColor,
                      textStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    // child: Row(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Image.network("https://flagcdn.com/w40/in.png",width: 25,fit: BoxFit.cover,),
                    //     ),
                    //     Text("+91 "),
                    //   ],
                    // )
                  ),
                ),

                Container(
                  height: 20, width: 2,
                  color: Theme.of(context).disabledColor,
                )
              ]),
              ) : widget.prefixImage != null && widget.prefixIcon == null ? Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.prefixSize),
                child: CustomAssetImageWidget(widget.prefixImage!, height: 25, width: 25, fit: BoxFit.scaleDown, color: widget.focusNode?.hasFocus == true ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).hintColor.withValues(alpha: 0.7)),
              ) : widget.prefixImage == null && widget.prefixIcon != null ? Icon(widget.prefixIcon, size: widget.iconSize, color: widget.focusNode?.hasFocus == true ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).hintColor.withValues(alpha: 0.7)) : null,
              suffixIcon: widget.isPassword ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
                onPressed: _toggle,
              ) : widget.suffixImage != null ? InkWell(
                onTap: widget.suffixOnPressed, child: Padding(
                  padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeDefault),
                  child: Image.asset(widget.suffixImage!, height: 10, width: 10, fit: BoxFit.cover,),
                ),
              ) : widget.suffixChild,
            ),
            onFieldSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus)
                : widget.onSubmit != null ? widget.onSubmit!(text) : null,
            onChanged: widget.onChanged as void Function(String)?,
            onTap: widget.onTap,
          ),
        ),

        widget.divider ? const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge), child: Divider()) : const SizedBox(),

      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}

