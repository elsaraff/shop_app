import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/functions.dart';
import 'package:shop_app/search/cubit/search_cubit.dart';
import 'package:shop_app/search/cubit/search_state.dart';
import 'package:shop_app/theme/cubit/theme_cubit.dart';
import 'package:shop_app/widgets/build_item.dart';
import 'package:shop_app/widgets/custom_text_form_field.dart';

var formKey = GlobalKey<FormState>();
var searchController = TextEditingController();

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          bool isLightMode = ThemeCubit.get(context).isLightMode;
          var searchCubit = SearchCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      customTextFormField(
                          controller: searchController,
                          type: TextInputType.text,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return "Search is Empty";
                            }
                            return null;
                          },
                          label: 'Search',
                          prefix: Icons.search,
                          onSubmit: (String text) {
                            searchCubit.search(text.toString());
                          }),
                      const SizedBox(height: 15.0),
                      if (state is SearchLoadingState)
                        const LinearProgressIndicator(),
                      const SizedBox(height: 15.0),
                      if (state is SearchSuccessState)
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) => buildListProduct(
                                  SearchCubit.get(context)
                                      .model
                                      .data
                                      .data[index],
                                  isLightMode,
                                  context,
                                  isFavorites: false),
                              separatorBuilder: (context, index) => myDivider(),
                              itemCount: SearchCubit.get(context)
                                  .model
                                  .data
                                  .data
                                  .length),
                        ),
                    ],
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
