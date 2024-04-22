import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:transloadit/transloadit.dart';

/// Isar Packages
import 'package:anytimeworkout/isar/message/message_row.dart' as message_store;

/// Isar Packages

part 'upload_progress_event.dart';
part 'upload_progress_state.dart';

class UploadProgressBloc
    extends Bloc<UploadProgressEvent, UploadProgressState> {
  message_store.MessageRow messageStore = message_store.MessageRow();
  StreamController<UploadBox> uploadStream =
      StreamController<UploadBox>.broadcast();

  StreamController uploadStart = StreamController<String>.broadcast();

  final _transLoadItAuthKey = dotenv.env['TRANSLOADIT_AUTH_KEY'];
  final _transLoadItSecretKey = dotenv.env['TRANSLOADIT_SECRET_KEY'];
  final _transLoadItTemplateID = dotenv.env['TEMPLATE_ID'];
  final _s3Bucket = dotenv.env['S3BUCKET'];

  UploadProgressBloc() : super(const UploadProgressState()) {
    on<MediaPicked>(_onMediaPicked);
    on<ClearMedia>(_onClearMedia);
  }

  // TO DO: Check if not useful delete it
  Future<void> _onClearMedia(
      ClearMedia event, Emitter<UploadProgressState> emit) async {
    // emit(state.copyWith(
    //   otherData: '',
    //   status: UploadStatus.ideal,
    // ));
  }

  Future<void> _onMediaPicked(
      MediaPicked event, Emitter<UploadProgressState> emit) async {
    UploadBox eventUploadBox = event.uploadBox!;
    UploadBox currentUploadBox = UploadBox.empty;
    addToStream(eventUploadBox);
    emit(state.copyWith(uploadBox: eventUploadBox));

    // Single Stream to manage the upload
    String uploadProgress = jsonEncode(
        {"uniqueId": eventUploadBox.uniqueId.toString(), "status": "start"});
    uploadStart.sink.add(uploadProgress);

    try {
      dynamic otherData = jsonDecode(eventUploadBox.otherData.toString());
      String uploadPath = otherData['upload_path'];

      TransloaditClient client = TransloaditClient(
          authKey: _transLoadItAuthKey!, authSecret: _transLoadItSecretKey!);

      List<dynamic> uploadResult = [];
      int j = 0, totalFiles = eventUploadBox.uploadFiles!.length;
      Map<String, dynamic> files = {};
      for (dynamic i in eventUploadBox.uploadFiles!) {
        j++;
        File file;
        if (i.runtimeType.toString() == '_File') {
          file = File(i);
        } else {
          final data = await i;
          file = File(data!);
        }

        try {
          TransloaditAssembly assembly = client.assemblyFromTemplate(
            templateID: _transLoadItTemplateID!,
          )..addStep('export', "/s3/store", {
              "path": uploadPath,
              "bucket": _s3Bucket,
              "credentials": "aqar-staging"
            });
          assembly.addFile(file: file);

          Future<TransloaditResponse> waitForUpload =
              assembly.createAssembly(onProgress: (progressValue) {
            print("Progress: $progressValue");
            // Single Stream to manage the upload
            String uploadProgress = jsonEncode({
              "uniqueId": eventUploadBox.uniqueId.toString(),
              "status": "in-progress"
            });
            uploadStart.sink.add(uploadProgress);

            currentUploadBox = UploadBox(
              uploadFiles: eventUploadBox.uploadFiles,
              uniqueId: eventUploadBox.uniqueId,
              otherData: eventUploadBox.otherData,
              progressValue: progressValue.toString(),
              uploadBoxStatus: UploadBoxStatus.progress,
            );

            addToStream(currentUploadBox);
            emit(
              state.copyWith(uploadBox: currentUploadBox),
            );
          }, onComplete: () {
            // TO DO Check if useful
          });

          TransloaditResponse response = await waitForUpload;
          Map<String, dynamic> processedFileInfo =
              response.data['uploads'].first;
          Map<String, dynamic> getUploadResult = response.data['results'];

          if (processedFileInfo.isEmpty) {
            String uploadProgress = jsonEncode({
              "uniqueId": eventUploadBox.uniqueId.toString(),
              "status": "fail"
            });
            uploadStart.sink.add(uploadProgress);
          }

          files = {
            "id": processedFileInfo["id"],
            "type": processedFileInfo["mime"],
            "result": ""
          };

          Map<dynamic, dynamic> fileInfo = {};

          getUploadResult.forEach((key, value) {
            List<dynamic> fileData = value;
            final robotsMap = <String, String>{
              'type': fileData.first['mime'],
              'media_url': fileData.first['ssl_url'],
            };
            fileInfo[key] = robotsMap;
          });

          files.update("result", (value) => fileInfo);

          uploadResult.add(files);

          currentUploadBox = UploadBox(
            uploadFiles: eventUploadBox.uploadFiles,
            uniqueId: eventUploadBox.uniqueId,
            otherData: eventUploadBox.otherData,
            progressValue: '$j upload finished',
            uploadBoxStatus: UploadBoxStatus.progress,
          );

          // Single Stream to manage the upload
          String uploadProgress = jsonEncode({
            "uniqueId": eventUploadBox.uniqueId.toString(),
            "status": "$j upload finished"
          });
          uploadStart.sink.add(uploadProgress);

          addToStream(currentUploadBox);
          emit(state.copyWith(uploadBox: currentUploadBox));
        } catch (e) {
          String uploadProgress = jsonEncode({
            "uniqueId": eventUploadBox.uniqueId.toString(),
            "status": "fail"
          });
          print("failed with some issue $e");
          print(uploadProgress);
          print("failed with some issue");
          uploadStart.sink.add(uploadProgress);
        }
      } // for loop one file uploaded

      Map<String, dynamic> resultData = {'result': jsonEncode(uploadResult)};

      otherData.addEntries(resultData.entries);
      currentUploadBox = UploadBox(
        uploadFiles: eventUploadBox.uploadFiles,
        uniqueId: eventUploadBox.uniqueId,
        otherData: jsonEncode(otherData),
        progressValue: '$j upload finished',
        uploadBoxStatus: UploadBoxStatus.end,
      );

      addToStream(currentUploadBox);
      emit(state.copyWith(uploadBox: currentUploadBox));

      // Single Stream to manage the upload
      String uploadProgress = jsonEncode(
          {"uniqueId": eventUploadBox.uniqueId.toString(), "status": "end"});
      uploadStart.sink.add(uploadProgress);
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('''Error: $e \n StackTrace: $stacktrace''');
      }
    }
  }

  addToStream(UploadBox uploadBox) {
    uploadStream.sink.add(uploadBox);
  }
}
