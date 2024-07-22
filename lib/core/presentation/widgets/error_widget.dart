import 'package:flutter/material.dart';

class NetworkImageWithLoader extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget errorWidget;

  const NetworkImageWithLoader({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.errorWidget = const Icon(Icons.error),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return errorWidget;
      },
    );
  }
}
