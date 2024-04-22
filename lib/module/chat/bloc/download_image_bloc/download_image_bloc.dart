import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
part 'download_image_event.dart';
part 'download_image_state.dart';

class DownloadImageBloc extends Bloc<DownloadImageEvent, DownloadImageState> {
  DownloadImageBloc() : super(const DownloadImageState()) {
    on<DownloadImage>(_onDownloadImage);
    on<ResetImageSlider>(_onResetImageSlider);
    on<ShowCurrentImageCount>(_onShowCurrentImageCount);
  }

  Future<void> _onDownloadImage(
      DownloadImage event, Emitter<DownloadImageState> emit) async {
    emit(state.copyWith(
      status: DownloadImageStatus.loading,
    ));

    List mediaUrls = [];
    List<dynamic> downloadedImagePathArray = [];

    var documentDirectory = await getApplicationDocumentsDirectory();

    for (Map<String, dynamic> file in event.imageArray) {
      if (file['type'].toString() == "image/jpeg" ||
          file['type'].toString() == "image/jpg" ||
          file['type'].toString() == "image/png" ||
          file['type'].toString() == "image/bmp" ||
          file['type'].toString() == "image/webp") {
        mediaUrls.add(file["result"][":original"]["media_url"].toString());
      } else if (file['type'].toString().contains("video/")) {
        mediaUrls.add(file["result"]["video_encoded"]["media_url"].toString());
      }
    }

    for (String singleUrl in mediaUrls) {
      dynamic splitImageName = singleUrl.split('/');
      dynamic imageName = splitImageName.last;
      final extension = p.extension(singleUrl);

      if (extension == ".mp4") {
        downloadedImagePathArray.add(singleUrl);
      } else {
        var filePathAndName = '${documentDirectory.path}/images/$imageName';
        File file = File(filePathAndName);
        bool ifExisting = await (file.exists());

        if (ifExisting == true) {
          downloadedImagePathArray.add(filePathAndName);
          emit(state.copyWith(
            status: DownloadImageStatus.success,
          ));
        } else {
          var url = singleUrl;
          var response = await http.get(Uri.parse(url));
          var documentDirectory = await getApplicationDocumentsDirectory();
          var firstPath = "${documentDirectory.path}/images";
          var filePathAndName = '${documentDirectory.path}/images/$imageName';
          await Directory(firstPath).create(recursive: true);
          File file2 = File(filePathAndName);
          file2.writeAsBytesSync(response.bodyBytes);
          downloadedImagePathArray.add(filePathAndName);
          emit(state.copyWith(
            status: DownloadImageStatus.success,
          ));
        }
      }
    }
    return emit(state.copyWith(
      status: DownloadImageStatus.success,
      downloadedImageArray: downloadedImagePathArray,
    ));
  }

  Future<void> _onResetImageSlider(
      ResetImageSlider event, Emitter<DownloadImageState> emit) async {
    emit(
      state.copyWith(downloadedImageArray: [], currentImageCount: 1),
    );
  }

  Future<void> _onShowCurrentImageCount(
      ShowCurrentImageCount event, Emitter<DownloadImageState> emit) async {
    return emit(state.copyWith(currentImageCount: event.currentImageCount));
  }
}
