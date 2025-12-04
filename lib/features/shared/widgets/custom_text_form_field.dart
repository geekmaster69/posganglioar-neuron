import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final String? errorMessage;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final void Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;
  final Widget? icon;
  final Widget? suffixIcon;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.icon,
    this.suffixIcon, this.maxLines, this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        
        textCapitalization: textCapitalization,
        onFieldSubmitted: onFieldSubmitted,
        maxLines: maxLines,
        minLines: minLines,
        textInputAction: TextInputAction.next,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: icon,
          filled: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: Colors.green,
        ),
      ),
    );
  }
}
