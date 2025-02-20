import 'package:blood_bank_app/presentation/resources/constatns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../cubit/maps_cubit/maps_cubit.dart';
import '../cubit/search_cubit/search_cubit.dart';
import '../widgets/search/search_options.dart';
import '../widgets/search/search_result.dart';
import 'search_map_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);
  static const String routeName = 'search';

  @override
  Widget build(BuildContext context) {
    print("search refresh");
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث عن دم'),
        // backgroundColor: Colors.white,
        // foregroundColor: ColorManager.primary,
        elevation: 0,
      ),
      body: BlocConsumer<MapsCubit, MapsState>(
        listener: (context, state) {
          if (state is MapsSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SearchMapPage(),
              ),
            );
          }
        },
        builder: (context, state) => ModalProgressHUD(
          inAsyncCall: (state is MapsLoading),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      // topLeft: Radius.circular(30),
                      // topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: SearchOptions(),
                ),
              ),
              const Expanded(
                child: SearchResult(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return (state is SearchSuccess)
              ? FloatingActionButton(
                  child: const Icon(Icons.place_outlined),
                  onPressed: () async {
                    BlocProvider.of<MapsCubit>(context).showMaps(
                      stateDonors: state.stateDonors,
                      selectedBloodType: BlocProvider.of<SearchCubit>(context)
                              .selectedBloodType ??
                          "O-",
                    );
                  },
                )
              : const SizedBox();
        },
      ),
    );
  }
}
