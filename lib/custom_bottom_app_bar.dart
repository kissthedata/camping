import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomAppBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // 너비를 화면 전체로 설정
      height: 75 + MediaQuery.of(context).viewPadding.bottom, // 고정된 높이,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(38.w, 12.h, 38.w, 0.h),
        child: Row(
          children: [
            Expanded(
              child: _buildNavItem(
                context,
                iconPath: 'home',
                label: "홈",
                index: 0,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context,
                iconPath: 'map',
                label: "지도",
                index: 1,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context,
                iconPath: 'commu',
                label: "커뮤니티",
                index: 3,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context,
                iconPath: 'my',
                label: "마이페이지",
                index: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String iconPath,
    required String label,
    required int index,
  }) {
    return InkWell(
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/bottom_${iconPath}_${selectedIndex == index ? 'selected' : 'normal'}.png',
            width: 30.w,
            height: 30.h,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: selectedIndex == index
                  ? const Color(0xFF398ef3)
                  : Color(0xff777777),
            ),
          ),
        ],
      ),
    );
  }
}
