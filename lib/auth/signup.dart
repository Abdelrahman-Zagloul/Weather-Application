import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_app1/component/customedlogo.dart';
import 'package:weather_app1/component/customedtextfiel.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isloading = false;
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.purple.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Customedlogo(name: "image/weather.jpg"),
                      const SizedBox(height: 30),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Join us to explore the weather app 🚀",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      const SizedBox(height: 25),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formState,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name", style: _labelStyle()),
                                const SizedBox(height: 10),
                                Customedtextfiel(
                                  obscureText: false,
                                  controller: name,
                                  text: "Your Name",
                                  validator: (val) {
                                    if (val == "") return "Please enter your name";
                                    return null;
                                  },
                                  decoration: _inputDecoration("Name"),
                                ),
                                const SizedBox(height: 20),
                                Text("Email", style: _labelStyle()),
                                const SizedBox(height: 10),
                                Customedtextfiel(
                                  obscureText: false,
                                  controller: email,
                                  text: "Your Email",
                                  validator: (val) {
                                    if (val == "") return "Please enter your email";
                                    return null;
                                  },
                                  decoration: _inputDecoration("Email"),
                                ),
                                const SizedBox(height: 20),
                                Text("Password", style: _labelStyle()),
                                const SizedBox(height: 10),
                                Customedtextfiel(
                                  obscureText: _obscureText,
                                  controller: password,
                                  text: "Your Password",
                                  validator: (val) {
                                    if (val == "") return "Please enter your password";
                                    return null;
                                  },
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    icon: Icon(
                                      _obscureText ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  decoration: _inputDecoration("Password"),
                                ),
                                const SizedBox(height: 20),
                                Text("Confirm Password", style: _labelStyle()),
                                const SizedBox(height: 10),
                                Customedtextfiel(
                                  obscureText: _obscureConfirmText,
                                  controller: confirmPassword,
                                  text: "Confirm Password",
                                  validator: (val) {
                                    if (val != password.text) return "Passwords do not match";
                                    return null;
                                  },
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmText = !_obscureConfirmText;
                                      });
                                    },
                                    icon: Icon(
                                      _obscureConfirmText ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  decoration: _inputDecoration("Confirm Password"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        minWidth: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 4,
                        color: Colors.deepPurple.shade700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        onPressed: () async {
                          if (formState.currentState!.validate()) {
                            setState(() => isloading = true);
                            try {
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
                            } on FirebaseAuthException catch (e) {
                              setState(() => isloading = false);
                              String errorMessage;
                              if (e.code == 'weak-password') {
                                errorMessage = "Password is too weak.";
                              } else if (e.code == 'email-already-in-use') {
                                errorMessage = "Email already in use.";
                              } else {
                                errorMessage = "Error: ${e.message}";
                              }

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: errorMessage,
                                btnOkOnPress: () {},
                              ).show();
                            }
                          }
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "login");
                        },
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black87, fontSize: 16),
                            children: [
                              const TextSpan(text: "Already have an account? "),
                              TextSpan(
                                text: "Login",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey[900],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(color: Colors.grey[500]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.deepPurple.shade400, width: 2),
      ),
    );
  }
}
