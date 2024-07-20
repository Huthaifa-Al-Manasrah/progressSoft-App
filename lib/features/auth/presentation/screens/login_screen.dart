import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_soft_app/core/strings/texts.dart';
import 'package:progress_soft_app/core/utils/validation_patterns.dart';
import 'package:progress_soft_app/core/widgets/loading_widget.dart';
import 'package:progress_soft_app/features/auth/presentation/screens/register_screen.dart';

import '../../../../core/features/index/presentation/screens/index_screen.dart';
import '../../../../core/features/settings/presentation/bloc/settings_bloc.dart';
import '../../../../core/strings/images.dart';
import '../../../../core/utils/snak_bar_message.dart';
import '../../../post/presentation/bloc/posts_bloc.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Logged) {
            context.read<PostsBloc>().add(FetchPostsEvent());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const IndexScreen()),
            );
          }
          if (state is AuthUnauthenticatedUserNotFound) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('User Not Found'),
                content: const Text('The account does not exist. Would you like to register?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            );
          }

          if(state is AuthUnauthenticatedPasswordIncorrect){
            SnackBarMessage().showErrorSnackBar(message: 'Invalid Password', context: context);
          }
          if(state is AuthUnauthenticatedTooManyAttempts){
            SnackBarMessage().showErrorSnackBar(message: 'Too many requests, please try later', context: context);
          }
          if(state is AuthError){
            SnackBarMessage().showErrorSnackBar(message: state.message, context: context);
          }
        },
        builder: (BuildContext context, AuthState state) {
         return BlocBuilder<SettingsBloc, SettingsState>(
           builder: (context, settingsState) {

             final emailConfig = settingsState.regexPatterns['email'];
             final passwordConfig = settingsState.regexPatterns['password'];
             return Padding(
               padding: const EdgeInsets.all(20),
               child: Form(
                 key: _formKey,
                 child: Center(
                   child: ListView(
                     shrinkWrap: true,
                     children: [
                       Center(
                         child: SvgPicture.asset(
                           kLogoImage,
                           width: 250,
                           fit: BoxFit.cover,
                         ),
                       ),
                       const SizedBox(height: 40),
                       TextFormField(
                         controller: _emailController,
                         decoration: const InputDecoration(
                             border: OutlineInputBorder(),
                             labelText: 'Email'),
                         validator: (value) {
                           if(value?.isEmpty ?? false){
                             return 'required field';
                           }
                           else if (!RegExp(emailConfig?.pattern ?? EMAIL_VALIDATION_PATTERN).hasMatch(value ?? '')) {
                             return emailConfig?.errorMessage ?? EMAIL_VALIDATION_ERROR_MEG;
                           }
                           return null;
                         },
                       ),
                       const SizedBox(height: 20),
                       TextFormField(
                         controller: _passwordController,
                         decoration: const InputDecoration(labelText: 'Password',
                             border: OutlineInputBorder(),
                             errorMaxLines: 3
                         ),
                         obscureText: true,
                         validator: (value) {
                           if(value?.isEmpty ?? false){
                             return 'required field';
                           }
                           else if (!RegExp(passwordConfig?.pattern ?? PASSWORD_VALIDATION_PATTERN).hasMatch(value ?? '')) {
                             return passwordConfig?.errorMessage ?? PASSWORD_VALIDATION_ERROR_MEG;
                           }
                           return null;
                         },
                       ),
                       const SizedBox(height: 20),
                       InkWell(
                           onTap: (){
                             Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => const RegisterScreen()),
                             );
                           },
                           child: const Text('Register?', style: TextStyle(decoration: TextDecoration.underline))),
                       const SizedBox(height: 20),

                       if (state is Logging)
                         const LoadingWidget()
                       else if (state is Logged)
                         const SizedBox.shrink()
                       else
                       ElevatedButton(
                         onPressed: () {
                           if (_formKey.currentState!.validate()) {
                             context.read<AuthBloc>().add(
                               Login(_emailController.text, _passwordController.text),
                             );
                           }
                         },
                         child: const Text('Login'),
                       )
                     ],
                   ),
                 ),
               ),
             );
           },
         );
        }
      ),
    );
  }
}
