import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class LoginCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> carouselItems;

  const LoginCarousel({super.key, required this.carouselItems});

  @override
  State<LoginCarousel> createState() => _LoginCarouselState();
}

class _LoginCarouselState extends State<LoginCarousel> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              // height: 250,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.85,
              autoPlayInterval: const Duration(seconds: 2),
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            items: widget.carouselItems.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    // height: 30.h,
                    color: Colors.transparent,
                    // elevation: 4,
                    //margin: const EdgeInsets.symmetric(horizontal: 8).r,
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            item["profile"]!,
                            fit: BoxFit.fill,
                            height: 90,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          item["role"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // const SizedBox(height: 5),
                        // Text(
                        //   item["subtitle"]!,
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(fontSize: 11, color: Colors.white),
                        // ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.carouselItems.length, (index) {
              final isActive = currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: isActive ? 12 : 8,
                width: isActive ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.white : Colors.grey[400],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
