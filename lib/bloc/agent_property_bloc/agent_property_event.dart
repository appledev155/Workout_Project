part of 'agent_property_bloc.dart';

@immutable
abstract class AgentPropertyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AgentPropertyFetched extends AgentPropertyEvent {
  final String? buyRentType, propertyType, algoliaCacheKey;
  final int? propertyTypeId, userId;
  final int? getpropertyAreaUnit;
  AgentPropertyFetched(
      {this.userId,
      this.buyRentType,
      this.propertyType,
      this.propertyTypeId,
      this.getpropertyAreaUnit,
      this.algoliaCacheKey});
}

class ResetAgentProperty extends AgentPropertyEvent {}
