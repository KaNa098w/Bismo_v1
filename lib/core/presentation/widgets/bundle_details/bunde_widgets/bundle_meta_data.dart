import 'package:flutter/material.dart';

class BundleMetaData extends StatelessWidget {
  const BundleMetaData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /* <---- Weight -----> */
          Column(
            children: [
              Text(
                '130г',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              Text(
                'Вес',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),

          /* <----  Size -----> */
          Column(
            children: [
              Text(
                'Средний',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              Text(
                'Размер',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),

          /* <---- Items -----> */
          Column(
            children: [
              Text(
                '17',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              Text(
                'Количество',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
