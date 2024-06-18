import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CarCampingSite {
  final String name;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final bool restRoom;
  final bool sink;
  final bool cook;
  final bool animal;
  final bool water;
  final bool parkinglot;

  CarCampingSite({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.imageUrl = '',
    this.restRoom = false,
    this.sink = false,
    this.cook = false,
    this.animal = false,
    this.water = false,
    this.parkinglot = false,
  });
}

class RegionPage extends StatefulWidget {
  @override
  _RegionPageState createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  final List<CarCampingSite> _campingSites = [];
  final List<CarCampingSite> _filteredCampingSites = [];
  NaverMapController? _mapController;
  final PanelController _panelController = PanelController();
  bool showRestRoom = true;
  bool showSink = true;
  bool showCook = true;
  bool showAnimal = true;
  bool showWater = true;
  bool showParkinglot = true;

  NMarker? _currentLocationMarker;

  @override
  void initState() {
    super.initState();
    _loadCampingSites(); // 차박지 정보 불러오기
  }

  Future<void> _loadCampingSites() async {
    // 차박지 정보를 데이터베이스에서 불러오는 함수
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('car_camping_sites');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        Map<String, dynamic> siteData = Map<String, dynamic>.from(value);
        CarCampingSite site = CarCampingSite(
          name: siteData['place'],
          latitude: siteData['latitude'],
          longitude: siteData['longitude'],
          imageUrl: siteData['imageUrl'] ?? '',
          restRoom: siteData['restRoom'] ?? false,
          sink: siteData['sink'] ?? false,
          cook: siteData['cook'] ?? false,
          animal: siteData['animal'] ?? false,
          water: siteData['water'] ?? false,
          parkinglot: siteData['parkinglot'] ?? false,
        );
        setState(() {
          _campingSites.add(site);
          _filteredCampingSites.add(site);
        });
      });
    }
  }

  void _updateCameraPosition(NLatLng position) {
    // 카메라 위치 업데이트
    _mapController?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: position, zoom: 15),
    );
  }

  void _addMarker(CarCampingSite site) {
    // 마커 추가
    final marker = NMarker(
      id: site.name,
      position: NLatLng(site.latitude, site.longitude),
      caption: NOverlayCaption(text: site.name),
      icon: NOverlayImage.fromAssetImage('assets/images/camping_site.png'),
      size: Size(30, 30),
    );
    _mapController?.addOverlay(marker);
  }

  void _filterCampingSites() {
    // 차박지 필터링
    setState(() {
      _filteredCampingSites.clear();
      for (var site in _campingSites) {
        if ((showRestRoom && site.restRoom) ||
            (showSink && site.sink) ||
            (showCook && site.cook) ||
            (showAnimal && site.animal) ||
            (showWater && site.water) ||
            (showParkinglot && site.parkinglot)) {
          _filteredCampingSites.add(site);
        }
      }
    });
  }

  void _applyFilter() {
    // 필터 적용
    setState(() {
      _filterCampingSites();
    });
  }

  Widget _buildFilterSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    // 필터 스위치 빌드
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Color(0xFF162233),
    );
  }

  void _showFilterDialog(BuildContext context) {
    // 필터 다이얼로그 표시
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('필터링'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFilterSwitch('공중화장실', showRestRoom, (value) {
                    setState(() {
                      showRestRoom = value;
                    });
                  }),
                  _buildFilterSwitch('개수대', showSink, (value) {
                    setState(() {
                      showSink = value;
                    });
                  }),
                  _buildFilterSwitch('취사', showCook, (value) {
                    setState(() {
                      showCook = value;
                    });
                  }),
                  _buildFilterSwitch('반려동물', showAnimal, (value) {
                    setState(() {
                      showAnimal = value;
                    });
                  }),
                  _buildFilterSwitch('수돗물', showWater, (value) {
                    setState(() {
                      showWater = value;
                    });
                  }),
                  _buildFilterSwitch('주차장', showParkinglot, (value) {
                    setState(() {
                      showParkinglot = value;
                    });
                  }),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _applyFilter();
                Navigator.pop(context);
              },
              child: Text('적용'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    // 현재 위치 가져오기
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    NLatLng currentPosition = NLatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocationMarker = NMarker(
        id: 'current_location',
        position: currentPosition,
        caption: NOverlayCaption(text: '현재 위치'),
        icon: NOverlayImage.fromAssetImage('assets/images/지도.png'),
        size: Size(30, 30),
      );
      _mapController?.addOverlay(_currentLocationMarker!);
      _updateCameraPosition(currentPosition);
    });
  }

  void _scrapCampingSpot(CarCampingSite site) async {
    // 차박지 스크랩
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userScrapsRef = FirebaseDatabase.instance.ref().child('scraps').child(user.uid);
      DataSnapshot snapshot = await userScrapsRef.get();

      bool alreadyScrapped = false;
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          if (value['name'] == site.name &&
              value['latitude'] == site.latitude &&
              value['longitude'] == site.longitude) {
            alreadyScrapped = true;
          }
        });
      }

      if (alreadyScrapped) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미 스크랩한 차박지입니다.')),
        );
      } else {
        String newScrapKey = userScrapsRef.push().key!;
        await userScrapsRef.child(newScrapKey).set({
          'name': site.name,
          'latitude': site.latitude,
          'longitude': site.longitude,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('차박지를 스크랩했습니다.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.')),
      );
    }
  }

  void _shareCampingSpot(CarCampingSite site) {
    // 차박지 공유
    final _nicknameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('공유할 사용자 닉네임 입력'),
          content: TextField(
            controller: _nicknameController,
            decoration: InputDecoration(labelText: '닉네임'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final nickname = _nicknameController.text;
                if (nickname.isNotEmpty) {
                  DatabaseReference nicknamesRef = FirebaseDatabase.instance.ref().child('nicknames');
                  DataSnapshot snapshot = await nicknamesRef.child(nickname).get();
                  if (snapshot.exists) {
                    String userId = snapshot.value as String;
                    DatabaseReference sharedScrapsRef = FirebaseDatabase.instance
                        .ref()
                        .child('shared_scraps')
                        .child(userId);
                    String newShareKey = sharedScrapsRef.push().key!;
                    await sharedScrapsRef.child(newShareKey).set({
                      'name': site.name,
                      'latitude': site.latitude,
                      'longitude': site.longitude,
                      'imageUrl': site.imageUrl,
                      'restRoom': site.restRoom,
                      'sink': site.sink,
                      'cook': site.cook,
                      'animal': site.animal,
                      'water': site.water,
                      'parkinglot': site.parkinglot,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('차박지를 공유했습니다.')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('닉네임이 존재하지 않습니다.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('닉네임을 입력하세요.')),
                  );
                }
              },
              child: Text('공유'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 지역 페이지 빌드
    return Scaffold(
      appBar: AppBar(
        title: Text('차박지 리스트'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context); // 필터 다이얼로그 표시
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(35.83840532, 128.5603346),
                zoom: 10,
              ),
            ),
            onMapReady: (controller) {
              _mapController = controller; // 지도 컨트롤러 초기화
              for (var site in _campingSites) {
                _addMarker(site); // 마커 추가
              }
            },
          ),
          SlidingUpPanel(
            controller: _panelController,
            panelSnapping: true,
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            panel: Stack(
              children: [
                ListView.builder(
                  itemCount: _filteredCampingSites.length,
                  itemBuilder: (context, index) {
                    final site = _filteredCampingSites[index];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xFF162233), width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(site.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (site.restRoom) Text('공중화장실'),
                              if (site.sink) Text('개수대'),
                              if (site.cook) Text('취사'),
                              if (site.animal) Text('반려동물'),
                              if (site.water) Text('수돗물'),
                              if (site.parkinglot) Text('주차장'),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => _scrapCampingSpot(site),
                                    child: Text('스크랩'),
                                  ),
                                  TextButton(
                                    onPressed: () => _shareCampingSpot(site),
                                    child: Text('공유'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            _updateCameraPosition(NLatLng(site.latitude, site.longitude)); // 카메라 위치 업데이트
                          },
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: FloatingActionButton(
                    backgroundColor: Color(0xFF162233),
                    onPressed: () {
                      if (_panelController.isPanelOpen) {
                        _panelController.close();
                      } else {
                        _panelController.open();
                      }
                    },
                    child: Icon(Icons.list, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            top: 80,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF162233),
              onPressed: _getCurrentLocation, // 현재 위치 가져오기
              heroTag: 'regionPageHeroTag',
              child: Icon(Icons.gps_fixed, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
