import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saray_pub/components/custom_error.dart';
import 'package:saray_pub/components/my_scroll_behavior.dart';
import 'package:saray_pub/components/products_grid.dart';
import 'package:saray_pub/constants/constants.dart';
import 'package:get/get.dart';
import 'package:saray_pub/controllers/coffee_menus_controller.dart';
import 'package:saray_pub/models/coffee.dart';
import 'package:saray_pub/style/my_colors.dart';
import 'package:shimmer/shimmer.dart';
import '../style/text_styles.dart';
import '../utils/size_config.dart';
import 'package:flutter_svg/svg.dart';

class CoffeePage extends StatefulWidget {
  static String routeName = '/coffee';

  @override
  _CoffeePageState createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> with TickerProviderStateMixin {
  bool isLoading = false;
  bool hasError = false;

  final _coffeeController = Get.find<CoffeeMenusController>();
  GoogleMapController _mapController;

  ScrollController _scrollController;

  List<Coffee> coffees = List<Coffee>();
  bool _loading = true;
  Set<Marker> markers = {};
  String locale;
  // Uint8List markerIcond;
  // BitmapDescriptor icon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    // getIcon();
    getCoffees();
  }

  @override
  Widget build(BuildContext context) {
    // colorize();
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.light,
        title: Text(
          'coffee_title'.tr,
          style: TextStyles.title,
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Container(
            padding: EdgeInsets.only(
              right: SizeConfig.widthMultiplier * 2,
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                Constants.location,
                height: SizeConfig.heightMultiplier * 3,
              ),
              onPressed: () async {
                await showInfo(context);
                colorize();
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (_loading) return;
          _coffeeController.coffees = null;
          _coffeeController.addresses = null;
          _coffeeController.currentPage = 0;
          setState(() {
            _loading = true;
          });
          getCoffees();
        },
        child: _coffeeController.coffees.length > 0
            ? buildColumn(
                coffee: _coffeeController.coffees,
              )
            : _loading
                ? buildColumn(
                    isShimmering: true,
                  )
                : hasError
                    ? Center(
                        child: CustomError(
                          message: 'no_internet'.tr,
                          callback: () {
                            setState(() {
                              _loading = true;
                            });
                            getCoffees();
                          },
                          actionMessage: 'try_again'.tr,
                          iconName: Icons.wifi_off_sharp,
                        ),
                      )
                    : buildColumn(coffee: _coffeeController.coffees),
      ),
    );
  }

  buildColumn({List<Coffee> coffee, bool isShimmering = false}) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        controller: isShimmering ? null : _scrollController,
        child: Column(
          children: [
            Container(
              height: SizeConfig.heightMultiplier * 30,
              width: SizeConfig.widthMultiplier * 100,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SizeConfig.borderRadius),
                child: isShimmering
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        enabled: isShimmering,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              SizeConfig.borderRadius,
                            ),
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          GoogleMap(
                            key: PageStorageKey('Google Map Key'),
                            initialCameraPosition: CameraPosition(
                              target: _coffeeController.addresses[0].location,
                              zoom: 13,
                            ),
                            markers: markers,
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },

                            // mapToolbarEnabled: true,
                            compassEnabled: true,
                            gestureRecognizers: Set()
                              ..add(
                                Factory<PanGestureRecognizer>(
                                  () => PanGestureRecognizer(),
                                ),
                              )
                              ..add(
                                Factory<ScaleGestureRecognizer>(
                                  () => ScaleGestureRecognizer(),
                                ),
                              )
                              ..add(
                                Factory<TapGestureRecognizer>(
                                  () => TapGestureRecognizer(),
                                ),
                              )
                              ..add(
                                Factory<VerticalDragGestureRecognizer>(
                                  () => VerticalDragGestureRecognizer(),
                                ),
                              ),
                          ),
                          // Positioned(
                          //   top: 0,
                          //   right: 0,
                          //   child: IconButton(
                          //     icon: Icon(
                          //       Icons.zoom_out_map,
                          //     ),
                          //     onPressed: () {
                          //       Get.to(
                          //         MapPage(),
                          //         fullscreenDialog: true,
                          //       );
                          //     },
                          //     splashColor: Colors.transparent,
                          //     highlightColor: Colors.transparent,
                          //   ),
                          // )
                        ],
                      ),
              ),
            ),
            ProductsGrid(
              isShimmering: isShimmering,
              coffees: coffee,
            ),
            isLoading && !isShimmering
                ? Container(
                    height: SizeConfig.heightMultiplier * 6,
                    child: Center(
                        child: SpinKitThreeBounce(
                      color: MyColors.darkGreen,
                      size: SizeConfig.heightMultiplier * 3,
                      controller: AnimationController(
                        vsync: this,
                        duration: const Duration(
                          milliseconds: 1200,
                        ),
                      ),
                    )),
                  )
                : Container(),
            SizedBox(
              height: 72,
            ),
          ],
        ),
      ),
    );
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (isLoading) return;
      setState(() {
        isLoading = true;
        if (_coffeeController.lastPage == _coffeeController.currentPage) {
          isLoading = false;
        } else {
          getCoffees();
        }
      });
    }
    // if (_scrollController.offset <=
    //         _scrollController.position.minScrollExtent &&
    //     !_scrollController.position.outOfRange) {
    //   setState(() {
    //     message = "reach the top";
    //   });
    // }
  }

  Future<void> showInfo(BuildContext context) {
    decolorize();
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          insetPadding:
              EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 4),
          child: Container(
            // height: SizeConfig.heightMultiplier * 70,
            // width: SizeConfig.widthMultiplier * 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                SizeConfig.borderRadius,
              ),
            ),
            padding: EdgeInsets.all(
              SizeConfig.heightMultiplier * 3,
            ),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Wrap(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Constants.ugurCoffee,
                            height: SizeConfig.heightMultiplier * 5,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier,
                          ),
                          Text(
                            'stations'.tr,
                            style: TextStyles.button.copyWith(
                              color: MyColors.darkGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.textMultiplier * 2.5,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          _coffeeController.addresses.length <= 0
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[100],
                                  enabled: true,
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height:
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              SvgPicture.asset(
                                                Constants.direction,
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    3.4,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width:
                                                SizeConfig.widthMultiplier * 5,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height:
                                                    SizeConfig.heightMultiplier,
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    SizeConfig.borderRadius,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    SizeConfig.widthMultiplier *
                                                        1.2,
                                              ),
                                              Container(
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    3,
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        60,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    SizeConfig.borderRadius,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    SizeConfig.widthMultiplier *
                                                        1.6,
                                              ),
                                              Container(
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    1.6,
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        40,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    SizeConfig.borderRadius,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: SizeConfig.heightMultiplier * 3,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          _coffeeController.addresses.length <= 0
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[100],
                                  enabled: true,
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height:
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              SvgPicture.asset(
                                                Constants.direction,
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    3.4,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width:
                                                SizeConfig.widthMultiplier * 5,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height:
                                                    SizeConfig.heightMultiplier,
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    SizeConfig.borderRadius,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    SizeConfig.widthMultiplier *
                                                        1.2,
                                              ),
                                              Container(
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    3,
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        60,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    SizeConfig.borderRadius,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    SizeConfig.widthMultiplier *
                                                        1.6,
                                              ),
                                              Container(
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    1.6,
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        40,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    SizeConfig.borderRadius,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: SizeConfig.heightMultiplier * 3,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          ..._coffeeController.addresses.map(
                            (element) {
                              return GestureDetector(
                                onTap: () {
                                  Get.back();
                                  _mapController.moveCamera(
                                    CameraUpdate.newLatLng(
                                      element.location,
                                    ),
                                  );
                                  _mapController.showMarkerInfoWindow(
                                      MarkerId(element.address[locale]));
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              height:
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            SvgPicture.asset(
                                              Constants.direction,
                                              height:
                                                  SizeConfig.heightMultiplier *
                                                      3.4,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: SizeConfig.widthMultiplier * 5,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'station'.tr +
                                                  ' ' +
                                                  (_coffeeController.addresses
                                                              .indexOf(
                                                                  element) +
                                                          1)
                                                      .toString() +
                                                  ':',
                                              style: TextStyle(
                                                fontSize:
                                                    SizeConfig.textMultiplier,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  SizeConfig.widthMultiplier *
                                                      1.2,
                                            ),
                                            Text(
                                              element.address[locale],
                                              style: TextStyle(
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        1.8,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  SizeConfig.widthMultiplier *
                                                      1.6,
                                            ),
                                            ...element.phones.map(
                                              (element) {
                                                return Column(
                                                  children: [
                                                    Text(
                                                      element,
                                                      style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .textMultiplier *
                                                            1.6,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .heightMultiplier *
                                                          0.6,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 3,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  getCoffees() async {
    try {
      // _coffeeController.addresses = null;
      await _coffeeController.setInitials();
      if (Get.locale != null)
        locale =
            Get.locale.languageCode == 'tr' ? 'tk' : Get.locale.languageCode;
      _coffeeController.addresses.forEach((element) {
        String phones = '';
        element.phones.forEach((e) {
          phones += e + ',';
        });
        markers.add(
          Marker(
            markerId: MarkerId(element.address[locale]),
            // icon: icon,
            icon: BitmapDescriptor.fromBytes(_coffeeController.markerIcond),
            // icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
                title: element.address[locale], snippet: phones, onTap: () {}),
            position: element.location,
          ),
        );
      });

      setState(() {
        _loading = false;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        _loading = false;
        isLoading = false;
      });
    }
  }

  colorize() {
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
  }

  decolorize() {
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  // getIcon() async {
  //   // markerIcond = await getBytesFromCanvas(100, 100, Constants.ugurCoffee);
  //   markerIcond = await Constants.getBytesFromAsset(
  //       Constants.ugurCoffee, (SizeConfig.heightMultiplier * 18).toInt());
  //   // icon = BitmapDescriptor.fromAssetImage(
  //   //   ImageConfiguration(size: Size(12, 12)),
  //   //   Constants.ugurCoffee,
  //   // ) as BitmapDescriptor;
  // }

  // Future<Uint8List> getBytesFromCanvas(int width, int height, urlAsset) async {
  //   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder);
  //   final Paint paint = Paint()..color = Colors.transparent;
  //   final Radius radius = Radius.circular(20.0);
  //   canvas.drawRRect(
  //       RRect.fromRectAndCorners(
  //         Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
  //         topLeft: radius,
  //         topRight: radius,
  //         bottomLeft: radius,
  //         bottomRight: radius,
  //       ),
  //       paint);

  //   final ByteData datai = await rootBundle.load(urlAsset);

  //   var imaged = await loadImage(new Uint8List.view(datai.buffer));

  //   canvas.drawImage(imaged, new Offset(0, 0), new Paint());

  //   final img = await pictureRecorder.endRecording().toImage(width, height);
  //   final data = await img.toByteData(format: ui.ImageByteFormat.png);
  //   return data.buffer.asUint8List();
  // }

  // Future<ui.Image> loadImage(List<int> img) async {
  //   final Completer<ui.Image> completer = new Completer();
  //   ui.decodeImageFromList(img, (ui.Image img) {
  //     return completer.complete(img);
  //   });
  //   return completer.future;
  // }

  // addSingleMarker(ad) async {
  //   final temp = await getBytesFromCanvas(ad);
  //   markers.add(BitmapDescriptor.fromBytes(temp));
  // }

  // Future<Uint8List> getBytesFromCanvas(ItemDataSerializer ad) async {
  //   final width = 180;
  //   final height = 100;

  //   final PictureRecorder pictureRecorder = PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder);
  //   final Paint paint = Paint()
  //     ..color = int.parse(ad.for_sale) == 1
  //         ? MyColors.acarGreenColor
  //         : Colors.yellow.shade700;
  //   final Radius radius = Radius.circular(20.0);
  //   canvas.drawRRect(
  //       RRect.fromRectAndCorners(
  //         Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble() - 20),
  //         topLeft: radius,
  //         topRight: radius,
  //         bottomLeft: radius,
  //         bottomRight: radius,
  //       ),
  //       paint);
  //   Path _path = Path();
  //   _path.moveTo(width / 2 - 10, height - 20.0);
  //   _path.lineTo(width / 2, height.toDouble());
  //   _path.lineTo(width / 2 + 10, height - 20.0);
  //   _path.close();
  //   canvas.drawPath(_path, paint);
  //   TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
  //   painter.text = TextSpan(
  //     text: '${ad.formatedPrice}',
  //     style: TextStyle(fontSize: 35, color: Colors.white),
  //   );
  //   // print("painted : ${ad.formatedPrice}");
  //   painter.layout();
  //   painter.paint(
  //       canvas,
  //       Offset((width * 0.5) - painter.width * 0.5,
  //           ((height - 20) * 0.5) - painter.height * 0.5));
  //   final img = await pictureRecorder.endRecording().toImage(width, height);
  //   final data = await img.toByteData(format: ImageByteFormat.png);
  //   return data.buffer.asUint8List();
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    if (_mapController != null) _mapController.dispose();
    // _coffeeController.dispose();
  }
}
