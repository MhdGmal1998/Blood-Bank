import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../core/utils.dart';
import '../../domain/entities/blood_center.dart';
import '../cubit/signup_cubit/signup_cubit.dart';
import '../resources/color_manageer.dart';
import '../resources/constatns.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../widgets/common/my_stepper.dart' as my_stepper;
import '../widgets/forms/my_outlined_icon_button.dart';
import '../widgets/forms/my_text_form_field.dart';
import 'home_page.dart';

class SignUpCenter extends StatefulWidget {
  const SignUpCenter({Key? key}) : super(key: key);
  static const String routeName = "sign-up-center";

  @override
  State<SignUpCenter> createState() => _SignUpCenterState();
}

class _SignUpCenterState extends State<SignUpCenter> {
  final GlobalKey<FormState> _firstFormState = GlobalKey<FormState>();
  final GlobalKey<FormState> _secondFormState = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      nameController = TextEditingController(),
      phoneController = TextEditingController(),
      stateNameController = TextEditingController(),
      districtController = TextEditingController(),
      neighborhoodController = TextEditingController();

  final double stepContentHeight = 200.0;
  int _activeStepIndex = 0;
  bool isPasswordHidden = true;

  Future<void> _submit() async {
    FormState? formData = _secondFormState.currentState;
    if (formData!.validate()) {
      BloodCenter newCenter = BloodCenter(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        phone: phoneController.text,
        state: stateNameController.text,
        district: districtController.text,
        neighborhood: neighborhoodController.text,
        image: "",
        lastUpdate: "",
        lat: "",
        lon: "",
        token: "",
        status: "ACTIVE",
        aPlus: 0,
        aMinus: 0,
        bPlus: 0,
        bMinus: 0,
        abPlus: 0,
        abMinus: 0,
        oPlus: 0,
        oMinus: 0,
      );
      BlocProvider.of<SignUpCubit>(context).signUpCenter(
        center: newCenter,
      );
    }
  }

  bool isFirstStep() => _activeStepIndex == 0;

  bool isLastStep() => _activeStepIndex == stepList().length - 1;

  FormState? currentFormState() {
    if (_activeStepIndex == 0) {
      return _firstFormState.currentState;
    } else if (_activeStepIndex == 1) {
      return _secondFormState.currentState;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('إنشاء حساب مركز طبي'),
          centerTitle: true,
        ),
        body: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
          child: BlocConsumer<SignUpCubit, SignupState>(
              listener: (context, state) {
            if (state is SignUpSuccess) {
              Utils.showSuccessSnackBar(
                  context: context, msg: AppStrings.signUpSuccessMessage);
              Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            } else if (state is SignUpFailure) {
              Utils.showFalureSnackBar(context: context, msg: state.error);
            }
          }, builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: (state is SignupLoading),
              child: my_stepper.Stepper(
                svgPictureAsset: "assets/images/blood_drop.svg",
                iconColor: Theme.of(context).primaryColor,
                elevation: 0,
                type: my_stepper.StepperType.horizontal,
                currentStep: _activeStepIndex,
                steps: stepList(),
                onStepContinue: _onStepContinue,
                onStepCancel: _onStepCancel,
                onStepTapped: _onStepTapped,
                controlsBuilder: (BuildContext context,
                    my_stepper.ControlsDetails controls) {
                  return _buildNavigationButtons(context, controls);
                },
              ),
            );
          }),
        ));
  }

  Container _buildNavigationButtons(
    BuildContext context,
    my_stepper.ControlsDetails controls,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p20),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: AppSize.s60,
              ),
              if (!isFirstStep())
                Positioned(
                  right: AppSize.s20,
                  child: SizedBox(
                    width: AppSize.s140,
                    child: MyOutlinedIconButton(
                      onPressed: controls.onStepCancel,
                      borderColor: Theme.of(context).primaryColor,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text(
                        AppStrings.signUpPreviousButton,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: AppSize.s20),
              Positioned(
                left: AppSize.s20,
                child: SizedBox(
                  width: AppSize.s140,
                  child: (isLastStep())
                      ? MyOutlinedIconButton(
                          icon: Text(
                            AppStrings.signUpCreateButton,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: ColorManager.success),
                          ),
                          label: const Icon(
                            Icons.check_rounded,
                            color: ColorManager.success,
                          ),
                          onPressed: _submit,
                          borderColor: ColorManager.success,
                        )
                      : MyOutlinedIconButton(
                          icon: Text(
                            AppStrings.signUpNextButton,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                          ),
                          label: Icon(
                            Icons.arrow_forward,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: _validateForm,
                          borderColor: Theme.of(context).colorScheme.secondary,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<my_stepper.Step> stepList() => <my_stepper.Step>[
        firstStep(),
        secondStep(),
      ];

  my_stepper.Step firstStep() {
    return my_stepper.Step(
      state: _activeStepIndex <= 0
          ? my_stepper.StepState.editing
          : my_stepper.StepState.complete,
      isActive: _activeStepIndex >= 0,
      title: Text(AppStrings.signUpFirstStepTitle,
          style: _activeStepIndex >= 0
              ? Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).primaryColor)
              : Theme.of(context).textTheme.bodySmall),
      content: SizedBox(
        height: signUpStepHight,
        child: Form(
          key: _firstFormState,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppMargin.m20),
                child: MyTextFormField(
                  hint: AppStrings.signUpCenterNameHint,
                  controller: nameController,
                  blurrBorderColor: ColorManager.lightGrey,
                  focusBorderColor: ColorManager.secondary,
                  fillColor: ColorManager.white,
                  validator: _nameValidator,
                  icon: const Icon(Icons.local_hospital_outlined),
                  keyBoardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: AppSize.s20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppMargin.m20),
                child: MyTextFormField(
                  hint: AppStrings.signUpEmailHint,
                  controller: emailController,
                  blurrBorderColor: ColorManager.lightGrey,
                  focusBorderColor: ColorManager.secondary,
                  fillColor: ColorManager.white,
                  validator: _emailValidator,
                  icon: const Icon(Icons.email),
                  keyBoardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: AppSize.s20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: MyTextFormField(
                  hint: AppStrings.signUpPasswordHint,
                  controller: passwordController,
                  isPassword: isPasswordHidden,
                  blurrBorderColor: ColorManager.lightGrey,
                  focusBorderColor: ColorManager.secondary,
                  fillColor: ColorManager.white,
                  validator: _passwordValidator,
                  icon: IconButton(
                    icon: _buildPasswordIcon(),
                    onPressed: _toggleIsPasswordVisible,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  my_stepper.Step secondStep() {
    return my_stepper.Step(
      state: _activeStepIndex <= 1
          ? my_stepper.StepState.editing
          : my_stepper.StepState.complete,
      isActive: _activeStepIndex >= 1,
      title: Text(AppStrings.signUpThirdStepTitle,
          style: _activeStepIndex >= 1
              ? Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).primaryColor)
              : Theme.of(context).textTheme.bodySmall),
      content: SizedBox(
        height: signUpStepHight,
        child: Form(
          key: _secondFormState,
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
                    color: ColorManager.white,
                    border: Border.all(
                      color: ColorManager.lightGrey,
                      width: 1,
                    ),
                  ),
                  dropDownPadding: const EdgeInsets.all(AppPadding.p12),
                  spaceBetween: AppSize.s20,
                  disabledDropdownDecoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: ColorManager.grey1,
                    border: Border.all(
                      color: ColorManager.grey1,
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
                  selectedItemStyle: Theme.of(context).textTheme.headlineLarge,
                  dropdownHeadingStyle: Theme.of(context).textTheme.titleMedium,
                  dropdownItemStyle: Theme.of(context).textTheme.titleMedium,
                  dropdownDialogRadius: AppRadius.r10,
                  searchBarRadius: AppRadius.r10,
                  onStateChanged: _onStateChange,
                  onCityChanged: _onCityChanged,
                ),
              ),
              // TODO add neighborhood TextFormField
              const SizedBox(height: AppSize.s20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppMargin.m20),
                child: MyTextFormField(
                  hint: AppStrings.signUpNeighborhoodHint,
                  controller: neighborhoodController,
                  blurrBorderColor: ColorManager.lightGrey,
                  focusBorderColor: ColorManager.secondary,
                  fillColor: ColorManager.white,
                  icon: const Icon(Icons.my_location_outlined),
                  validator: _neighborhoodValidator,
                ),
              ),
              const SizedBox(height: AppSize.s20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppMargin.m20),
                child: MyTextFormField(
                  hint: AppStrings.signUpPhoneHint,
                  controller: phoneController,
                  blurrBorderColor: ColorManager.lightGrey,
                  focusBorderColor: ColorManager.secondary,
                  fillColor: ColorManager.white,
                  icon: const Icon(Icons.call),
                  validator: _phoneNumberValidator,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateForm({int? stepIndex}) {
    FormState? formData = currentFormState();
    if (_activeStepIndex == 2 && districtController.text == "") {
      Fluttertoast.showToast(msg: AppStrings.signUpStateCityValidator);
    } else {
      if (formData!.validate()) {
        formData.save();
        if (stepIndex == null) {
          setState(() => _activeStepIndex++);
        } else {
          setState(() => _activeStepIndex = stepIndex);
        }
      }
    }
  }

  void _onStepTapped(int index) {
    _validateForm(stepIndex: index);
  }

  void _onStepCancel() {
    if (isFirstStep()) {
      return;
    }
    setState(() => _activeStepIndex -= 1);
  }

  void _onStepContinue() {
    if (_activeStepIndex < (stepList().length - 1)) {
      setState(() {
        _activeStepIndex += 1;
      });
    }
  }

  Icon _buildPasswordIcon() {
    return Icon(isPasswordHidden
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined);
  }

  Text buildDonorDetail(String detail) {
    return Text(
      detail,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
    );
  }

  void _onCityChanged(value) {
    if (value != null) {
      districtController.text = value;
    }
  }

  void _onStateChange(value) {
    if (value != null) {
      stateNameController.text = value;
    }
  }

  _toggleIsPasswordVisible() {
    setState(() => isPasswordHidden = !isPasswordHidden);
  }

  String? _nameValidator(String? value) =>
      (value!.length < minCharsOfName) ? AppStrings.signUpNameValidator : null;

  String? _emailValidator(value) =>
      value != null && EmailValidator.validate(value)
          ? null
          : AppStrings.signUpEmailValidator;

  String? _passwordValidator(value) => (value!.length < minCharsOfPassword)
      ? AppStrings.firebasePasswordValidatorError
      : null;

  String? _phoneNumberValidator(String? value) {
    String pattern = r"^\+?7[0|1|3|7|8][0-9]{7}$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return AppStrings.signUpPhoneValidator;
    } else {
      return null;
    }
  }

  String? _neighborhoodValidator(value) {
    if (value!.length < 2) {
      return AppStrings.signUpNeighborhoodValidator;
    }
    return null;
  }
}
