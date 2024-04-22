part of 'my_request_bloc.dart';

enum MyRequestStatus {
  initial,
  failure,
  success,
  removed,
  loading,
  requestServerSyncOn,
  requestServerSyncLoading,
  requestServerSyncEnd,
  localSyncEnd,
  localSyncLoading,
  updateRequest,
  changeScreen
}

class MyRequestState extends Equatable {
  final List<RequestModel>? itemMyRequest;
  final bool? hasReachedMaxRequest;
  final int? page;
  final String? myRequestCount;
  final MyRequestStatus? status;

  const MyRequestState({
    this.itemMyRequest = const <RequestModel>[],
    this.page = 1,
    this.hasReachedMaxRequest = false,
    this.myRequestCount = '',
    this.status = MyRequestStatus.initial,
  });
  @override
  List<Object?> get props =>
      [itemMyRequest, page, hasReachedMaxRequest, status, myRequestCount];

  MyRequestState copyWith({
    List<RequestModel>? itemMyRequest,
    int? page,
    bool? hasReachedMaxRequest,
    String? myRequestCount,
    MyRequestStatus? status,
  }) {
    return MyRequestState(
        status: status ?? this.status,
        itemMyRequest: itemMyRequest ?? this.itemMyRequest,
        page: page ?? this.page,
        hasReachedMaxRequest: hasReachedMaxRequest ?? this.hasReachedMaxRequest,
        myRequestCount: myRequestCount ?? this.myRequestCount);
  }
}
/* 
@immutable
abstract class MyRequestState extends Equatable {
  const MyRequestState();

  @override
  List<Object> get props => [];
}

class MyRequestInitial extends MyRequestState {}

class MyRequestFailure extends MyRequestState {}

class MyRequestSuccess extends MyRequestState {
  final List<RequestModel>? itemMyRequest;
  final bool? hasReachedMaxRequest;
  final int? page;
  final String? myRequestCount;

  const MyRequestSuccess(
      {this.itemMyRequest,
      this.page,
      this.hasReachedMaxRequest,
      this.myRequestCount});

  MyRequestSuccess copyWith(
      {List<RequestModel>? itemMyRequest,
      int? page,
      bool? hasReachedMaxRequest,
      String? myRequestCount}) {
    return MyRequestSuccess(
        itemMyRequest: itemMyRequest ?? this.itemMyRequest,
        page: page != null ? 1 : this.page,
        hasReachedMaxRequest: hasReachedMaxRequest ?? this.hasReachedMaxRequest,
        myRequestCount: myRequestCount == null ? '0' : this.myRequestCount);
  }

  @override
  List<Object> get props =>
      [itemMyRequest!, page!, hasReachedMaxRequest!, myRequestCount!];

  @override
  String toString() =>
      'Item Sucess { itemMyRequest: ${itemMyRequest!.length}, page: $page, hasReachedMaxRequest: $hasReachedMaxRequest, myRequestCount: $myRequestCount}';
}
 */
