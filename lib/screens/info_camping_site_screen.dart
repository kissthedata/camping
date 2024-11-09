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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildImageSection(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(),
                      _buildAmenitiesSection(),
                      _buildMapButton(context),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, size: 24, color: Color(0xFF172243)),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 53.0),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: Offset(19, 0),
                child: IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Color(0xFF172243),
                    size: 20,
                  ),
                  onPressed: _toggleLike,
                ),
              ),
              SizedBox(width: 6),
              Transform.translate(
                offset: Offset(3, 0),
                child: IconButton(
                  icon: Icon(Icons.share, color: Color(0xFF172243), size: 20),
                  onPressed: _shareCampingSite,
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172243),
            ),
          ),
          SizedBox(height: 4),
          Text(
            widget.site.address,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          if (widget.site.details.isNotEmpty) ...[
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.site.details.split(',').map((detail) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    detail.trim(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF398EF3),
                    ),
                  ),
                );
              }).toList(),
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
            spacing: 8.0, // 아이템 사이의 가로 간격을 줄임
            runSpacing: 6.0, // 아이템 사이의 세로 간격을 줄임
            children:
                amenities.map((amenity) => _buildAmenityItem(amenity)).toList(),
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

  Widget _buildAmenityItem(String amenity) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/vectors/camping_icon.svg',
          height: 25,
          color: Color(0xFF398EF3),
        ),
        SizedBox(width: 4),
        Text(
          amenity,
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
