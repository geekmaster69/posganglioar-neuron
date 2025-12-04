class CandyLocation {
  final int id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final int quantity;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<StoreImage> storeImages;
  final List<String> promotions;

  CandyLocation({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.quantity,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.storeImages,
    required this.promotions,
  });

  factory CandyLocation.fromJson(Map<String, dynamic> json) => CandyLocation(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    quantity: json["quantity"],
    isActive: json["isActive"],
     promotions: List<String>.from(json["promotions"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    storeImages: List<StoreImage>.from(
      json["storeImages"].map((x) => StoreImage.fromJson(x)),
    ),
  );
}

class StoreImage {
  final int? id;
  final String url;

  StoreImage({this.id, required this.url});

  factory StoreImage.fromJson(Map<String, dynamic> json) =>
      StoreImage(id: json["id"], url: json["url"]);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'url': url};
  }
}
