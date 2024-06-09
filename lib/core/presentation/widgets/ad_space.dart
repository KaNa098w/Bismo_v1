import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/presentation/widgets/network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdSpace extends StatelessWidget {
  List<String> imagePaths = [
    'https://ros-test.info/images/article/5b0d49bf643f1.jpg',
    'https://img.eurointegration.com.ua/images/doc/8/a/8abcd77-photo-2020-11-19-12-52-17.jpg',
    'https://ros-test.info/images/article/5e021fbe9b2c3.jpg',
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
                      Text(
                        '13-19 июля',
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                      )
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
