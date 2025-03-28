class CampingModel {
  final String? key; // Make this nullable to avoid requiring it every time.
  final int id;
  final int campingType;
  final String region;
  bool isLike;
  bool isMasato;
  bool isDeck;
  bool isStone;
  bool isGrass;

  CampingModel({
    this.key, // Make key optional
    required this.id,
    required this.campingType,
    required this.region,
    this.isLike = false,
    this.isMasato = false,
    this.isDeck = false,
    this.isStone = false,
    this.isGrass = false,
  });
}
