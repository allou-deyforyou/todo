import 'package:equatable/equatable.dart';

abstract class BlocEvent extends Equatable {
  const BlocEvent();
  @override
  List<Object?> get props => const [];
}

sealed class BlocState extends Equatable {
  const BlocState();
  @override
  List<Object?> get props => const [];
}

class InitState extends BlocState {
  const InitState();
}

class PendingState<E extends BlocEvent> extends BlocState {
  const PendingState({required this.event});
  final E event;
  @override
  List<Object?> get props => [event];
}

class SuccessState<E extends BlocEvent, T> extends BlocState {
  const SuccessState(this.data, {required this.event});
  final T data;
  final E event;
  @override
  List<Object?> get props => [data];
}

class FailureState<E extends BlocEvent> extends BlocState {
  const FailureState(this.code, {this.event, this.data});
  final String code;
  final E? event;
  final Object? data;
  @override
  String toString() {
    return '$runtimeType($code)';
  }

  @override
  int get hashCode => code.hashCode;
  @override
  bool operator ==(Object other) => other is FailureState && other.code == code;

  FailureState<S> copyWith<S extends BlocEvent>({
    required S event,
    Object? value,
    String? code,
  }) {
    return FailureState<S>(
      event: event,
      code ?? this.code,
      data: value ?? this.data,
    );
  }

  static const noAccount = FailureState('no-account');
  static const lockedAccount = FailureState('locked-account');
  static const unverifiedAccount = FailureState('unverified-account');
  static const alreadyExistedAccount = FailureState('already-existed-account');
  static const alreadyConnectedAccount = FailureState('already-connected-account');

  static const lockedDevice = FailureState('locked-device');

  static const noPin = FailureState('no-pin');
  static const checkPin = FailureState('check-pin');
  static const invalidPin = FailureState('invalid-pin');
  static const invalidOTP = FailureState('invalid-otp');
  static const expiredCode = FailureState('expired-code');
  static const invalidPhone = FailureState('invalid-phone');
  static const minimumAmounted = FailureState('minimum-amouted');
  static const noBiometrics = FailureState('no-biometrics');
  static const invalidBiometrics = FailureState('invalid-biometrics');
  static const invalidCreditCard = FailureState('invalid-creditcard');

  static const missingParams = FailureState('missing-params');
  static const forbidden = FailureState('forbidden');
  static const noData = FailureState('no-data');
  static const inPending = FailureState('in-pending');
  static const badRequest = FailureState('bad-request');
  static const noInternet = FailureState('no-internet');
  static const internalError = FailureState('internal-error');
  static const erreurCoffreRequest = FailureState('');

  static const tooRecent = FailureState('too-recent');
  static const notEnoughCard = FailureState('not-enough-card');
  static const notEnoughWallet = FailureState('not-enough-wallet');
}
