import 'package:blood_bank_app/cubit/search_cubit/search_cubit.dart';
import 'package:blood_bank_app/models/blood_types.dart';
import 'package:blood_bank_app/style.dart';
import 'package:blood_bank_app/widgets/forms/my_dropdown_button_form_field.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchOptions extends StatefulWidget {
  const SearchOptions({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchOptions> createState() => _SearchOptionsState();
}

class _SearchOptionsState extends State<SearchOptions> {
  final GlobalKey<FormState> searchFormState = GlobalKey<FormState>();
  String? bloodType, state, district;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: searchFormState,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CSCPicker(
                layout: Layout.horizontal,
                showStates: true,
                showCities: true,
                flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                dropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.red[100],
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                dropDownPadding: const EdgeInsets.all(12),
                spaceBetween: 20.0,
                disabledDropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey.shade300,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                countrySearchPlaceholder: "الدولة",
                stateSearchPlaceholder: "المحافطة",
                citySearchPlaceholder: "المديرية",
                countryDropdownLabel: "الدولة",
                stateDropdownLabel: "المحافطة",
                cityDropdownLabel: "المديرية",
                defaultCountry: DefaultCountry.Yemen,
                selectedItemStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                dropdownHeadingStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                dropdownItemStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                dropdownDialogRadius: 10.0,
                searchBarRadius: 10.0,
                onCountryChanged: (value) {},
                onStateChanged: (value) {
                  state = value;
                },
                onCityChanged: (value) async {
                  district = value;
                  if (bloodType != null && value != null) {
                    BlocProvider.of<SearchCubit>(context).searchDonors(
                      state: state!,
                      district: district!,
                      bloodType: bloodType!,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: MyDropdownButtonFormField(
                hint: "فصيلة دمك",
                value: bloodType,
                items: BloodTypes.bloodTypes,
                blurrBorderColor: Colors.white,
                focusBorderColor: eTextFieldFocusBorder,
                fillColor: eSearchTextFieldFill,
                icon: const Icon(Icons.bloodtype_outlined),
                onChange: (value) async {
                  setState(() => bloodType = value);
                  if (state != null && district != null) {
                    BlocProvider.of<SearchCubit>(context).searchDonors(
                      state: state!,
                      district: district!,
                      bloodType: bloodType!,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
