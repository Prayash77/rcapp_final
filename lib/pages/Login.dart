import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rcapp/pages/loadingspinner.dart';
import 'package:rcapp/services/auth.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<String> photos = ["assets/delivery-man.png", "assets/login.png"];

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  // test field state
  String number = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Widget logincarousel = Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        height: 180.0,
        child: new Carousel(
          boxFit: BoxFit.contain,
          images: [
            AssetImage('assets/login1.PNG'),
            AssetImage('assets/login2.PNG'),
            AssetImage('assets/login3.PNG'),
          ],
          autoplay: true,
          dotSize: 0,
          dotBgColor: Colors.transparent,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 2000),
          borderRadius: true,
          indicatorBgPadding: 10.0,
        ));
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepOrange,
              title: Text('Sign in'),
              elevation: 0.0,
              // actions: <Widget>[
              //   FlatButton.icon(
              //     icon: Icon(Icons.person),
              //     label: Text('Register'),
              //     onPressed: () {
              //       widget.toggleView();
              //     },
              //   )
              // ]
            ),
            body: SingleChildScrollView(
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              height: 250.0,
                              width: 370.0,
                              child: logincarousel),
                          SizedBox(height: 18.0),
                          TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: 'Personal Number',
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepOrange, width: 1.0),
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepOrange, width: 3.0),
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (val) => val.isEmpty
                                  ? 'Enter Your RSP Personal Number'
                                  : null,
                              onChanged: (val) {
                                setState(() => number = val);
                              }),
                          SizedBox(height: 20.0),
                          TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepOrange, width: 1.0),
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepOrange, width: 3.0),
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (val) => val.length < 6
                                  ? 'Enter password of 6+ characters'
                                  : null,
                              obscureText: true,
                              onChanged: (val) {
                                setState(() => password = val);
                              }),
                          SizedBox(height: 20.0),
                          RaisedButton(
                            color: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            child: Text(
                              'Login',
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                String numemail = number + "@gmail.com";
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        numemail, password);
                                if (result == null) {
                                  setState(() {
                                    error =
                                        'could not sign in with the credentials';
                                    loading = false;
                                  });
                                }
                              }
                            },
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            error,
                            style: GoogleFonts.inter(color: Colors.red, fontSize: 14.0),
                          ),
                          SizedBox(height: 15.0),
                          /*Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Or, If you are a new user, ',
                                  style: GoogleFonts.inter(
                                      color: Colors.deepOrange, fontSize: 15),
                                ),
                                InkWell(
                                  onTap: () {
                                    widget.toggleView();
                                  },
                                  child: Text('Register',
                                      style: GoogleFonts.inter(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                          fontSize: 15)),
                                )
                              ])*/
                        ]),
                  )),
            ),
          );
  }
}
