import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:cafe_hollywood/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpPage extends StatefulWidget {
  final bool isSignUp;
  SignUpPage(this.isSignUp);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? _warning;
  String? _name;
  String? _phone;
  final formKey = GlobalKey<FormState>();

  bool validate() {
    final form = formKey.currentState;
    form!.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: new NestedScrollView(
          physics: ScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                title: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    widget.isSignUp ? 'Sign Up' : 'Log In',
                    style: TextStyle(fontSize: 28, color: Colors.black),
                  ),
                ),
                floating: false,
                // toolbarHeight: 80,
                // forceElevated: true,
                pinned: true,

                // snap: false,
              ),
            ];
          },
          body: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Column(
              children: <Widget>[
                SizedBox(height: _height * 0.025),
                showAlert(),
                SizedBox(height: _height * 0.05),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: buildInputs(),
                    ),
                  ),
                ),
                Container(
                  width: _width / 3,
                  height: 40,
                  child: BlackButton(widget.isSignUp ? 'Sign Up' : 'Log In',
                      handleSignUp, true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleSignUp() async {
    if (validate()) {
      try {
        final auth = AuthService();

        var result = await auth.createUserWithPhone(_phone!, _name!, context);
        if (_phone == "" || result == "error") {
          setState(() {
            _warning = "Your phone number could not be validated";
          });
        }
      } catch (e) {
        setState(() {
          _warning = e.toString();
        });
      }
    }
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning!,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    // if were in the sign up state add name
    if (widget.isSignUp) {
      textFields.add(
        TextFormField(
          validator: (String? value) {
            if (value == null) null;

            if (value!.isEmpty) "Name can't be empty";

            if (value.length < 2) "Name must be at least 2 characters long";

            if (value.length > 50) "Name must be less than 50 characters long";

            if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value))
              null;
          },
          style: TextStyle(fontSize: 20.0),
          decoration: buildSignUpInputDecoration("Enter Your Name"),
          onSaved: (value) => _name = value,
        ),
      );
      textFields.add(SizedBox(height: 20));
    }

    textFields.add(IntlPhoneField(
      onSaved: (phone) => _phone = phone?.completeNumber,
      validator: (String? value) {
        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
        RegExp regExp = new RegExp(pattern);
        if (value?.length == 0) {
          return 'Please enter mobile number';
        } else if (!regExp.hasMatch(value!)) {
          return 'Please enter valid mobile number';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Enter Phone Number',
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
      initialCountryCode: 'CA',
      onChanged: (phone) {
        print(phone.completeNumber);
      },
    ));
    textFields.add(SizedBox(height: 20));

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

//   void onPhoneNumberChange(
//       String number, String internationalizedPhoneNumber, String isoCode) {
//     print('changing ${number}');
//     setState(() {
//       _phone = number;
//       print(internationalizedPhoneNumber);
//     });
//   }
}

class NameValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}

class PhoneValidator {
  static String? validate(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
}
