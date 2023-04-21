import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_bloc/blocs/auth/auth_bloc.dart';
import 'package:firebase_auth_bloc/blocs/signin/signin_cubit.dart';
import 'package:firebase_auth_bloc/pages/home_page.dart';
import 'package:firebase_auth_bloc/pages/signin_page.dart';
import 'package:firebase_auth_bloc/pages/signup_page.dart';
import 'package:firebase_auth_bloc/pages/splash_page.dart';
import 'package:firebase_auth_bloc/repositories/auth_repository.dart';
import 'package:firebase_auth_bloc/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'blocs/profile/profile_cubit.dart';
import 'blocs/signup/signup_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseAuth: FirebaseAuth.instance),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: ((context) => AuthBloc(
                  authRepository:
                      RepositoryProvider.of<AuthRepository>(context),
                )),
          ),
          BlocProvider<SigninCubit>(
            create: ((context) => SigninCubit(
                  authRepository:
                      RepositoryProvider.of<AuthRepository>(context),
                )),
          ),
          BlocProvider<SignupCubit>(
            create: ((context) => SignupCubit(
                  authRepository:
                      RepositoryProvider.of<AuthRepository>(context),
                )),
          ),
          BlocProvider<ProfileCubit>(
            create: ((context) => ProfileCubit(
                  profileRepository:
                      RepositoryProvider.of<ProfileRepository>(context),
                )),
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashPage(),
          routes: {
            SignupPage.routeName: (context) => SignupPage(),
            SigninPage.routeName: (context) => SigninPage(),
            HomePage.routeName: (context) => HomePage(),
          },
        ),
      ),
    );
  }
}
