import 'package:flutter/material.dart';

String animatedSplash = "/AnimatedSplashScreen",
    loginScreen = "/LoginScreen",
    adminDashboard = "/AdminDashboard",
    employeeDashboardScreen = "/EmployeeDashboardScreen",
    forgotPassword = "/ForgotPassword";

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please enter your email";
const String kInvalidEmailError = "Please enter valid mail";
const String kPassNullError = "Please enter your password";
const String kConfirmedPasswordNullError = "Please confirm password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNameNullError = "Please enter your name";
const String kPhoneNumberNullError = "Please enter your phone number";
const String kAddressNullError = "Please enter your address";

const String nameNullError = "Please enter task name";
const String subjectNullError = "Please enter task subject";
const String textNullError = "Please enter task body";
const String signatureNullError = "Please enter your signature";

const String employeeNameNullError = "Please enter employee name";
const String emailNullError = "Please enter email";
const String companyNameNullError = "Please enter company name";
const String additionalInfoNullError = "Please enter additional info";

const String from = "Arnab Kumar Mandol";
const String to = "Rajiur Rahman";
const String email = "compacy@gmail.com";
const String subject = "Email Subject";
const String body =
    "Arrival report \n\n 24-08-2021 at 23:00 arrived Koper roads 24-08-2021 at 23:30 anchor down\n\nTugs: 0\nDraft on arrival:\nAft: 8,00 m\nFore: 8,00 m";
const String signature =
    "_ _\nBest Regards\nJone Dou\nAddress: Pristaniska 12, 6000 Koper Slovenia";

const kPrimaryLightColor = Color(0xFF000000);
const kSecondaryLightColor = Color(0xFF25f8fb);
const textFieldBackgroundColor = Color(0xFF242526);
const signatureBackgroundColor = Color(0xFF707070);
const listItemColor = Color(0xFF242526);
const textColor = Color(0xFF9B9FA2);
const divider = Color(0xFF686868);
const avatarBgColor = Color(0xFF9B9FA2);
const bgColor = Color(0xFF18191a);
const red = Color(0xFFdd1203);
const historyTextColor = Color(0xFF8d8f92);
const historyTitleColor = Color(0xFFb1b1b1);

buildLoading(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kSecondaryLightColor),
                ),
            );
        });
}
