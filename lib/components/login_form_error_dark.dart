import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginFormErrorDark extends StatelessWidget {
  const LoginFormErrorDark({
    Key key,
    @required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index])),
    );
  }

  Container formErrorText({String error}) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 20, 5),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/Error.svg",
            height: 14,
            width: 14,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            error,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
