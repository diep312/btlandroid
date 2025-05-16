import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';

class UpdateUserProfileParams {
  final String description;
  final String? avatarUrl;

  UpdateUserProfileParams({
    required this.description,
    this.avatarUrl,
  });
}

class UpdateUserProfile extends UseCase<void, UpdateUserProfileParams> {
  final UserRepository _userRepository;
  final StreamController<void> _controller = StreamController();

  UpdateUserProfile(this._userRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      UpdateUserProfileParams? params) async {
    if (params == null) {
      _controller.addError('Parameters cannot be null');
      return _controller.stream;
    }

    try {
      await _userRepository.updateProfile(
        description: params.description,
        avatarUrl: params.avatarUrl,
      );
      if (!_controller.isClosed) {
        _controller.add(null);
      }
    } catch (e) {
      if (!_controller.isClosed) {
        _controller.addError(e);
      }
    }

    return _controller.stream;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
