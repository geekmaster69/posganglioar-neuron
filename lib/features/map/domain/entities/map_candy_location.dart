class MapCandyLocation {
  final int id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final int quantity;
  final List<String> storeImages;
  final List<String> promotions;

  MapCandyLocation({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.quantity,
    required this.storeImages,
    required this.promotions,
  });

  factory MapCandyLocation.fromJson(Map<String, dynamic> json) =>
      MapCandyLocation(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        promotions: List<String>.from(json["promotions"].map((x) => x)),
        quantity: json["quantity"],
        storeImages: List<String>.from(
          json["storeImages"].map((x) => StoreImage.fromJson(x).url),
        ),
      );
}

class StoreImage {
  final String url;

  StoreImage({required this.url});

  factory StoreImage.fromJson(Map<String, dynamic> json) =>
      StoreImage(url: json["url"]);

  Map<String, dynamic> toJson() => {"url": url};
}
