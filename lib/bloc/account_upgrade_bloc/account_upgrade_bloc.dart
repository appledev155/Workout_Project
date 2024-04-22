import 'dart:async';

import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

part 'account_upgrade_event.dart';
part 'account_upgrade_state.dart';

class AccountUpgradeBloc
    extends Bloc<AccountUpgradeEvent, AccountUpgradeState> {
  AccountUpgradeBloc() : super(const AccountUpgradeState()) {
    on<PostAccountUpgrade>(_onPostAccountUpgrade);
    on<CheckAccountUpgradeVerification>(_onCheckVerification);
  }

  Future<void> _onPostAccountUpgrade(
      PostAccountUpgrade event, Emitter<AccountUpgradeState> emit) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    dynamic userID = currentUser.id.toString();
    dynamic token = currentUser.token.toString();
    try {
      Map<String, Object> jsonData = {
        'user_id': userID,
        'token': token,
        'agency_name': event.agencyName!,
        'city': event.city!,
        'name': event.name!,
        'phone_no': event.phone!
      };

      final result = await Repository().accountUpgrade(jsonData);

      if (result['status'] == 'success') {
        emit(state.copyWith(
            status: AccountUpgradeStatus.success, message: result['message']));
      } else {
        emit(state.copyWith(
            status: AccountUpgradeStatus.failure, message: result['message']));
      }
    } catch (_, e) {
      print(e);
      print(_);
    }
  }

  _onCheckVerification(CheckAccountUpgradeVerification event,
      Emitter<AccountUpgradeState> emit) async {
    emit(state.copyWith(status: AccountUpgradeStatus.loading));
    try {
      UserModel currentUser = await app_instance.utility.jwtUser();
      dynamic userID = currentUser.id.toString();
      dynamic token = currentUser.token.toString();
      Map<String, Object> jsonData = {"user_id": userID, 'token': token};
      final result = await Repository().checkAccountVerification(jsonData);
      if (result['status'] == 'false') {
        emit(state.copyWith(
            status: AccountUpgradeStatus.verificationFailure,
            message: result['message']));
      } else {
        emit(state.copyWith(
            status: AccountUpgradeStatus.verificationSuccess,
            message: result['message']));
      }
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
    }
  }
}
