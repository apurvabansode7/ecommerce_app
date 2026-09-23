
import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SaleBanner extends StatefulWidget {
  const SaleBanner({super.key, this.loading = false});

  final bool loading;

  @override
  State<SaleBanner> createState() => _SaleBannerState();
}

class _SaleBannerState extends State<SaleBanner> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<String> _banners = [
    'lib/assets/banner_img.png',
    'lib/assets/banner_img2.png',
    'lib/assets/banner_img3.png',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: context.hp(19.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: context.hp(17),
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildBanner(context, _banners[index]);
            },
          ),
        ),

        SizedBox(height: context.hp(1)),

        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            final isSelected = index == _currentPage;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: context.wp(0.8)),
              width: isSelected ? context.wp(4) : context.wp(1.5),
              height: context.wp(1.5),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBanner(BuildContext context, String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        image,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: const Icon(Icons.image_not_supported_outlined, size: 40),
          );
        },
      ),
    );
  }
}
