import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/presentation/widgets/network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdSpace extends StatelessWidget {
  List<String> imagePaths = [
  'https://hi-news.ru/wp-content/uploads/2009/02/gadjeti.jpg',
  'https://tradepak.ru/wp-content/uploads/2021/01/%D0%BF%D0%B0%D0%BA1.jpg',
  'https://st3.depositphotos.com/9747634/32010/i/450/depositphotos_320104748-stock-photo-hangers-with-different-clothes-in.jpg',
  'https://kartinki.pics/uploads/posts/2021-07/thumbs/1625277121_3-kartinkin-com-p-lekarstva-fon-krasivie-foni-3.jpg'
 
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
  items: imagePaths.map((path ) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: const BoxDecoration(
          
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child:  AspectRatio(
              aspectRatio: 16 / 9,
              child: NetworkImageWithLoader(
                path,
                fit: BoxFit.cover,
              ),
                      ),
                    ),
                    
                     Text('13-19 июля',style: TextStyle(color: Colors.black.withOpacity(0.5)),)
            ],  
          ),
        );
      },
    );
  }).toList(),
)
    );
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
