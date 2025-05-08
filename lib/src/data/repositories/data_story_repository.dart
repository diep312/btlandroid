import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chit_chat/src/domain/entities/story.dart';
import 'package:chit_chat/src/domain/entities/story_item.dart';
import 'package:chit_chat/src/domain/entities/user.dart';
import 'dart:collection';

import 'package:chit_chat/src/domain/repositories/story_repository.dart';

class DataStoryRepository implements StoryRepository {
  static DataStoryRepository? _instance;
  DataStoryRepository._();
  factory DataStoryRepository() {
    _instance ??= DataStoryRepository._();

    return _instance!;
  }

  @override
  void killInstance() {
    _instance = null;
  }

  StreamController<UnmodifiableListView<Story>?> _streamController =
      StreamController.broadcast();

  List<Story>? _stories;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addStory(
      {required User user, required StoryItem storyItem}) async {
    try {
      await _firestore
          .collection('stories')
          .doc(user.id)
          .set({'story': 'story'});

      final doc = await _firestore
          .collection('stories')
          .doc(user.id)
          .collection('items')
          .add(
            storyItem.toJson(),
          );

      storyItem.id = doc.id;

      if (_stories!.indexWhere((element) => element.id == user.id) == -1) {
        _stories!.add(
          Story(
            id: user.id,
            items: [storyItem],
            publisherLogoUrl: '',
            publisherName: user.firstName + ' ' + user.lastName,
          ),
        );
      } else {
        _stories!
            .firstWhere((element) => element.id == user.id)
            .items
            .add(storyItem);
      }

      _streamController.add(UnmodifiableListView(_stories!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }
}
