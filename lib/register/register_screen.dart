import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/core/cache_helper.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/register/cubit/register_cubit.dart';
import 'package:shop_app/register/cubit/register_state.dart';
import 'package:shop_app/shop/shop_layout.dart';
import 'package:shop_app/widgets/custom_text_form_field.dart';
import 'package:shop_app/widgets/show_toast.dart';

import '../functions.dart';

var formKey = GlobalKey<FormState>();
var nameController = TextEditingController();
var emailController = TextEditingController();
var phoneController = TextEditingController();
var passwordController = TextEditingController();

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              if (state.loginModel.status == true) {
                showToast(
                    text: state.loginModel.message, state: ToastStates.SUCCESS);
                CacheHelper.saveData(
                        key: 'token', value: state.loginModel.data.token)
                    .then((value) {
                  token = state.loginModel.data.token;
                  navigateAndFinish(context, const ShopLayout());
                  nameController.clear();
                  emailController.clear();
                  phoneController.clear();
                  passwordController.clear();
                });

                //debugPrint(state.loginModel.message.toString());
                //debugPrint('welcome ' + state.loginModel.data.name.toString());
                //debugPrint(state.loginModel.data.token.toString());
              } else //login state = false
              {
                showToast(
                    text: state.loginModel.message, state: ToastStates.ERROR);

                debugPrint(state.loginModel.message.toString());
              }
            }
          },
          builder: (context, state) {
            var registerCubit = RegisterCubit.get(context);

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const Text('Register',
                              style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          const SizedBox(height: 20.0),
                          const Text('Register now Don\'t waste your Time.',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.grey)),
                          const SizedBox(height: 40.0),
                          customTextFormField(
                              controller: nameController,
                              type: TextInputType.text,
                              validate: (value) {
                                if (value.isEmpty) {
                                  return "Name is empty ";
                                }
                                return null;
                              },
                              label: 'Name',
                              prefix: Icons.person),
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 10),
                          customTextFormField(
                              controller: phoneController,
                              type: TextInputType.phone,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return "Phone is Empty";
                                }
                                return null;
                              },
                              label: 'Phone Number',
                              prefix: Icons.phone),
                          const SizedBox(height: 10),
                          customTextFormField(
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              isPassword: registerCubit.isPassword,
                              validate: (value) {
                                if (value.isEmpty) {
                                  return 'Password is  empty';
                                }
                                return null;
                              },
                              label: 'Password',
                              prefix: Icons.lock,
                              suffix: registerCubit.suffix,
                              suffixPressed: () {
                                registerCubit.changePasswordVisibility();
                              }),
                          const SizedBox(height: 20),
                          ConditionalBuilder(
                            condition: state is! RegisterLoadingState,
                            builder: (context) => Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.red),
                              child: MaterialButton(
                                child: const Text(
                                  'Register',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    registerCubit.userRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        password: passwordController.text);
                                  }
                                },
                              ),
                            ),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
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
      ),
    );
  }
}
