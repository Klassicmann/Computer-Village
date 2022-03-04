import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginField extends StatelessWidget {
  const LoginField(
      {@required this.controller,
      @required this.label,
      @required this.prefixicon,
      this.suffixicon,
      this.pass = false,
      this.phone = false,
      this.errorMessage});

  final TextEditingController controller;
  final String label;
  final IconData prefixicon;
  final bool pass;
  final Widget suffixicon;
  final bool phone;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.aBeeZee(fontSize: 18, color: Colors.orange),
      obscureText: pass,
      keyboardType: phone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.k2d(color: Colors.white, fontSize: 18),
        prefixIcon: Icon(
          prefixicon,
          color: Colors.lightBlue,
        ),
        suffix: suffixicon,
        hoverColor: Colors.white,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
      ),
      
      
      validator: (value) {
        if (value.isEmpty) {
          return errorMessage;
        }
      },
    );
  }
}
