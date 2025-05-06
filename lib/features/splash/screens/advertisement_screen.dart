import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zaika/common/models/restaurant_model.dart';
import 'package:zaika/common/widgets/custom_image_widget.dart';
import 'package:zaika/features/home/controllers/advertisement_controller.dart';
import 'package:zaika/features/home/domain/models/advertisement_model.dart';
import 'package:zaika/features/home/screens/home_screen.dart';
import 'package:zaika/features/language/controllers/localization_controller.dart';
import 'package:zaika/features/restaurant/screens/restaurant_screen.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:video_player/video_player.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({super.key});

  @override
  State<AdvertisementScreen> createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _remainingSeconds = 15;
  late Timer _timer;
  bool _timerStarted = false;

  @override
  void initState() {
    Get.find<AdvertisementController>().getAdvertisementList();
    super.initState();
  }

  void _startCountdownTimer() {
    _timerStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        Get.find<AdvertisementController>().showSkipButton();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _navigateToHome() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    if (Get.find<AdvertisementController>().showSkip) {
      Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true ));
    }
  }

  @override
  void dispose() {
    if (_timerStarted && _timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdvertisementController>(builder: (advertisementController) {
      final list = advertisementController.advertisementList;

      if (!_timerStarted && list != null && list.isNotEmpty) {
        _startCountdownTimer();
      }

      return Stack(
        children: [
          list != null && list.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(
              top: Dimensions.paddingSizeDefault,
              bottom: Dimensions.paddingSizeDefault,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: list.length,
                  options: CarouselOptions(
                    enableInfiniteScroll: list.length > 2,
                    autoPlay: advertisementController.autoPlay,
                    enlargeCenterPage: false,
                    // height: MediaQuery.of(context).size.height,
                    viewportFraction: 1,
                    disableCenter: true,
                    onPageChanged: (index, reason) {
                      advertisementController.setCurrentIndex(index, true);
                      if (list[index].addType == "video_promotion") {
                        advertisementController.updateAutoPlayStatus(status: false);
                      } else {
                        advertisementController.updateAutoPlayStatus(status: true);
                      }
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return list[index].addType == 'video_promotion'
                        ? HighlightVideoWidget(advertisement: list[index])
                        : HighlightRestaurantWidget(advertisement: list[index]);
                  },
                ),
                const AdvertisementIndicator(),
              ],
            ),
          )
              : const AdvertisementShimmer(),
          if (list != null && list.isNotEmpty)
            Positioned(
              top: 40,
              right: 20,
              child: Row(
                children: [
                  if(!advertisementController.showSkip)
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$_remainingSeconds',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  advertisementController.showSkip
                  ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      _navigateToHome();
                    },
                    child: const Text(
                      'skip',
                      style: TextStyle(color: Colors.white),
                    ),
                  ) : Container(),
                ],
              ),
            ),
        ],
      );
    });
  }
}


class HighlightRestaurantWidget extends StatelessWidget {
  final AdvertisementModel advertisement;
  const HighlightRestaurantWidget({super.key, required this.advertisement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      height:  MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.07), width: 2),
      ),
      child: InkWell(
        onTap: (){
          Get.toNamed(RouteHelper.getRestaurantRoute(advertisement.restaurantId),
            arguments: RestaurantScreen(restaurant: Restaurant(id: advertisement.restaurantId)),
          );
        },
        child: Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
            child: Stack(
              children: [
                CustomImageWidget(
                  image: advertisement.coverImageFullUrl ?? '',
                  fit: BoxFit.cover,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HighlightVideoWidget extends StatefulWidget {
  final AdvertisementModel advertisement;
  const HighlightVideoWidget({super.key, required this.advertisement});

  @override
  State<HighlightVideoWidget> createState() => _HighlightVideoWidgetState();
}

class _HighlightVideoWidgetState extends State<HighlightVideoWidget> {

  late VideoPlayerController videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();

    videoPlayerController.addListener(() {
      if(videoPlayerController.value.duration == videoPlayerController.value.position){
        if(GetPlatform.isWeb){
          Future.delayed(const Duration(seconds: 4), () {
            Get.find<AdvertisementController>().updateAutoPlayStatus(status: true, shouldUpdate: true);
          });
        }else{
          Get.find<AdvertisementController>().updateAutoPlayStatus(status: true, shouldUpdate: true);
        }
      }
    });
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
      widget.advertisement.videoAttachmentFullUrl ?? "",
    ));

    await Future.wait([
      videoPlayerController.initialize(),
    ]);

    if (!mounted) return;

    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      aspectRatio: videoPlayerController.value.aspectRatio,
    );
    _chewieController?.setVolume(0);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdvertisementController>(builder: (advertisementController) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height:  MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.07), width: 2),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
            child: Stack(
              children: [
                _chewieController != null &&  _chewieController!.videoPlayerController.value.isInitialized ? Stack(
                  children: [
                    Chewie(controller: _chewieController!),
                  ],
                ) : const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class AdvertisementIndicator extends StatelessWidget {
  const AdvertisementIndicator({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<AdvertisementController>(builder: (advertisementController) {
      return advertisementController.advertisementList != null && advertisementController.advertisementList!.length > 2 ?
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(height: 7, width: 7,
          decoration:  BoxDecoration(color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: advertisementController.advertisementList!.map((advertisement) {
            int index = advertisementController.advertisementList!.indexOf(advertisement);
            return index == advertisementController.currentIndex ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
              margin: const EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                  color:  Theme.of(context).primaryColor ,
                  borderRadius: BorderRadius.circular(50)),
              child:  Text("${index+1}/ ${advertisementController.advertisementList!.length}",
                style: const TextStyle(color: Colors.white,fontSize: 12),),
            ):const SizedBox();
          }).toList(),
        ),
        Container(
          height: 7, width: 7,
          decoration:  BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      ]): advertisementController.advertisementList != null && advertisementController.advertisementList!.length == 2 ?
      Align(
        alignment: Alignment.center,
        child: AnimatedSmoothIndicator(
          activeIndex: advertisementController.currentIndex,
          count: advertisementController.advertisementList!.length,
          effect: ExpandingDotsEffect(
            dotHeight: 7,
            dotWidth: 7,
            spacing: 5,
            activeDotColor: Theme.of(context).colorScheme.primary,
            dotColor: Theme.of(context).hintColor.withValues(alpha: 0.6),
          ),
        ),
      ): const SizedBox();
    });
  }
}

class AdvertisementShimmer extends StatelessWidget {
  const AdvertisementShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.05),
        ),
        margin:  EdgeInsets.only(
          top: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge * 3.5 : 0 ,
          right: Get.find<LocalizationController>().isLtr && ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0,
          left: !Get.find<LocalizationController>().isLtr && ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0,
        ),
        child: Padding( padding : const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: Dimensions.paddingSizeLarge,),

              Container(height: 20, width: 200,
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).shadowColor
                ),),

              const SizedBox(height: Dimensions.paddingSizeSmall,),

              Container(height: 15, width: 250,
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).shadowColor,
                ),),

              const SizedBox(height: Dimensions.paddingSizeDefault * 2,),

              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: ResponsiveHelper.isDesktop(context) ? 3 : 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: ResponsiveHelper.isDesktop(context) ? (Dimensions.webMaxWidth - 20) / 3 : MediaQuery.of(context).size.width,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(padding: const EdgeInsets.only(bottom: 0, left: 10, right: 10),
                            child: Container(
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                                color: Theme.of(context).shadowColor,
                                border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2),),
                              ),
                              padding: const EdgeInsets.only(bottom: 25),
                              child: const Center(child: Icon(Icons.play_circle, color: Colors.white,size: 45,),),
                            ),
                          ),

                          Positioned( bottom: 0, left: 0,right: 0, child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                                color: Theme.of(context).cardColor,
                                border: Border.all(color: Theme.of(context).shadowColor)
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: Column(children: [
                              Row( children: [

                                Expanded(
                                  child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Container(
                                      height: 17, width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        color: Theme.of(context).shadowColor,
                                      ),
                                    ),

                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                    Container(
                                      height: 17, width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        color: Theme.of(context).shadowColor,
                                      ),
                                    ),

                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                                    Container(
                                      height: 17, width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        color: Theme.of(context).shadowColor,
                                      ),
                                    )
                                  ]),
                                ),

                                const SizedBox(width: Dimensions.paddingSizeLarge,),

                                InkWell(
                                  onTap: () => Get.back(),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall + 5, vertical: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      color: Theme.of(context).shadowColor,
                                    ),
                                    child:  Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white.withValues(alpha: 0.8),),
                                  ),
                                )
                              ],)
                            ],),
                          ))
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeLarge * 2,),

              Align(
                alignment: Alignment.center,
                child: AnimatedSmoothIndicator(
                  activeIndex: 0,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotHeight: 7,
                    dotWidth: 7,
                    spacing: 5,
                    activeDotColor: Theme.of(context).disabledColor,
                    dotColor: Theme.of(context).hintColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
            ],
          ),
        ),
      ),
    );
  }
}
