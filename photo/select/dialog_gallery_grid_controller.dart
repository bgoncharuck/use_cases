import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

const dialogGalleryPhotoWidth = 136;
const dialogGalleryPhotoHeight = 136;

class DialogGalleryGridState {
  final List<AssetEntity> entities = [];
  final List<Widget> photos = [];
}

class DialogGalleryGridController extends GetxController with StateMixin<DialogGalleryGridState> {
  AssetPathEntity? album;
  DialogGalleryGridState snapshot = DialogGalleryGridState();
  int currentPage = 0;
  int? lastPage;
  static const numberOfPhotosInPage = 12;

  @override
  Future onInit() async {
    super.onInit();
    await addNewMedia();
    await recursivePreload();
  }

  Future addNewMedia() async {
    lastPage = currentPage;
    await loadNewPage(currentPage++);
    change(snapshot, status: RxStatus.success());
  }

  Future recursivePreload() async {
    if (numberOfPhotosInPage * lastPage! >= await album!.assetCountAsync) {
      return;
    }
    await addNewMedia();
    await recursivePreload();
  }

  Future loadNewPage(int page) async {
    album ??= (await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    ))[0];
    //

    final newEntities = await album!.getAssetListPaged(
      page: page,
      size: numberOfPhotosInPage,
    );
    for (final entity in newEntities) {
      final bitCode = await entity.thumbnailDataWithSize(
        const ThumbnailSize(dialogGalleryPhotoWidth * 6, dialogGalleryPhotoHeight * 6),
      );
      snapshot.photos.add(
        Image.memory(
          bitCode!,
          key: Key(entity.id),
          fit: BoxFit.cover,
        ),
      );
    }

    snapshot.entities.addAll(newEntities);
  }
}
