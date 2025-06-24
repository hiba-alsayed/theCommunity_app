import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:graduation_project/core/app_color.dart';
import 'package:graduation_project/features/complaints/domain/entites/complaint.dart';
import 'nearby_complaint_carousel_item_widget.dart';


class NearbyComplaintCarouselWidget extends StatefulWidget {
  final List<ComplaintEntity> complaint;

  const NearbyComplaintCarouselWidget({
    super.key,
    required this.complaint,
  });

  @override
  State<NearbyComplaintCarouselWidget> createState() => _NearbyComplaintCarouselWidgetState();
}

class _NearbyComplaintCarouselWidgetState extends State<NearbyComplaintCarouselWidget> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    if (widget.complaint.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.complaint.length,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 5 / 2,
            viewportFraction:0.80,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return NearbyComplaintCarouselItemWidget(complaint: widget.complaint[index]);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.complaint.asMap().entries.map((entry) {
            return GestureDetector(
              // onTap: () => _controller.animateToPage(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _current == entry.key ? 24.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.RichBerry)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}