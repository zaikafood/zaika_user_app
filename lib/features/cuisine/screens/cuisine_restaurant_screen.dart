import 'package:zaika/features/cuisine/controllers/cuisine_controller.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/common/widgets/custom_app_bar_widget.dart';
import 'package:zaika/common/widgets/footer_view_widget.dart';
import 'package:zaika/common/widgets/menu_drawer_widget.dart';
import 'package:zaika/common/widgets/paginated_list_view_widget.dart';
import 'package:zaika/common/widgets/product_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CuisineRestaurantScreen extends StatefulWidget {
  final int cuisineId;
  final String? name;
  const CuisineRestaurantScreen({super.key, required this.cuisineId, required this.name});

  @override
  State<CuisineRestaurantScreen> createState() => _CuisineRestaurantScreenState();
}

class _CuisineRestaurantScreenState extends State<CuisineRestaurantScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<CuisineController>().initialize();
    Get.find<CuisineController>().getCuisineRestaurantList(widget.cuisineId, 1, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: '${widget.name!} ${'cuisines'.tr}'),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,

      body: SingleChildScrollView(
        controller: _scrollController,
        child: FooterViewWidget(
          child: Center(
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: GetBuilder<CuisineController>(builder: (cuisineController) {
                if(cuisineController.cuisineRestaurantsModel != null){}
                return PaginatedListViewWidget(
                  scrollController: _scrollController,
                  totalSize: cuisineController.cuisineRestaurantsModel?.totalSize,
                  offset: cuisineController.cuisineRestaurantsModel != null ? int.parse(cuisineController.cuisineRestaurantsModel!.offset!) : null,
                  onPaginate: (int? offset) async => await cuisineController.getCuisineRestaurantList(widget.cuisineId, offset!, false),
                  productView: ProductViewWidget(
                    isRestaurant: true, products: null,
                    restaurants: cuisineController.cuisineRestaurantsModel?.restaurants,
                    padding: EdgeInsets.only(
                      left: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                      right: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                      top: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
                      bottom: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
