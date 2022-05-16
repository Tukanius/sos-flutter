import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormTextField extends StatefulWidget {
  final String? name;
  final TextEditingController? controller;
  final String? attribute;
  final String? labelText;
  final String? hintText;
  final TextInputType inputType;
  final TextInputAction? inputAction;
  final InputDecoration? decoration;
  final String? initialValue;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final Widget? prefixIcon;
  final bool obscureText;
  final bool hasObscureControl;
  final bool autoFocus;
  final bool readOnly;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final Function? onComplete;
  final String? Function(dynamic)? validator;
  final FormFieldValidator<String>? validators;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final int? maxLenght;
  final bool showCounter;
  final Function(dynamic)? onChanged;

  // ignore: use_key_in_widget_constructors
  const FormTextField(
      {Key? key,
      this.name,
      this.controller,
      this.decoration,
      this.attribute,
      this.hintText,
      this.inputType = TextInputType.visiblePassword,
      this.inputAction,
      this.initialValue,
      this.obscureText = false,
      this.hasObscureControl = false,
      this.autoFocus = false,
      this.readOnly = false,
      this.focusNode,
      this.nextFocusNode,
      this.onComplete,
      this.validator,
      this.validators,
      this.inputFormatters,
      this.textCapitalization = TextCapitalization.none,
      this.maxLenght,
      this.showCounter = true,
      this.errorText,
      this.onChanged,
      this.focus,
      this.nextFocus,
      this.prefixIcon,
      this.labelText});

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  bool isPasswordVisible = false;

  @override
  void initState() {
    isPasswordVisible = widget.hasObscureControl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      buildCounter: widget.showCounter
          ? null
          : (context, {int? currentLength, bool? isFocused, int? maxLength}) =>
              const SizedBox(),
      // attribute: widget.attribute,
      controller: widget.controller,
      autofocus: widget.autoFocus,
      focusNode: widget.focusNode,
      maxLines: 1,
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
      initialValue: widget.initialValue,
      obscureText:
          widget.hasObscureControl ? isPasswordVisible : widget.obscureText,
      readOnly: widget.readOnly,
      autocorrect: false,
      // autovalidate: false,
      // validator: widget.validators ?? [],
      validator: widget.validators ?? widget.validator,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLenght,
      onChanged: widget.onChanged,
      onEditingComplete: () {
        if (widget.nextFocusNode != null) {
          widget.nextFocusNode!.requestFocus();
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      onSubmitted: (value) {
        if (widget.onComplete is Function) {
          widget.onComplete!();
        }
      },
      style: const TextStyle(color: Colors.black, fontSize: 14),

      decoration: widget.decoration ??
          InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            labelText: widget.labelText,
            errorBorder: const OutlineInputBorder(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            filled: true,
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
            fillColor: Colors.grey.shade100,
          ),

      name: widget.name!,
    );
  }
}
