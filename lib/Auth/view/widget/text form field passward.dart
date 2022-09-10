import 'package:flutter/material.dart';
class Textformfieldpassward extends StatefulWidget {
  TextEditingController? controller;
  bool obscureText = false;
  ValueChanged<String>? onSubmitted;
  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;
  Widget? suffixIcon;
  Widget? prefixIcon;
  String? label;
  String? hintText;


  @override
  State<Textformfieldpassward> createState() => _TextformfieldpasswardState();

  Textformfieldpassward({
    this.controller,
    required this.obscureText,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.label,
    this.hintText,
  });
}

class _TextformfieldpasswardState extends State<Textformfieldpassward> {


  TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,

        onChanged: widget.onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            fillColor: Colors.white,
            filled: true,
          suffixIconConstraints: BoxConstraints(maxHeight: 30),
          hintText: widget.hintText,
          suffixIcon: IconButton(
            onPressed: (){
              setState(() {
                widget.obscureText = !widget.obscureText;
              });
              
            }, icon: widget.obscureText ?  Icon(Icons.visibility_off):Icon(Icons.visibility) ,
          ),
          prefixIcon: widget.prefixIcon,
          labelText: widget.label,
        )

    );
  }


}
