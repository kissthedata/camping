import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomAppBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            iconPath: 'assets/vectors/home_icon.svg',
            label: "홈",
            index: 0,
          ),
          _buildNavItem(
            context,
            iconPath: 'assets/vectors/map_icon.svg',
            label: "지도",
            index: 1,
          ),
          _buildNavItem(
            context,
            iconPath: 'assets/vectors/camping_icon.svg',
            label: "차박지",
            index: 2,
          ),
          _buildNavItem(
            context,
            iconPath: 'assets/vectors/community_icon.svg',
            label: "커뮤니티",
            index: 3,
          ),
          _buildNavItem(
            context,
            iconPath: 'assets/vectors/mypage_icon.svg',
            label: "마이페이지",
            index: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required String iconPath, required String label, required int index}) {
    return InkWell(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            color: selectedIndex == index ? Colors.blue : Colors.black,
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: selectedIndex == index ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
