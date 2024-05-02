import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomTextInputField extends StatelessWidget {
  Widget? prefixIcon;
  String? labelTextStr;
  String? hintTextStr;
  String? initialValue;
  bool obscureText;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  void Function(String)? onFieldSubmitted;
  void Function()? onTap;
  TextEditingController? controller;
  Function(String? value)? validator, onSaved;
  Widget? suffixIcon;
  String? containerLabelText;
  List<TextInputFormatter>? inputFormatter;
  FocusNode? focusNode;
  int? maxLines;
  double? padding;
  Color? fillColor;

  CustomTextInputField(
      {Key? key,
      this.prefixIcon,
      this.labelTextStr,
      this.hintTextStr,
      this.initialValue,
      this.obscureText = false,
      this.keyboardType,
      this.textInputAction,
      this.controller,
      this.validator,
      this.onSaved,
      this.suffixIcon,
      this.containerLabelText,
      this.inputFormatter,
      this.focusNode,
      this.maxLines,
      this.padding,
      this.onFieldSubmitted,
      this.onTap,
      this.fillColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        containerLabelText != null
            ? Container(
                padding: EdgeInsets.only(
                    left: padding ?? 30.0, right: padding ?? 30.0),
                alignment: Alignment.topLeft,
                child: Text(
                  containerLabelText ?? "",
                  style:
                      const TextStyle(color: Color(0xFF707B81), fontSize: 16),
                ),
              )
            : const SizedBox(),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding ?? 30.0),
          child: TextFormField(
            validator: (value) => validator!(value),
            autofocus: false,
            maxLines: maxLines ?? 1,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            controller: controller,
            onSaved: (value) => onSaved!(value),
            onFieldSubmitted: onFieldSubmitted,
            initialValue: initialValue,
            cursorColor: Colors.black,
            inputFormatters: inputFormatter,
            focusNode: focusNode,
            onTap: onTap,
            decoration: InputDecoration(
                hintStyle: const TextStyle(fontSize: 15),
                filled: true,
                fillColor: fillColor ?? const Color(0xFFF4F4F4),
                hintText: hintTextStr,
                labelText: labelTextStr,
                errorStyle:
                    const TextStyle(color: Color(0xFFF14635), fontSize: 14),
                //border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                ),
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon),
          ),
        )
      ],
    );
  }
}
