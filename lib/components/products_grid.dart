import 'package:flutter/material.dart';
import 'package:saray_pub/components/coffee_grid_item.dart';
import 'package:saray_pub/models/category_item.dart';
import 'package:saray_pub/models/coffee.dart';
import 'package:saray_pub/style/my_colors.dart';
import 'package:saray_pub/style/text_styles.dart';
import 'package:saray_pub/utils/size_config.dart';
import 'package:shimmer/shimmer.dart';
import './grid_item.dart';
import 'package:get/get.dart';

class ProductsGrid extends StatefulWidget {
  // final CategoriesController _categoriesController = Get.find();
  final List<CategoryItem> categories;
  final List<Coffee> coffees;
  final bool isShimmering;
  ProductsGrid({this.isShimmering, this.categories, this.coffees});

  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  // ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _scrollController.addListener(() {
    //   if (_scrollController.position.atEdge) {
    //     if (_scrollController.position.pixels == 0) {
    //       print('at the top');
    //       // You're at the top.
    //     } else {
    //       print('at the end');
    //       // You're at the bottom.
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 4,
            top: SizeConfig.heightMultiplier * 2,
            // bottom: SizeConfig.heightMultiplier * 2,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: SizeConfig.heightMultiplier,
            ),
            child: widget.isShimmering
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: widget.isShimmering,
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: MyColors.background,
                        borderRadius: BorderRadius.circular(
                          SizeConfig.borderRadius,
                        ),
                      ),
                    ),
                  )
                : Text(
                    'menu'.tr,
                    style: TextStyles.header,
                  ),
          ),
        ),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.93,
          ),
          itemCount: widget.isShimmering
              ? 8
              : widget.categories != null
                  ? widget.categories.length
                  : widget.coffees.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          // controller: _scrollController,
          itemBuilder: (context, index) => widget.isShimmering
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  enabled: widget.isShimmering,
                  child: GridItem(
                    isEffect: true,
                    index: index,
                  ),
                )
              : widget.categories != null
                  ? GridItem(
                      mainCategory: widget.categories[index],
                      index: index,
                    )
                  : CoffeeGridItem(
                      coffee: widget.coffees[index],
                      index: index,
                      isEffect: widget.isShimmering,
                    ),
        ),
      ],
    );
  }
}
