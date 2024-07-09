import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/components/bloc/auth_bloc.dart';
import 'package:todo_list/routes/screens.dart';

// Local imports
import 'package:todo_list/utils/build_text.dart';
import 'package:todo_list/utils/font_sizes.dart';
import 'package:todo_list/components/build_text_field.dart';
import 'package:todo_list/utils/color_palette.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  print('LoginSuccess: Navigating to home screen');
                  Navigator.of(context).pushNamed(Screens.home);
                }

                if (state is LoginFailure) {
                  print('LoginFailure: ${state.error}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: kRedColor,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      buildText('Email', kBlackColor, textMedium, FontWeight.bold,
                          TextAlign.start, TextOverflow.clip),
                      const SizedBox(height: 10),
                      BuildTextField(
                          hint: 'Email',
                          inputType: TextInputType.emailAddress,
                          controller: email,
                          onChange: (value) {},
                          fillColor: kWhiteColor),
                      const SizedBox(height: 20),
                      buildText('Password', kBlackColor, textMedium,
                          FontWeight.bold, TextAlign.start, TextOverflow.clip),
                      const SizedBox(height: 10),
                      BuildTextField(
                          hint: 'Password',
                          inputType: TextInputType.visiblePassword,
                          controller: password,
                          onChange: (value) {},
                          fillColor: kWhiteColor),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(LoginEvent(
                                      email: email.text, password: password.text));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 20),
                                  child: buildText(
                                      'Login',
                                      kWhiteColor,
                                      textMedium,
                                      FontWeight.bold,
                                      TextAlign.center,
                                      TextOverflow.clip)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
