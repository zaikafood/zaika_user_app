import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/footer_view_widget.dart';
import '../../../common/widgets/product_view_widget.dart';
import '../../../util/dimensions.dart';
import '../controllers/restaurant_controller.dart';

class VegNonvegRestaurantScreen extends StatefulWidget {
  final String category;

  const VegNonvegRestaurantScreen({super.key, required this.category});

  @override
  State<VegNonvegRestaurantScreen> createState() =>
      _VegNonvegRestaurantScreenState();
}

class _VegNonvegRestaurantScreenState extends State<VegNonvegRestaurantScreen> {
  final ScrollController restaurantScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios),),
          title: Text(widget.category),
        ),
        body: SingleChildScrollView(
          controller: restaurantScrollController,
          child: FooterViewWidget(
            child: Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(
                  children: [
                    ProductViewWidget(
                      isRestaurant: true,
                      products: null,
                      restaurants: restaurantController.restaurantModel
                          ?.restaurants,
                      noDataText: 'no_category_restaurant_found'.tr,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      );
    });
  }
}


