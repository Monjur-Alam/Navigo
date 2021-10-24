import 'package:flutter/material.dart';
import 'package:navigo/Screen/Login/components/text_field_container.dart';

class RoundedPasswordFiled extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordFiled({Key key,this.onChanged}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.visibility,),
          hintText: "Password",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
