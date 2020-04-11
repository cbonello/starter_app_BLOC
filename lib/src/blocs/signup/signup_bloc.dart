import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:starter_app/src/repositories/authentication_repository.dart';
import 'package:starter_app/src/utils/exceptions.dart';
import 'package:starter_app/src/utils/validators.dart';

part 'signup_bloc.freezed.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({@required AuthenticationRepository authRepository})
      : _authRepository = authRepository;

  final AuthenticationRepository _authRepository;

  @override
  SignUpState get initialState => SignUpState.empty();

  @override
  Stream<SignUpState> transformEvents(
    Stream<SignUpEvent> events,
    Stream<SignUpState> Function(SignUpEvent event) next,
  ) {
    final Stream<SignUpEvent> observableStream = events;

    final Stream<SignUpEvent> nonDebounceStream =
        observableStream.where((SignUpEvent event) {
      return event is! _EmailChanged && event is! _PasswordChanged;
    });
    final Stream<SignUpEvent> debounceStream =
        observableStream.where((SignUpEvent event) {
      return event is _EmailChanged || event is _PasswordChanged;
    }).debounceTime(const Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith(<Stream<SignUpEvent>>[debounceStream]),
      next,
    );
  }

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    yield* event.when(
      emailChanged: (String email) => _mapEmailChangedToState(email),
      passwordChanged: (String password) => _mapPasswordChangedToState(password),
      submitted: (String email, String password) =>
          _mapFormSubmittedToState(email, password),
    );
  }

  Stream<SignUpState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: isValidEmail(email),
      isPasswordValid: state.isPasswordValid,
      user: state.user,
    );
  }

  Stream<SignUpState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isEmailValid: state.isEmailValid,
      isPasswordValid: isValidPassword(password),
      user: state.user,
    );
  }

  Stream<SignUpState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield SignUpState.signingUp();
    try {
      final FirebaseUser user = await _authRepository.signUp(
        email: email,
        password: password,
      );
      yield SignUpState.emailSent(user: user);
    } catch (exception) {
      yield SignUpState.failure(
        exceptionRaised: AppException.from(exception as Exception),
      );
    }
  }
}
