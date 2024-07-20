import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:progress_soft_app/features/auth/domain/entities/app_user.dart';
import 'package:progress_soft_app/features/auth/presentation/screens/otp_screen.dart';

import '../../../../core/features/index/presentation/screens/index_screen.dart';
import '../../../../core/features/settings/presentation/bloc/settings_bloc.dart';
import '../../../../core/strings/texts.dart';
import '../../../../core/utils/validation_patterns.dart';
import '../../../post/presentation/bloc/posts_bloc.dart';
import '../bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'JO');
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedGender;
  DateTime _selectedDate = DateTime.now();

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSent) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OtpScreen(phoneNumber: number.phoneNumber ?? '')),
            );
          }
          if (state is Registered) {
            context.read<PostsBloc>().add(FetchPostsEvent());

            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                const IndexScreen()), (Route<dynamic> route) => false);
          }
        },
        builder: (context, state) {
          return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              final emailConfig = settingsState.regexPatterns['email'];
              final passwordConfig = settingsState.regexPatterns['password'];
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
                          decoration: const InputDecoration(
                              labelText: 'Email', border: OutlineInputBorder()),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'required field';
                            } else if (!RegExp(emailConfig?.pattern ??
                                    EMAIL_VALIDATION_PATTERN)
                                .hasMatch(value ?? '')) {
                              return emailConfig?.errorMessage ??
                                  EMAIL_VALIDATION_ERROR_MEG;
                            }
                            return null;
                          },
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
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              errorMaxLines: 3),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'required field';
                            } else if (!RegExp(passwordConfig?.pattern ??
                                    PASSWORD_VALIDATION_PATTERN)
                                .hasMatch(value ?? '')) {
                              return passwordConfig?.errorMessage ??
                                  PASSWORD_VALIDATION_ERROR_MEG;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'required field';
                            } else if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ??
                                  false){
                                if (state is OtpVerified) {

                                  BlocProvider.of<AuthBloc>(context)
                                      .add(Register(
                                      appUser: AppUser(
                                        fullName: _fullNameController.text,
                                        email: _emailController.text,
                                        mobileNumber:
                                        (number.phoneNumber ?? ''),
                                        gender: _selectedGender,
                                        dateBirth: _selectedDate,
                                      ),
                                      password: _passwordController.text));

                                } else {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    SendOtp(phoneNumber: number.phoneNumber!),
                                  );
                                }
                              }
                            },
                            child: const Text('Register')),
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
}
