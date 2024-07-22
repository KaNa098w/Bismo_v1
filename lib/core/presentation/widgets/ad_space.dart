import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/presentation/widgets/network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' hide CarouselController;

class AdSpace extends StatelessWidget {
  List<String> imagePaths = [
    'https://images.smiletemplates.com/uploads/screenshots/596/0000596566/powerpoint-template-450w.jpg',
    'https://img.freepik.com/premium-photo/variety-makeup-products-purple-background_1031240-10519.jpg',
    'https://images.smiletemplates.com/uploads/screenshots/284/0000284946/powerpoint-template-450w.jpg',
    'https://cdn.nur.kz/images/1120x630/3e7752811d7442c9.jpeg'
  ];
  AdSpace({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
        child: CarouselSlider(
          options: CarouselOptions(height: 190.0),
          items: imagePaths.map((path) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: NetworkImageWithLoader(
                            path,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Text(
                      //   '13-19 июля',
                      //   style: TextStyle(color: Colors.black.withOpacity(0.5)),
                      // )
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ));
  }
}

// return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: const AspectRatio(
//           aspectRatio: 16 / 9,
//           child: NetworkImageWithLoader(
//             'https://i.imgur.com/8hBIsS5.png',
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//     );
