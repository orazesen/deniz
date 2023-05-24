import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomSlider extends StatefulWidget {
  final double height;
  final Radius topLeft;
  final Radius topRight;
  final Radius bottomLeft;
  final Radius bottomRight;
  final List<String> images;
  final bool autoPlay;
  final EdgeInsetsGeometry padding;

  CustomSlider({
    required this.images,
    required this.height,
    this.topLeft = Radius.zero,
    this.topRight = Radius.zero,
    this.bottomLeft = Radius.zero,
    this.bottomRight = Radius.zero,
    this.autoPlay = false,
    this.padding = EdgeInsets.zero,
  });
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemBuilder: (context, index, i) => Container(
            child: Padding(
              padding: widget.padding,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: widget.topLeft,
                  topRight: widget.topRight,
                  bottomLeft: widget.bottomLeft,
                  bottomRight: widget.bottomRight,
                ),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/placeholder.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  image: widget.images[index],
                ),
              ),
            ),
          ),
          itemCount: widget.images.length,
          options: CarouselOptions(
              enableInfiniteScroll: false,
              viewportFraction: 1,
              autoPlay: widget.autoPlay,
              height: widget.height,
              enlargeCenterPage: false,
              onPageChanged: (index, onPageChangeReason) {
                setState(() {
                  currentIndex = index;
                });
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: widget.images.length * 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < widget.images.length; i++)
                  Container(
                    constraints: BoxConstraints(maxHeight: 6, maxWidth: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        3.0,
                      ),
                      color: currentIndex == i ? Colors.black : Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
