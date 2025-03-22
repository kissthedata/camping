import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:map_sample/models/car_camping_site.dart';

class InfoCampingSiteScreen extends StatefulWidget {
  final CarCampingSite site;

  InfoCampingSiteScreen({required this.site});

  @override
  _InfoCampingSiteScreenState createState() => _InfoCampingSiteScreenState();
}

class _InfoCampingSiteScreenState extends State<InfoCampingSiteScreen> {
  String? imageUrl;
  bool isLiked = false;
  int likeCount = 0;
  late DatabaseReference siteLikesRef;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _checkLikeStatus();
    _getLikeCount();
  }

  Future<void> _loadImage() async {
    try {
      final url = await FirebaseStorage.instance
          .ref(widget.site.imageUrl)
          .getDownloadURL();
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  // 좋아요 상태 확인
  Future<void> _checkLikeStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      siteLikesRef = FirebaseDatabase.instance
          .ref('likes/${widget.site.name}/users/${user.uid}');
      final snapshot = await siteLikesRef.get();

      setState(() {
        isLiked = snapshot.exists;
      });
    }
  }

  // 좋아요 수 가져오기
  Future<void> _getLikeCount() async {
    final likeCountRef =
        FirebaseDatabase.instance.ref('likes/${widget.site.name}/count');
    final snapshot = await likeCountRef.get();
    if (snapshot.exists) {
      setState(() {
        likeCount = snapshot.value as int;
      });
    }
  }

  // 좋아요 기능
  Future<void> _toggleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      isLiked = !isLiked;
    });

    final likeData = {
      'name': widget.site.name,
      'latitude': widget.site.latitude,
      'longitude': widget.site.longitude,
      'address': widget.site.address,
      'imageUrl': widget.site.imageUrl,
      'restRoom': widget.site.restRoom,
      'sink': widget.site.sink,
      'cook': widget.site.cook,
      'animal': widget.site.animal,
      'water': widget.site.water,
      'parkinglot': widget.site.parkinglot,
    };

    if (isLiked) {
      // 좋아요 추가
      await FirebaseDatabase.instance
          .ref('user_likes/${user.uid}/${widget.site.name}')
          .set(likeData);
    } else {
      // 좋아요 취소
      await FirebaseDatabase.instance
          .ref('user_likes/${user.uid}/${widget.site.name}')
          .remove();
    }
  }

  // 공유 기능
  void _shareCampingSite() {
    final String shareText =
        '${widget.site.name}\n위치: ${widget.site.address}\n자세한 정보는 앱에서 확인하세요!';
    Share.share(shareText);
  }

  @override

  /// 메인 화면을 구성하는 위젯
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // 시스템 UI 영역과 겹치지 않도록 안전한 영역을 유지
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 자식 요소를 왼쪽 정렬
          children: [
            _buildHeader(context), // 상단 헤더 위젯
            _buildImageSection(), // 이미지 섹션 위젯
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 배경색 설정 (흰색)
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20), // 상단 모서리를 둥글게 설정
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // 그림자 색상
                      spreadRadius: 2, // 그림자 퍼짐 정도
                      blurRadius: 6, // 그림자 흐림 정도
                      offset: Offset(0, -3), // 그림자의 위치 (위쪽)
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0), // 컨테이너 내부 여백 설정
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
                    children: [
                      _buildInfoSection(), // 정보 섹션 위젯
                      _buildAmenitiesSection(), // 편의시설 섹션 위젯
                      _buildMapButton(context), // 지도 버튼 위젯
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 상단 헤더를 구성하는 위젯
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 16.0, horizontal: 8.0), // 상단 헤더의 내부 여백
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // 왼쪽, 중앙, 오른쪽 요소를 양 끝으로 배치
        crossAxisAlignment: CrossAxisAlignment.center, // 세로축 중앙 정렬
        children: [
          // 뒤로 가기 버튼
          IconButton(
            icon: Icon(Icons.arrow_back,
                size: 24, color: Color(0xFF172243)), // 뒤로 가기 아이콘
            onPressed: () => Navigator.pop(context), // 뒤로 이동 기능
          ),
          // 중앙 제목
          Expanded(
            child: Align(
              alignment: Alignment.center, // 텍스트를 중앙에 정렬
              child: Padding(
                padding: const EdgeInsets.only(left: 53.0), // 좌측 패딩 추가
                child: Text(
                  '차박지 상세 정보', // 헤더의 제목 텍스트
                  style: TextStyle(
                    fontSize: 20, // 텍스트 크기
                    fontWeight: FontWeight.bold, // 텍스트 굵기
                    color: Color(0xFF172243), // 텍스트 색상 (진한 네이비 계열)
                  ),
                ),
              ),
            ),
          ),
          // 우측 아이콘들 (좋아요 및 공유)
          Row(
            mainAxisSize: MainAxisSize.min, // Row의 크기를 자식 요소에 맞게 축소
            children: [
              // 좋아요 버튼
              Transform.translate(
                offset: Offset(19, 0), // 버튼 위치를 오른쪽으로 이동
                child: IconButton(
                  icon: Icon(
                    isLiked
                        ? Icons.favorite
                        : Icons.favorite_border, // 좋아요 상태에 따라 아이콘 변경
                    color: Color(0xFF172243), // 아이콘 색상
                    size: 20, // 아이콘 크기
                  ),
                  onPressed: _toggleLike, // 좋아요 상태 변경 함수 호출
                ),
              ),
              SizedBox(width: 6), // 좋아요와 공유 버튼 사이 간격
              // 공유 버튼
              Transform.translate(
                offset: Offset(3, 0), // 버튼 위치를 살짝 오른쪽으로 이동
                child: IconButton(
                  icon: Icon(Icons.share,
                      color: Color(0xFF172243), size: 20), // 공유 아이콘
                  onPressed: _shareCampingSite, // 공유 기능 호출
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 이미지 섹션을 구성하는 위젯
  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(24), // 하단 모서리를 둥글게 설정
      ),
      child: Container(
        height: 200, // 컨테이너 높이
        width: double.infinity, // 컨테이너 너비를 화면 전체로 확장
        decoration: BoxDecoration(
          color: Colors.grey[200], // 배경색 설정 (밝은 회색)
          image: imageUrl != null // 이미지 URL이 있으면
              ? DecorationImage(
                  image: NetworkImage(imageUrl!), // 네트워크 이미지를 불러옴
                  fit: BoxFit.cover, // 이미지를 컨테이너 크기에 맞춤
                )
              : null, // 이미지가 없으면 배경 이미지를 설정하지 않음
        ),
        child: imageUrl == null
            ? Center(
                child: Text('이미지 없음'), // 이미지가 없을 때 중앙에 텍스트 표시
              )
            : SizedBox.shrink(), // 이미지가 있으면 빈 공간
      ),
    );
  }

  /// 사이트 정보 섹션을 구성하는 위젯
  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0), // 섹션의 내부 여백 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
        children: [
          // 사이트 이름 텍스트
          Text(
            widget.site.name, // 사이트 이름
            style: TextStyle(
              fontSize: 22, // 텍스트 크기
              fontWeight: FontWeight.bold, // 텍스트 굵기
              color: Color(0xFF172243), // 텍스트 색상 (진한 네이비 계열)
            ),
          ),
          SizedBox(height: 4), // 사이트 이름과 주소 사이 간격
          // 사이트 주소 텍스트
          Text(
            widget.site.address, // 사이트 주소
            style: TextStyle(
              fontSize: 14, // 텍스트 크기
              color: Colors.grey[600], // 텍스트 색상 (회색)
            ),
          ),
          // 사이트 세부사항이 있을 경우만 렌더링
          if (widget.site.details.isNotEmpty) ...[
            SizedBox(height: 10), // 세부사항과 상단 텍스트 사이 간격
            Wrap(
              spacing: 8.0, // 세부사항 항목 간 가로 간격
              runSpacing: 4.0, // 세부사항 항목 간 세로 간격
              children: widget.site.details.split(',').map((detail) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 6, // 위아래 여백
                    horizontal: 8, // 좌우 여백
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100], // 항목 배경색 (밝은 회색)
                    borderRadius: BorderRadius.circular(8), // 둥근 모서리
                  ),
                  child: Text(
                    detail.trim(), // 세부사항 텍스트
                    style: TextStyle(
                      fontSize: 12, // 텍스트 크기
                      color: Color(0xFF398EF3), // 텍스트 색상 (파란색 계열)
                    ),
                  ),
                );
              }).toList(), // 맵핑된 세부사항 리스트
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    final List<String> amenities = _getAvailableAmenities();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0, // 좌우 여백
        vertical: 8.0, // 상하 여백
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 요소를 왼쪽 정렬
        children: [
          // 섹션 제목
          Text(
            '차박지 편의시설', // 제목 텍스트
            style: TextStyle(
              fontSize: 16, // 텍스트 크기
              fontWeight: FontWeight.bold, // 텍스트 굵기
              color: Color(0xFF172243), // 텍스트 색상 (진한 네이비 계열)
            ),
          ),
          // 구분선
          Divider(
            color: Colors.black, // 구분선 색상
            thickness: 1, // 구분선 두께
          ),
          // 편의시설 항목들을 배치하는 영역
          Wrap(
            spacing: 8.0, // 각 항목 사이의 가로 간격
            runSpacing: 6.0, // 각 항목 사이의 세로 간격
            children: amenities // 편의시설 리스트를 순회
                .map((amenity) => _buildAmenityItem(
                    amenity)) // 각 아이템을 `_buildAmenityItem`으로 생성
                .toList(), // 리스트로 변환
          ),
        ],
      ),
    );
  }

  /// "지도로 보기" 버튼을 생성하는 위젯
  Widget _buildMapButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // 버튼 주변에 16의 여백 추가
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF398EF3), // 버튼 배경색 (파란색 계열)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 버튼 모서리를 둥글게 설정
          ),
          minimumSize:
              Size(double.infinity, 56), // 버튼 크기를 화면 너비로 확장하고 높이를 56으로 고정
        ),
        onPressed: () {
          // 버튼 클릭 시 실행할 동작 정의 (지도로 보기 기능 추가 예정)
        },
        child: Text(
          '지도로 보기', // 버튼에 표시될 텍스트
          style: TextStyle(
            fontSize: 16, // 텍스트 크기
            color: Colors.white, // 텍스트 색상 (흰색)
          ),
        ),
      ),
    );
  }

  /// 편의시설 아이템을 생성하는 위젯
  Widget _buildAmenityItem(String amenity) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Row의 크기를 자식 요소에 맞게 축소
      children: [
        // 아이콘 표시
        SvgPicture.asset(
          'assets/vectors/camping_icon.svg', // 아이콘 이미지 경로 (SVG 형식)
          height: 25, // 아이콘 높이
          color: Color(0xFF398EF3), // 아이콘 색상 (파란색 계열)
        ),
        SizedBox(width: 4), // 아이콘과 텍스트 사이 간격
        // 편의시설 이름 텍스트
        Text(
          amenity, // 전달받은 편의시설 이름
        ),
      ],
    );
  }

  List<String> _getAvailableAmenities() {
    List<String> amenities = [];
    if (widget.site.restRoom) amenities.add('화장실');
    if (widget.site.sink) amenities.add('개수대');
    if (widget.site.cook) amenities.add('취사장');
    if (widget.site.animal) amenities.add('반려동물');
    if (widget.site.water) amenities.add('샤워실');
    if (widget.site.parkinglot) amenities.add('주차장');
    return amenities;
  }
}
