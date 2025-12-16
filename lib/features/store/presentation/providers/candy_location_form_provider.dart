import 'package:candy_tracker/features/shared/shared.dart';
import 'package:candy_tracker/features/store/domain/domain.dart';
import 'package:candy_tracker/features/store/presentation/providers/candys_locations_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final candyLocationFormProvider = NotifierProvider.autoDispose
    .family<CandyLocationFormNotifier, CandyLocationFormState, CandyLocation>(
      CandyLocationFormNotifier.new,
    );

class CandyLocationFormNotifier extends Notifier<CandyLocationFormState> {
  final CandyLocation candyLocation;

  CandyLocationFormNotifier(this.candyLocation);
  @override
  CandyLocationFormState build() {
    return CandyLocationFormState(
      isActive: candyLocation.isActive,
      title: StringInput.dirty(candyLocation.title),
      description: StringInput.dirty(candyLocation.description),
      quantity: candyLocation.quantity,
      promotions: candyLocation.promotions,
      latitude: DoubleInput.dirty(candyLocation.latitude),
      longitude: DoubleInput.dirty(candyLocation.longitude),
      images: candyLocation.storeImages,
    );
  }

  void onTitleChange(String value) {
    final title = StringInput.dirty(value);
    state = state.copyWith(title: title, isValid: Formz.validate([title]));
  }

  void onDescriptionChange(String value) {
    final description = StringInput.dirty(value);

    state = state.copyWith(
      description: description,
      isValid: Formz.validate([description]),
    );
  }

  void onQuantityChange(int value) {
    state = state.copyWith(quantity: value);
  }

  void onActiveStateCHange(bool value) {
    state = state.copyWith(isActive: !state.isActive);
  }

  void onPromotionChange(String value) {
    final promotion = StringInput.dirty(value);

    state = state.copyWith(promotion: promotion);
  }

  void addPromotion() {
    if (state.promotion.value.isEmpty) return;
    state = state.copyWith(
      promotions: [...state.promotions, state.promotion.value],
    );
    state = state.copyWith(promotion: const StringInput.pure());
  }

  void removePromotions(String value) {
    final promotions = state.promotions
        .where((element) => element != value)
        .toList();

    state = state.copyWith(promotions: promotions);
  }

  void togglePromotions(String promotion) {
    final isOnList = state.promotions.any((element) => element == promotion);

    if (isOnList) {
      final promotions = state.promotions
          .where((element) => element != promotion)
          .toList();

      state = state.copyWith(promotions: promotions);
    } else {
      state = state.copyWith(promotions: [...state.promotions, promotion]);
    }
  }

  void onLocationChange(double lat, double lng) {
    final latitude = DoubleInput.dirty(lat);
    final longitude = DoubleInput.dirty(lng);

    state = state.copyWith(
      latitude: latitude,
      longitude: longitude,
      isValid: Formz.validate([latitude, longitude]),
    );
  }

  void toggleImage(String path) {
    final isOnList = state.images.any((element) => element.url == path);

    if (isOnList) {
      final images = state.images
          .where((element) => element.url != path)
          .toList();
      state = state.copyWith(images: images);
    } else {
      state = state.copyWith(
        images: [
          ...state.images,
          StoreImage(url: path),
        ],
      );
    }
  }

  Future<bool> onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return false;
    state = state.copyWith(isSending: true);
    final data = {
      'id': candyLocation.id == -1 ? null : candyLocation.id,
      'title': state.title.value,
      'description': state.description.value,
      'isActive': state.isActive,
      'latitude': state.latitude.value,
      'promotions': state.promotions,
      'quantity': state.quantity,
      'longitude': state.longitude.value,
      'images': state.images.map((e) => e.toMap()).toList(),
    };

    final result = await ref
        .read(candiesLocationsProvider.notifier)
        .createUpdateCandyLocation(data);
    state = state.copyWith(isSending: true);

    return result;
  }

  void _touchEveryField() {
    final title = StringInput.dirty(state.title.value);
    final description = StringInput.dirty(state.description.value);
    final latitude = DoubleInput.dirty(state.latitude.value);
    final longitude = DoubleInput.dirty(state.longitude.value);

    state = state.copyWith(
      wasTouch: true,
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      isValid: Formz.validate([title, description, latitude, longitude]),
    );
  }
}

class CandyLocationFormState {
  final bool isActive;
  final bool isValid;
  final bool wasTouch;
  final bool isSending;
  final StringInput title;
  final StringInput description;
  final StringInput promotion;
  final int quantity;
  final List<String> promotions;
  final DoubleInput latitude;
  final DoubleInput longitude;
  final List<StoreImage> images;

  CandyLocationFormState({
    this.isValid = false,
    this.wasTouch = false,
    this.isSending = false,
    this.promotion = const StringInput.pure(),
    required this.isActive,
    required this.title,
    required this.description,
    required this.quantity,
    required this.promotions,
    required this.latitude,
    required this.longitude,
    required this.images,
  });

  CandyLocationFormState copyWith({
    bool? isActive,
    bool? isValid,
    bool? wasTouch,
    bool? isSending,
    StringInput? title,
    StringInput? description,
    StringInput? promotion,
    int? quantity,
    List<String>? promotions,
    DoubleInput? latitude,
    DoubleInput? longitude,
    List<StoreImage>? images,
  }) {
    return CandyLocationFormState(
      isActive: isActive ?? this.isActive,
      isValid: isValid ?? this.isValid,
      wasTouch: wasTouch ?? this.wasTouch,
      isSending: isSending ?? this.isSending,
      title: title ?? this.title,
      description: description ?? this.description,
      promotion: promotion ?? this.promotion,
      quantity: quantity ?? this.quantity,
      promotions: promotions ?? this.promotions,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      images: images ?? this.images,
    );
  }

  bool get locationIsValid => latitude.isValid && longitude.isValid;
}
