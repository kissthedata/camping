import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_sample/models/car_camping_site.dart';

class InfoCampingSiteScreen extends StatelessWidget {
  final CarCampingSite site;

  InfoCampingSiteScreen({required this.site});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14.85, sigmaY: 14.85),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F0F0),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 34),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 88),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16, 32.4, 0, 19),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 7.4),
                                    child: SvgPicture.asset(
                                      'assets/vectors/union_x2.svg',
                                      width: 23,
                                      height: 17.2,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5.6),
                                    child: Text(
                                      '차박지 상세 정보',
                                      style: GoogleFonts.robotoCondensed( // Changed to a more common font
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(right: 2.3, bottom: 73),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: SvgPicture.asset(
                                'assets/vectors/group_x2.svg',
                                width: 53.7,
                                height: 47,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 13.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: List.generate(4, (index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: index == 0
                                            ? Color(0xFF398EF3)
                                            : Color(0xA1AEAEAE),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      width: 4,
                                      height: 4,
                                    );
                                  }),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 8),
                                      child: SvgPicture.asset(
                                        'assets/vectors/vector_2_x2.svg',
                                        width: 15,
                                        height: 13,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 0.5),
                                      child: Text(
                                        '사진 추가하기',
                                        style: GoogleFonts.robotoCondensed( // Changed to a more common font
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          decoration: TextDecoration.underline,
                                          color: Color(0xFF8F8F8F),
                                          decorationColor: Color(0xFF8F8F8F),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: -151,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0F000000),
                      offset: Offset(0, -2),
                      blurRadius: 7.75,
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 360,
                  height: 690,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 16, 16, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 4.4, 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 14),
                                child: Text(
                                  site.name, // Update with site name
                                  style: GoogleFonts.robotoCondensed( // Changed to a more common font
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    letterSpacing: -0.5,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/vectors/vector_11_x2.svg',
                                    width: 20,
                                    height: 18,
                                  ),
                                  SizedBox(width: 14),
                                  SvgPicture.asset(
                                    'assets/vectors/vector_13_x2.svg',
                                    width: 14,
                                    height: 18,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 0.4),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/vectors/vector_17_x2.svg',
                                          width: 4.9,
                                          height: 4.9,
                                        ),
                                        SvgPicture.asset(
                                          'assets/vectors/vector_12_x2.svg',
                                          width: 4.9,
                                          height: 10.7,
                                        ),
                                        SvgPicture.asset(
                                          'assets/vectors/vector_x2.svg',
                                          width: 4.9,
                                          height: 17.6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 9, vertical: 18),
                          child: Text(
                            site.address, // Update with site address
                            style: GoogleFonts.robotoCondensed( // Changed to a more common font
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(4, 0, 0, 30),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF398EF3)),
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.fromLTRB(19, 15, 19, 66),
                          child: Text(
                            site.details.isNotEmpty
                                ? site.details
                                : '차박지에 대한 나만의 설명을 적어주세요! (최대 200자)',
                            style: GoogleFonts.robotoCondensed( // Changed to a more common font
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF8E8E8E),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          child: Text(
                            '차박지 편의시설',
                            style: GoogleFonts.robotoCondensed( // Changed to a more common font
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: -0.3,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          indent: 9,
                          endIndent: 9,
                          color: Colors.black,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(9, 0, 9, 32),
                          child: Wrap(
                            spacing: 14.9,
                            runSpacing: 8,
                            children: List.generate(6, (index) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          'assets/images/x_1.png',
                                        ),
                                      ),
                                    ),
                                    width: 23,
                                    height: 23,
                                    margin: EdgeInsets.only(right: 5),
                                  ),
                                  Text(
                                    _getAmenityText(index),
                                    style: GoogleFonts.robotoCondensed( // Changed to a more common font
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF398EF3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                '지도로 보기',
                                style: GoogleFonts.robotoCondensed( // Changed to a more common font
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            '차박지 신고하기',
                            style: GoogleFonts.robotoCondensed( // Changed to a more common font
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              decoration: TextDecoration.underline,
                              color: Color(0xFF7B7B7B),
                              decorationColor: Color(0xFF7B7B7B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAmenityText(int index) {
    switch (index) {
      case 0:
        return '화장실';
      case 1:
        return '반려동물';
      case 2:
        return '샤워실';
      case 3:
        return '개수대';
      case 4:
        return '전기';
      case 5:
        return '야경';
      default:
        return '';
    }
  }
}
