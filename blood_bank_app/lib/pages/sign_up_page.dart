import 'package:blood_bank_app/models/donor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../cubit/signup_cubit/signup_cubit.dart';
import '../style.dart';
import '../widgets/forms/my_outlined_icon_button.dart';
import '../widgets/forms/my_dropdown_button_form_field.dart';
import '../widgets/forms/my_text_form_field.dart';
import '../widgets/forms/my_checkbox_form_field.dart';
import '../pages/sing_up_center_page.dart';
import '../models/my_stepper.dart' as my_stepper;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String routeName = "sign-up";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _firstFormState = GlobalKey<FormState>();
  final GlobalKey<FormState> _secondFormState = GlobalKey<FormState>();
  final GlobalKey<FormState> _thirdFormState = GlobalKey<FormState>();
  final GlobalKey<FormState> _fourthFormState = GlobalKey<FormState>();

  String? selectedGovernorate, selectedDistrict;
  String? email,
      password,
      name,
      phone,
      bloodType,
      stateName,
      district,
      neighborhood;

  final double stepContentHeight = 300.0;
  int _activeStepIndex = 0;
  bool didConfirm = false;

  final List<String> bloodTypes = const <String>[
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-"
  ];

  Future submit() async {}

  bool isFirstStep() => _activeStepIndex == 0;

  bool isLastStep() => _activeStepIndex == stepList().length - 1;

  void validating() {
    FormState? formData = _firstFormState.currentState;
    if (_activeStepIndex == 0) {
      if (formData!.validate()) {
        formData.save();
        setState(() => _activeStepIndex++);
      }
    } else if (_activeStepIndex == 1) {
      FormState? formData = _secondFormState.currentState;
      if (formData!.validate()) {
        formData.save();
        setState(() => _activeStepIndex++);
      }
    } else if (_activeStepIndex == 2) {
      FormState? formData = _thirdFormState.currentState;
      if (district == null) {
        print('object');
        Fluttertoast.showToast(msg: 'يجب اختيار المحافظة والمديرية');
      } else {
        print(district);
        if (formData!.validate()) {
          formData.save();
          setState(() => _activeStepIndex++);
        }
      }
    } else {
      setState(() => _activeStepIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب متبرع'),
        centerTitle: true,
      ),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            Fluttertoast.showToast(msg: 'تم إنشاء حساب بنجاح');
            Navigator.of(context).pop();
          } else if (state is SignupFailure) {
            Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: (state is SignupLoading),
            child: my_stepper.Stepper(
              svgPictureAsset: "assets/images/blood_drop.svg",
              iconColor: Theme.of(context).primaryColor,
              elevation: 0,
              type: my_stepper.StepperType.horizontal,
              currentStep: _activeStepIndex,
              steps: stepList(),
              onStepContinue: () {
                if (_activeStepIndex < (stepList().length - 1)) {
                  setState(() {
                    _activeStepIndex += 1;
                  });
                }
              },
              onStepCancel: () {
                if (isFirstStep()) {
                  return;
                }
                setState(() => _activeStepIndex -= 1);
              },
              onStepTapped: (int index) {
                setState(() {
                  _activeStepIndex = index;
                });
              },
              controlsBuilder:
                  (BuildContext context, my_stepper.ControlsDetails controls) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                          ),
                          if (!isFirstStep())
                            Positioned(
                              right: 20,
                              child: SizedBox(
                                width: 140,
                                child: MyOutlinedIconButton(
                                  onPressed: controls.onStepCancel,
                                  borderColor: Colors.orange,
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.orange,
                                  ),
                                  label: const Text(
                                    'السابق',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 20),
                          Positioned(
                            left: 20,
                            child: SizedBox(
                              width: 140,
                              child: (isLastStep())
                                  ? MyOutlinedIconButton(
                                      icon: const Text(
                                        'إنشاء',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                      label: const Icon(
                                        Icons.check_rounded,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        FormState? formData =
                                            _fourthFormState.currentState;
                                        if (formData!.validate()) {
                                          BlocProvider.of<SignupCubit>(context)
                                              .signUp(
                                                  donor: Donor(
                                                    email: email!,
                                                    password: password!,
                                                    name: name!,
                                                    phone: phone!,
                                                    bloodType: bloodType!,
                                                    state: stateName!,
                                                    district: district!,
                                                    neighborhood: neighborhood!,
                                                    image: '',
                                                    brithDate: '',
                                                  ),
                                                  password: password!);
                                        }
                                      },
                                      borderColor: Colors.green,
                                    )
                                  : MyOutlinedIconButton(
                                      icon: const Text(
                                        'التالي',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      label: const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.blue,
                                      ),
                                      onPressed: validating,
                                      borderColor: Colors.blue,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      isFirstStep()
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: const Text(
                                  "إنشاء حساب كمركز طبي",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      SignUpCenter.routeName);
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     FormState? formData = _firstFormState.currentState;
      //     if (formData!.validate()) {
      //     } else {
      //       print("Not Valid");
      //     }
      //   },
      // ),
    );
  }

  List<my_stepper.Step> stepList() => <my_stepper.Step>[
        firstStep(),
        secondSetp(),
        thirdStep(),
        fourthStep(),
      ];

  my_stepper.Step firstStep() {
    return my_stepper.Step(
      state: _activeStepIndex <= 0
          ? my_stepper.StepState.editing
          : my_stepper.StepState.complete,
      isActive: _activeStepIndex >= 0,
      title: const Text("حسابك", style: TextStyle(fontSize: 12)),
      content: SizedBox(
        height: stepContentHeight,
        child: Form(
          key: _firstFormState,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "بخطواتـك هذه قد تـنـقـذ حيـاة إنــسان",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: MyTextFormField(
                  hint: "بريدك الإلكتروني",
                  hintStyle: eHintStyle,
                  blurrBorderColor: Colors.white,
                  focusBorderColor: eTextFieldFocusBorder,
                  fillColor: eTextFieldFill,
                  onSave: (value) {
                    email = value;
                  },
                  validator: (value) =>
                      value != null && EmailValidator.validate(value)
                          ? null
                          : "اكتب بريد إيميل صحيح",
                  icon: const Icon(Icons.email),
                  keyBoardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: MyTextFormField(
                  hint: "أنشئ كلمة مرور",
                  hintStyle: eHintStyle,
                  blurrBorderColor: Colors.white,
                  focusBorderColor: eTextFieldFocusBorder,
                  fillColor: eTextFieldFill,
                  isPassword: true,
                  onSave: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value!.length < 6) {
                      return "يجب أن يكون طول كلمة المرور ستة أو أكثر";
                    }
                    return null;
                  },
                  icon: const Icon(Icons.password),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  my_stepper.Step secondSetp() {
    return my_stepper.Step(
      state: _activeStepIndex <= 1
          ? my_stepper.StepState.editing
          : my_stepper.StepState.complete,
      isActive: _activeStepIndex >= 1,
      title: const Text("بياناتك", style: TextStyle(fontSize: 12)),
      content: SizedBox(
        height: stepContentHeight,
        child: Form(
          key: _secondFormState,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: MyTextFormField(
                  hint: "اسمك",
                  hintStyle: eHintStyle,
                  blurrBorderColor: Colors.white,
                  focusBorderColor: eTextFieldFocusBorder,
                  fillColor: eTextFieldFill,
                  onSave: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value!.length < 2) {
                      return "لا يمكن أن يكون الاسم أقل من حرفين";
                    }
                    return null;
                  },
                  icon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: MyTextFormField(
                  hint: "رقم هاتفك",
                  hintStyle: eHintStyle,
                  blurrBorderColor: Colors.white,
                  focusBorderColor: eTextFieldFocusBorder,
                  fillColor: eTextFieldFill,
                  onSave: (value) {
                    phone = value;
                  },
                  validator: (value) {
                    if (value!.length != 9) {
                      return "يجب أن يكون عدد الأرقام 9";
                    }
                    return null;
                  },
                  icon: const Icon(Icons.phone_android),
                  keyBoardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: MyDropdownButtonFormField(
                  hint: "فصيلة دمك",
                  validator: (value) {
                    return (value == null) ? 'يرجى اختيار فصيلة الدم' : null;
                  },
                  value: bloodType,
                  hintColor: eTextColor,
                  items: bloodTypes,
                  blurrBorderColor: Colors.white,
                  focusBorderColor: eTextFieldFocusBorder,
                  fillColor: eTextFieldFill,
                  icon: const Icon(Icons.bloodtype_outlined),
                  onChange: (value) => setState(() => bloodType = value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  my_stepper.Step thirdStep() {
    return my_stepper.Step(
      state: _activeStepIndex <= 2
          ? my_stepper.StepState.editing
          : my_stepper.StepState.complete,
      isActive: _activeStepIndex >= 2,
      title: const Text("عنوانك", style: TextStyle(fontSize: 12)),
      content: SizedBox(
        height: stepContentHeight,
        child: Form(
          key: _thirdFormState,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: CSCPicker(
                  layout: Layout.vertical,
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
                  // dropDownMargin: const EdgeInsets.symmetric(vertical: 4),
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
                  onStateChanged: (value) {
                    stateName = value;
                  },
                  onCityChanged: (value) {
                    district = value;
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: MyTextFormField(
                  hint: "المنطقة",
                  hintStyle: eHintStyle,
                  blurrBorderColor: Colors.white,
                  focusBorderColor: eTextFieldFocusBorder,
                  fillColor: eTextFieldFill,
                  icon: const Icon(Icons.my_location_outlined),
                  onSave: (value) {
                    neighborhood = value;
                  },
                  validator: (value) {
                    if (value!.length < 2) {
                      return "يرجى كتابة قريتك أو حارتك";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  my_stepper.Step fourthStep() {
    return my_stepper.Step(
      state: my_stepper.StepState.complete,
      isActive: _activeStepIndex >= 3,
      title: const Text("تأكيد", style: TextStyle(fontSize: 12)),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: stepContentHeight,
        child: Column(
          children: [
            Wrap(
              children: [
                buildDonorDetail(
                  key: "اسم المتبرع",
                  value: name ?? '',
                ),
                buildDonorDetail(
                  key: "رقم الهاتف",
                  value: phone ?? '',
                ),
                buildDonorDetail(
                  key: "فصيلة الدم",
                  value: bloodType ?? '',
                ),
                buildDonorDetail(
                  key: "العنوان",
                  value:
                      '${stateName ?? ''} - ${district ?? ''} - ${neighborhood ?? ''}',
                ),
                buildDonorDetail(
                  key: "البريد الإلكتروني",
                  value: email ?? '',
                ),
              ],
            ),
            Form(
              key: _fourthFormState,
              child: MyCheckboxFormField(
                title: Row(
                  children: [
                    const Text("أوافق على "),
                    GestureDetector(
                      child: const Text(
                        "سياسات الخصوصية",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                onSaved: (value) {},
                validator: (value) => !value! ? "يجب أن تؤكد موافقتك" : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildDonorDetail({
    required String key,
    required String value,
  }) {
    return SizedBox(
      height: 28,
      child: Wrap(
        children: [
          Text(
            "$key:  ",
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
    );
  }
}
