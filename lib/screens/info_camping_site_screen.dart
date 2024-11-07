import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  late DatabaseReference userLikesRef;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _checkLikeStatus();
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

  Future<void> _checkLikeStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userLikesRef = FirebaseDatabase.instance
          .ref('user_likes/${user.uid}/${widget.site.name}');
      final snapshot = await userLikesRef.get();

      setState(() {
        isLiked = snapshot.exists;
      });
    }
  }

  Future<void> _toggleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      isLiked = !isLiked;
    });

    if (isLiked) {
      await userLikesRef.set({
        'name': widget.site.name,
        'latitude': widget.site.latitude,
        'longitude': widget.site.longitude,
      });
    } else {
      await userLikesRef.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildImageSection(),
            _buildInfoSection(),
            _buildAmenitiesSection(),
            _buildMapButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 뒤로 가기 아이콘
          IconButton(
            icon: Icon(Icons.arrow_back, size: 24, color: Color(0xFF172243)),
            onPressed: () => Navigator.pop(context),
          ),

          // 중앙에 위치한 "차박지 상세 정보" 텍스트
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 53.0), // 중앙에서 오른쪽으로 이동
                child: Text(
                  '차박지 상세 정보',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172243),
                  ),
                ),
              ),
            ),
          ),

          // 좋아요와 공유 아이콘
          Row(
            mainAxisSize: MainAxisSize.min, // 아이콘의 간격을 줄이기 위해 최소 크기로 설정
            children: [
              Transform.translate(
                offset: Offset(19, 0), // 좋아요 아이콘을 오른쪽으로 약간 이동
                child: IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Color(0xFF172243),
                    size: 20,
                  ),
                  onPressed: _toggleLike,
                ),
              ),
              SizedBox(width: 6), // 좋아요와 공유 아이콘 사이 간격
              Transform.translate(
                offset: Offset(3, 0), // 공유 아이콘을 왼쪽으로 약간 이동
                child: IconButton(
                  icon: Icon(Icons.share, color: Color(0xFF172243), size: 20),
                  onPressed: () {
                    // 공유 기능 추가
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(24),
      ),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageUrl == null
            ? Center(child: Text('이미지 없음'))
            : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.site.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172243),
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.site.address,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          if (widget.site.details.isNotEmpty) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.site.details,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF398EF3),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    final List<String> amenities = _getAvailableAmenities();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '차박지 편의시설',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172243),
            ),
          ),
          Divider(color: Colors.black, thickness: 1),
          Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
            children:
                amenities.map((amenity) => _buildAmenityChip(amenity)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF398EF3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: Size(double.infinity, 56),
        ),
        onPressed: () {
          // 지도로 보기 기능 추가
        },
        child: Text(
          '지도로 보기',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAmenityChip(String amenity) {
    return Chip(
      backgroundColor: Colors.blue[100],
      label: Text(
        amenity,
        style: TextStyle(color: Colors.black87),
      ),
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
