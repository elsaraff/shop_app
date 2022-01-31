import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/functions.dart';
import 'package:shop_app/login/cubit/login_cubit.dart';
import 'package:shop_app/login/cubit/login_states.dart';

import 'package:shop_app/core/cache_helper.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/register/register_screen.dart';
import 'package:shop_app/shop/shop_layout.dart';
import 'package:shop_app/widgets/custom_text_form_field.dart';
import 'package:shop_app/widgets/show_toast.dart';

var formKey = GlobalKey<FormState>();
var emailController = TextEditingController();
var passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (
          context,
          state,
        ) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status == true) {
              showToast(
                  text: state.loginModel.message, state: ToastStates.SUCCESS);
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data.token)
                  .then((value) {
                token = state.loginModel.data.token;
                navigateAndFinish(context, const ShopLayout());
                //emailController.clear();
                passwordController.clear();
              });

              //debugPrint(state.loginModel.message.toString());
              //debugPrint('welcome ' + state.loginModel.data.name.toString());
              //debugPrint(state.loginModel.data.token.toString());
            } else //login state = false
            {
              showToast(
                  text: state.loginModel.message, state: ToastStates.ERROR);

              //debugPrint(state.loginModel.message.toString());
            }
          }
          if (state is ShopLoginIntialState) {
            debugPrint('THE STATE IS $state');
          }
          if (state is ShopLoginLoadingState) {
            debugPrint('THE STATE IS $state');
          }
          if (state is ShopLoginSuccessState) {
            debugPrint('THE STATE IS $state');
          }
          if (state is ShopLoginErrorState) {
            debugPrint('THE STATE IS $state AND THE error IS ${state.error}');
          }
        },
        builder: (context, state) {
          var shopLoginCubit = ShopLoginCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Login',
                            style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        const SizedBox(height: 20.0),
                        const Text('Login now to browse our hot offers.',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.grey)),
                        const SizedBox(height: 60.0),
                        customTextFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Email is Empty";
                              }
                              return null;
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined),
                        const SizedBox(height: 20.0),
                        customTextFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            isPassword: shopLoginCubit.isPassword,
                            onSubmit: (value) {
                              if (formKey.currentState.validate()) {
                                shopLoginCubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "password is Empty";
                              }
                              return null;
                            },
                            label: 'Password',
                            prefix: Icons.lock,
                            suffix: shopLoginCubit.suffix,
                            suffixPressed: () {
                              shopLoginCubit.changePasswordVisibility();
                            }),
                        const SizedBox(height: 20.0),
                        ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState,
                            builder: (context) => Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: double.infinity,
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (formKey.currentState.validate()) {
                                        shopLoginCubit.userLogin(
                                            email: emailController.text,
                                            password: passwordController.text);
                                      }
                                    },
                                    child: const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                  ),
                                ),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator())),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have account ?',
                              style: TextStyle(fontSize: 20),
                            ),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, const RegisterScreen());
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
