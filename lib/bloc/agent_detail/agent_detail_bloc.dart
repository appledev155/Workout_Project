import 'dart:async';
import 'package:anytimeworkout/model/agent_detail.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:anytimeworkout/config.dart' as app_instance;
part 'agent_detail_event.dart';
part 'agent_detail_state.dart';

// final dynamic durationTime = dotenv.env['THROTTLEDURATION'];
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AgentDetailBloc extends Bloc<AgentDetailEvent, AgentDetailState> {
  AgentDetailBloc() : super(const AgentDetailState()) {
    on<AgentDetailFetched>(_onAgentDetailFetch,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onAgentDetailFetch(
      AgentDetailFetched event, Emitter<AgentDetailState> emit) async {
    try {
      final agentDetail =
          await app_instance.itemApiProvider.agentDetail(event.userId);
      emit(state.copyWith(
          agentDetailStatus: AgentDetailStatus.success,
          agentDetail: agentDetail));
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
    }
  }
}
