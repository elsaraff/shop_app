import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/functions.dart';
import 'package:shop_app/shop/cubit/shop_cubit.dart';
import 'package:shop_app/shop/cubit/shop_states.dart';
import 'package:shop_app/theme/cubit/theme_cubit.dart';
import 'package:shop_app/widgets/custom_text_form_field.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();

    var themeCubit = ThemeCubit.get(context);

    var shopCubit = ShopCubit.get(context);
    var model = ShopCubit.get(context).userModel;

    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        nameController.text = model.data.name;
        emailController.text = model.data.email;
        phoneController.text = model.data.phone;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConditionalBuilder(
              condition: model.data.name != null,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (state is ShopLoadingUpdateUserState)
                        const LinearProgressIndicator(),
                      const SizedBox(height: 25),
                      customTextFormField(
                          controller: nameController,
                          type: TextInputType.text,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return "Name is Empty";
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
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.red),
                        child: MaterialButton(
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            signOut(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.red),
                        child: MaterialButton(
                          child: const Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              shopCubit.updateUserData(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.red),
                child: MaterialButton(
                  child: const Text(
                    'Change App Mode',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    themeCubit.changeAppMode();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
