import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.title,
    required this.hintText,
    required this.validator,
    required this.onSaved,
    this.initialValue,
    this.keyboardType,
    this.textCapitalization = false,
  });
  final String title;
  final String hintText;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17,
                ),
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            initialValue: initialValue,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization
                ? TextCapitalization.sentences
                : TextCapitalization.none,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.black12.withOpacity(0.05),
            ),
            validator: validator,
            onSaved: onSaved,
          ),
        ],
      ),
    );
  }
}
