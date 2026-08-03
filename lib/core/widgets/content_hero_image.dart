import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/content_utils.dart';

final class ContentHeroImage extends StatelessWidget {
  const ContentHeroImage({
    super.key,
    this.imageUrl,
    this.height = 220,
  });

  final String? imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: url != null && url.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (_, _) => Image.asset(
                ContentUtils.defaultImageAsset,
                fit: BoxFit.cover,
              ),
              errorWidget: (_, _, _) => Image.asset(
                ContentUtils.defaultImageAsset,
                fit: BoxFit.cover,
              ),
            )
          : Image.asset(
              ContentUtils.defaultImageAsset,
              fit: BoxFit.cover,
            ),
    );
  }
}
