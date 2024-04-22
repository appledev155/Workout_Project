part of 'account_upgrade_bloc.dart';

abstract class AccountUpgradeEvent extends Equatable {
  const AccountUpgradeEvent();

  @override
  List<Object> get props => [];
}

class PostAccountUpgrade extends AccountUpgradeEvent {
  final String? agencyName;
  final String? city;
  final String? name;
  final String? phone;

  const PostAccountUpgrade({this.agencyName, this.city, this.name, this.phone});
}

class CheckAccountUpgradeVerification extends AccountUpgradeEvent {
  const CheckAccountUpgradeVerification();
}
