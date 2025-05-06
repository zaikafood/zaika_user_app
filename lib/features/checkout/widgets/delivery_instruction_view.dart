import 'package:zaika/features/checkout/controllers/checkout_controller.dart';
import 'package:zaika/features/checkout/widgets/delivery_instruction_bottom_sheet.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/util/app_constants.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryInstructionView extends StatefulWidget {
  const DeliveryInstructionView({super.key});

  @override
  State<DeliveryInstructionView> createState() => _DeliveryInstructionViewState();
}

class _DeliveryInstructionViewState extends State<DeliveryInstructionView> {
  // ExpansionTileController controller = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.5), width: 0.5),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: (){
              if(isDesktop) {
                Get.dialog(const Dialog(child: DeliveryInstructionBottomSheet()));
              } else {
                showModalBottomSheet(
                  context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                  builder: (con) => const DeliveryInstructionBottomSheet(),
                );
              }
            },
            child: Row(children: [
              Expanded(child: Text('add_more_delivery_instruction'.tr, style: robotoMedium, maxLines: 2, overflow: TextOverflow.ellipsis)),
              const Icon(Icons.keyboard_arrow_down, size: 20),
            ]),
          ),


          GetBuilder<CheckoutController>(
            builder: (checkoutController) {
              return checkoutController.selectedInstruction != -1 ? Row(children: [
                Text(
                  AppConstants.deliveryInstructionList[checkoutController.selectedInstruction].tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                ),

                IconButton(
                  onPressed: ()=> checkoutController.setInstruction(-1),
                  icon: const Icon(Icons.clear, size: 18),
                )
              ]) : const SizedBox();
            }
          ),
        ],
      ),
    );

    // return Container(
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).cardColor,
    //     borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
    //     boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
    //   ),
    //   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
    //   margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
    //   child: GetBuilder<CheckoutController>(
    //     builder: (checkoutController) {
    //       return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //
    //         Theme(
    //           data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    //           child: ExpansionTile(
    //             key: widget.key,
    //             controller: controller,
    //             title: Text('add_more_delivery_instruction'.tr, style: robotoMedium),
    //             trailing: Icon(checkoutController.isExpanded ? Icons.remove : Icons.add, size: 18),
    //             tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    //             onExpansionChanged: (value) => checkoutController.expandedUpdate(value),
    //
    //             children: [
    //
    //               ResponsiveHelper.isDesktop(context) ? GridView.builder(
    //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //                   crossAxisSpacing: Dimensions.paddingSizeSmall,
    //                   mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
    //                   childAspectRatio: 3.5,
    //                   crossAxisCount:  2,
    //                 ),
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 shrinkWrap: true,
    //                 itemCount: AppConstants.deliveryInstructionList.length,
    //                 padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
    //                 itemBuilder: (context, index) {
    //                   bool isSelected = checkoutController.selectedInstruction == index;
    //                   return InkWell(
    //                     onTap: () {
    //                       checkoutController.setInstruction(index);
    //                     },
    //                     child: Container(
    //                       padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
    //                       decoration: BoxDecoration(
    //                         color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Colors.grey[200],
    //                         borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
    //                         border: Border.all(color: isSelected ?  Theme.of(context).primaryColor : Colors.transparent),
    //                       ),
    //                       child: Row(
    //                         children: [
    //                           Icon(Icons.ac_unit, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 18),
    //                           const SizedBox(width: Dimensions.paddingSizeSmall),
    //                           Expanded(
    //                             child: Text(
    //                               AppConstants.deliveryInstructionList[index].tr,
    //                               style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   );
    //                 },
    //               ) : ListView.builder(
    //                   shrinkWrap: true,
    //                   physics: const NeverScrollableScrollPhysics(),
    //                   itemCount: AppConstants.deliveryInstructionList.length,
    //                   itemBuilder: (context, index){
    //                     bool isSelected = checkoutController.selectedInstruction == index;
    //                     return InkWell(
    //                       onTap: () {
    //                         checkoutController.setInstruction(index);
    //                         if(controller.isExpanded) {
    //                           controller.collapse();
    //                         }
    //                       },
    //                       child: Container(
    //                         decoration: BoxDecoration(
    //                           color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.5) : Colors.grey[200],
    //                           borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
    //                           // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
    //                         ),
    //                         padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
    //                         margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
    //                         child: Row(children: [
    //                           Icon(Icons.ac_unit, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 18),
    //                           const SizedBox(width: Dimensions.paddingSizeSmall),
    //
    //                           Expanded(
    //                             child: Text(
    //                               AppConstants.deliveryInstructionList[index].tr,
    //                               style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
    //                             ),
    //                           ),
    //                         ]),
    //
    //                       ),
    //                     );
    //                   }),
    //             ],
    //           ),
    //         ),
    //
    //         checkoutController.selectedInstruction != -1 && !ResponsiveHelper.isDesktop(context) ? Padding(
    //           padding:  EdgeInsets.symmetric(vertical: checkoutController.isExpanded ? Dimensions.paddingSizeSmall : 0),
    //           child: Row(children: [
    //             Text(
    //               AppConstants.deliveryInstructionList[checkoutController.selectedInstruction].tr,
    //               style: robotoRegular.copyWith(color: Theme.of(context).primaryColor),
    //             ),
    //
    //             InkWell(
    //               onTap: ()=> checkoutController.setInstruction(-1),
    //               child: const Icon(Icons.clear, size: 16),
    //             ),
    //           ])
    //         ) : const SizedBox(),
    //         SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),
    //
    //       ]);
    //     }
    //   ),
    // );
  }
}
