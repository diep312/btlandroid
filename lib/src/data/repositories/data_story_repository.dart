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
  Stream<UnmodifiableListView<Story>?> getStories(User user) {
    try {
      _stories = null;
      Future.delayed(Duration.zero).then((_) => _streamController
          .add(_stories == null ? null : UnmodifiableListView(_stories!)));

      if (_stories == null) _initStories(user);

      return _streamController.stream;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  void _initStories(User currentUser) async {
    try {
      _stories = [];

      final querySnapshot = await _firestore.collection('stories').get();

      if (querySnapshot.docs.isNotEmpty) {
        await Future.forEach(querySnapshot.docs,
            (QueryDocumentSnapshot<Map<String, dynamic>> element) async {
          final querySnap2 = await _firestore
              .collection('stories')
              .doc(element.id)
              .collection('items')
              .get();

          final doc =
              await _firestore.collection('users').doc(element.id).get();

          User user = User.fromJson(doc.data()!, doc.id);

          List<StoryItem> storyItems = [];

          querySnap2.docs.forEach((element2) {
            StoryItem storyItem = StoryItem.fromJson(
              element2.data(),
              element2.id,
            );
            if (currentUser.seenStoryItemIds.contains(storyItem.id))
              storyItem.isSeen = true;
            storyItems.add(storyItem);
          });

          _stories!.add(
            Story(
                id: element.id,
                items: storyItems,
                publisherLogoUrl: '',
                publisherName: user.firstName + ' ' + user.lastName),
          );
        });

        _stories!.sort((a, b) {
          if (a.items.any((item) => item.isSeen == false) &&
              b.items.any((item) => item.isSeen == false)) {
            return b.items.last.sharedOn.compareTo(a.items.last.sharedOn);
          } else
            return a.items.last.sharedOn.compareTo(b.items.last.sharedOn);
        });

        _stories!.sort((b, a) {
          if (b.items.every((item) => item.isSeen == true)) {
            return 1;
          } else {
            return -1;
          }
        });
      }

      _streamController.add(UnmodifiableListView<Story>(_stories!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }
}
