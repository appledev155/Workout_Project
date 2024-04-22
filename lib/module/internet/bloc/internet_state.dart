// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'internet_bloc.dart';

class InternetState extends Equatable {
  final ConnectionType connectionType;
  final ConnectionStatus connectionStatus;
  final double connectionSpeed;
  final bool appFirstBoot;
  // TO DO: Add connection speed

  const InternetState({
    required this.connectionType,
    required this.connectionStatus,
    required this.connectionSpeed,
    required this.appFirstBoot,
  });

  InternetState copyWith({
    ConnectionType? connectionType,
    ConnectionStatus? connectionStatus,
    double? connectionSpeed,
    bool? appFirstBoot,
  }) {
    InternetState internetState = InternetState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      connectionType: connectionType ?? this.connectionType,
      connectionSpeed: connectionSpeed ?? this.connectionSpeed,
      appFirstBoot: appFirstBoot ?? this.appFirstBoot,
    );
    return internetState;
  }

  @override
  String toString() {
    return 'InternetState { appFirstBoot: $appFirstBoot, connectionType: $connectionType, connectionStatus: $connectionStatus, connectionSpeed: $connectionSpeed }';
  }

  @override
  List<Object> get props => [
        connectionType,
        connectionStatus,
        connectionSpeed,
        appFirstBoot,
      ];
}
