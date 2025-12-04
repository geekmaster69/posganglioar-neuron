import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:candy_tracker/features/store/domain/domain.dart';
import 'package:go_router/go_router.dart';
import 'package:candy_tracker/config/config.dart';

import 'package:candy_tracker/features/shared/shared.dart';
import 'package:candy_tracker/features/store/presentation/providers/providers.dart';

class CandyLocationFormScreen extends ConsumerWidget {
  final int id;
  const CandyLocationFormScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candyLocationState$ = ref.watch(candyLocationProvider(id));
    return candyLocationState$.when(
      data: (data) => _CandyLocationForm(data),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text(error.toString()))),
      loading: () => const FullScreenLoader(),
    );
  }
}

class _CandyLocationForm extends ConsumerWidget {
  final CandyLocation candyLocation;
  const _CandyLocationForm(this.candyLocation);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candyLocationFormState = ref.watch(
      candyLocationFormProvider(candyLocation),
    );
    final candyLocationFormNotifier = ref.read(
      candyLocationFormProvider(candyLocation).notifier,
    );

    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(candyLocationFormState.title.value),
        actions: [
          IconButton(
            onPressed: () async {
              final path = await CameraPlugin().takePhoto();
              if (path == null) return;
              candyLocationFormNotifier.toggleImage(path);
            },
            icon: const Icon(Icons.add_a_photo_outlined),
          ),
          IconButton(
            onPressed: () async {
              final path = await CameraPlugin().selectPhoto();

              if (path == null) return;
              candyLocationFormNotifier.toggleImage(path);
            },
            icon: const Icon(Icons.add_photo_alternate_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: ImagesSlider(
                  images: candyLocationFormState.images
                      .map((e) => e.url)
                      .toList(),
                  onTap: (path) => candyLocationFormNotifier.toggleImage(path),
                ),
              ),
              SwitchListTile(
                title: const Text('Lugar activo'),
                subtitle: const Text('La ubicacion esta activa?'),
                value: candyLocationFormState.isActive,
                onChanged: candyLocationFormNotifier.onActiveStateCHange,
              ),
              CustomTextFormField(
                errorMessage: (candyLocationFormState.wasTouch)
                    ? candyLocationFormState.title.errorMessage
                    : null,
                textCapitalization: TextCapitalization.words,
                initialValue: candyLocationFormState.title.value,
                hint: 'Titulo',
                label: 'Titulo de la ubicacion',
                onChanged: candyLocationFormNotifier.onTitleChange,
              ),
              CustomTextFormField(
                errorMessage: (candyLocationFormState.wasTouch)
                    ? candyLocationFormState.description.errorMessage
                    : null,
                minLines: 4,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                initialValue: candyLocationFormState.description.value,
                hint: 'Descripcion',
                label: 'Descripcion',
                onChanged: candyLocationFormNotifier.onDescriptionChange,
              ),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                  side: BorderSide(
                    color:
                        (!candyLocationFormState.wasTouch ||
                            candyLocationFormState.locationIsValid)
                        ? Colors.transparent
                        : colors.error,
                  ),
                ),

                child: ListTile(
                  title: const Text('Seleccionar ubicacion'),
                  subtitle: Text(
                    candyLocationFormState.latitude.isValid
                        ? 'Ubicacion seleccionada'
                        : 'Sin ubicacion',
                  ),
                  leading: const Icon(Icons.map_outlined),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await showBottomSheetLocation(
                      context,
                      selectCenter: (latLng) {
                        candyLocationFormNotifier.onLocationChange(
                          latLng.latitude,
                          latLng.longitude,
                        );
                      },
                    );
                  },
                ),
              ),

              const ListTile(
                title: Text('Porcentaje de dulces'),
                visualDensity: VisualDensity.compact,
              ),

              SizedBox(
                width: double.maxFinite,
                child: SegmentedButton(
                  showSelectedIcon: false,
                  segments: [
                    const ButtonSegment(value: 0, label: Text('0%')),
                    const ButtonSegment(value: 25, label: Text('25%')),
                    const ButtonSegment(value: 50, label: Text('50%')),
                    const ButtonSegment(value: 75, label: Text('75%')),
                    const ButtonSegment(value: 100, label: Text('100%')),
                  ],
                  selected: {candyLocationFormState.quantity},
                  onSelectionChanged: (value) {
                    candyLocationFormNotifier.onQuantityChange(value.first);
                  },
                ),
              ),

              Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        const Text('Promociones'),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Agrege una promocion'),
                                content: CustomTextFormField(
                                  errorMessage: candyLocationFormState
                                      .promotion
                                      .errorMessage,
                                  label: 'Promocion',
                                  hint:
                                      '20% de descuento a quien si llega disfrasado',
                                  onChanged: candyLocationFormNotifier
                                      .onPromotionChange,
                                ),
                                actions: [
                                  FilledButton.icon(
                                    onPressed: () {
                                      candyLocationFormNotifier.addPromotion();
                                      context.pop();
                                    },
                                    label: const Text('Guardar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    ...candyLocationFormState.promotions.map(
                      (e) => ListTile(
                        title: Text(e),
                        leading: const Icon(Icons.circle),

                        trailing: IconButton(
                          onPressed: () {
                            candyLocationFormNotifier.removePromotions(e);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: double.maxFinite,
                child: FilledButton.icon(
                  onPressed: () =>
                      candyLocationFormNotifier.onFormSubmit().then((value) {
                        if (value && context.mounted) {
                          Navigator.pop(context);
                        }
                      }),
                  label: const Text('Guardar'),
                  icon: candyLocationFormState.isSending
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(color: Colors.green),
                        )
                      : const Icon(Icons.save_outlined),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
