part of 'upload_progress_bloc.dart';

enum UploadBoxStatus { ideal, start, progress, end, failure }

class UploadBox extends Equatable {
  final String? uniqueId;
  final List<dynamic>? uploadFiles;
  final String? otherData;
  final UploadBoxStatus? uploadBoxStatus;
  final String? progressValue;

  const UploadBox({
    this.uniqueId,
    this.uploadFiles,
    this.otherData,
    this.uploadBoxStatus,
    this.progressValue,
  });

  static const empty = UploadBox();

  UploadBox copyWith(
      {String? uniqueId,
      UploadBoxStatus? uploadBoxStatus,
      String? otherData,
      List<dynamic>? uploadFiles,
      String? progressValue}) {
    return UploadBox(
      uniqueId: uniqueId ?? this.uniqueId,
      uploadBoxStatus: uploadBoxStatus ?? this.uploadBoxStatus,
      otherData: otherData ?? this.otherData,
      uploadFiles: uploadFiles ?? this.uploadFiles,
      progressValue: progressValue ?? this.progressValue,
    );
  }

  @override
  List<Object> get props =>
      [uniqueId!, uploadBoxStatus!, otherData!, uploadFiles!, progressValue!];

  @override
  String toString() =>
      '{"uniqueId": "$uniqueId", "uploadBoxStatus": "$uploadBoxStatus",  "uploadFiles": "${uploadFiles.toString()}", "progressValue": "$progressValue", "otherData": "${otherData.toString()}" }';
}

class UploadProgressState extends Equatable {
  // final List<dynamic>? uploadFiles;
  // final UploadStatus? status;
  // final String? otherData, progressValue;
  // final String? uniqueId;
  final List<UploadBox> uploadQueue;
  final bool? isUploading;
  /*  Other Data Format 
    {
      "upload_for":"ChatChannel",  // enum {"chat_message", "profile_photo", "add_property"} etc
      "data" : "form_data", // serialize the form data that you want to share
      "result": "upload_json", // result from tranlosad it send back 
      "timtoken": "" // Just for reference
      "upload_path": "" // upload path
    }
  */

  // const UploadProgressState({
  //   this.uniqueId = '',
  //   this.status = UploadStatus.ideal,
  //   this.otherData = '',
  //   this.progressValue = '',
  //   this.uploadFiles = const [],
  // });

  const UploadProgressState({
    this.uploadQueue = const [],
    this.isUploading = false,
  });

  @override
  List<Object> get props => [uploadQueue, isUploading!];

  // UploadProgressState copyWith(
  //     {String? uniqueId,
  //     UploadStatus? status,
  //     String? otherData,
  //     List<AssetEntity>? uploadFiles,
  //     String? progressValue}) {
  //   return UploadProgressState(
  //     uniqueId: uniqueId ?? this.uniqueId,
  //     status: status ?? this.status,
  //     otherData: otherData ?? this.otherData,
  //     uploadFiles: uploadFiles ?? this.uploadFiles,
  //     progressValue: progressValue ?? this.progressValue,
  //   );
  // }

  UploadProgressState copyWith({required UploadBox uploadBox}) {
    return UploadProgressState(
      uploadQueue: updateQueue(uploadBox),
      isUploading: uploadQueue.isNotEmpty == true ? true : false,
    );
  }

  List<UploadBox> updateQueue(UploadBox uploadBox) {
    List<UploadBox>? uploadQueue = this.uploadQueue;

    UploadBox currentUploadBox = uploadBox;
    if (currentUploadBox.uploadBoxStatus == UploadBoxStatus.start) {
      return [...uploadQueue, uploadBox];
    } else {
      return uploadQueue
          .map((e) =>
              e.uniqueId == currentUploadBox.uniqueId ? currentUploadBox : e)
          .toList();
    }
  }
}
