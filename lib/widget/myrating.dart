import 'package:yourappname/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class MyRating extends StatelessWidget {
  final double rating, size, spacing;
  const MyRating(
      {super.key,
      required this.rating,
      required this.spacing,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
        allowHalfRating: false,
        starCount: 5,
        rating: rating,
        size: size,
        defaultIconData: Icons.star_border,
        filledIconData: Icons.star,
        halfFilledIconData: Icons.star_half,
        color: colorAccent,
        borderColor: colorAccent,
        spacing: spacing);
  }
}
