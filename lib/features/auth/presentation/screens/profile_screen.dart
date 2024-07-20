import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:progress_soft_app/core/widgets/loading_widget.dart';

import '../../../../core/features/settings/presentation/bloc/settings_bloc.dart';
import '../../../../core/strings/texts.dart';
import '../../../../core/utils/snak_bar_message.dart';
import '../../../../core/utils/validation_patterns.dart';
import '../../domain/entities/app_user.dart';
import '../bloc/auth_bloc.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'JO');

  String? _selectedGender;
  DateTime _selectedDate = DateTime.now();

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    _emailController.text = context.read<AuthBloc>().appUser.email ?? '';
    _fullNameController.text = context.read<AuthBloc>().appUser.fullName ?? '';
    _mobileController.text = context.read<AuthBloc>().appUser.mobileNumber ?? '';
    _selectedDate = context.read<AuthBloc>().appUser.dateBirth ??  DateTime.now();
    _selectedGender = context.read<AuthBloc>().appUser.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoggedOut) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }

          if (state is ProfileUpdated) {
            SnackBarMessage().showSuccessSnackBar(message: "Profile Updated!", context: context);
          }
        },
        builder: (context, state) {
          return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              final mobileConfig = settingsState.regexPatterns['mobileNumber'];
              final fullNameConfig = settingsState.regexPatterns['fullName'];

              List<String> countryCodes = settingsState.countries;

              return Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration:  const InputDecoration(
                              border: OutlineInputBorder()),
                          enabled: false,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            errorMaxLines: 3,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'required field';
                            } else if (!RegExp(fullNameConfig?.pattern ??
                                    NAME_VALIDATION_PATTERN)
                                .hasMatch(value ?? '')) {
                              return fullNameConfig?.errorMessage ??
                                  NAME_VALIDATION_ERROR_MEG;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            setState(() {
                              this.number = number;
                            });
                          },
                          initialValue: number,
                          countries: countryCodes,
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            showFlags: true,
                            setSelectorButtonAsPrefixIcon: true,
                            trailingSpace: false,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          textFieldController: _mobileController,
                          formatInput: false,
                          keyboardType: TextInputType.phone,
                          inputBorder: const OutlineInputBorder(),
                          validator: (_) {
                            if ((number.phoneNumber ?? '').isEmpty) {
                              return 'required field';
                            } else if (!RegExp(mobileConfig?.pattern ??
                                    MOBILE_VALIDATION_PATTERN)
                                .hasMatch((number.phoneNumber ?? ''))) {
                              return mobileConfig?.errorMessage ??
                                  MOBILE_VALIDATION_ERROR_MEG;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null &&
                                pickedDate != _selectedDate) {
                              setState(() {
                                _selectedDate = pickedDate;
                              });
                            }
                          },
                          controller: TextEditingController(
                            text:
                                DateFormat('yyyy-MM-dd').format(_selectedDate),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your date of birth';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          items: _genders.map((gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          decoration: const InputDecoration(
                              labelText: 'Gender',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        if(state is UpdatingProfile)
                          const LoadingWidget()
                        else
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                BlocProvider.of<AuthBloc>(context).add(UpdateProfile(
                                  AppUser(
                                    email: _emailController.text,
                                    gender: _selectedGender,
                                    fullName: _fullNameController.text,
                                    mobileNumber: _mobileController.text,
                                    dateBirth: _selectedDate,
                                  )
                                ));
                              }
                            },
                            child: const Text('Update')),

                        const SizedBox(height: 20),

                        if(state is LoggingOut)
                          const LoadingWidget()
                        else if (state is LoggedOut)
                          const SizedBox.shrink()
                        else
                        ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context).add(LogOut());
                            },
                            child: const Text('Logout')),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }
}
