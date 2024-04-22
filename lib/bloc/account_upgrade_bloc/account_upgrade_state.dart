part of 'account_upgrade_bloc.dart';

enum AccountUpgradeStatus {
  initial,
  loading,
  success,
  failure,
  verificationSuccess,
  verificationFailure
}

class AccountUpgradeState extends Equatable {
  final AccountUpgradeStatus? status;
  final String? message;

  const AccountUpgradeState(
      {this.status = AccountUpgradeStatus.initial, this.message = ''});

  AccountUpgradeState copyWith(
          {AccountUpgradeStatus? status, String? message}) =>
      AccountUpgradeState(
          status: status ?? this.status, message: message ?? this.message);

  @override
  List<Object> get props => [status!, message!];
}
