part of 'user_bloc.dart';

@immutable
abstract class UserState extends Equatable {
  UserState([List props = const []]) : super(props);
}

class InitialUserState extends UserState {}

class UserError extends UserState {
  @override
  String toString() => "UserError";
}

class UsersLoaded extends UserState {
  final List<Data> users;

  UsersLoaded({this.users});

  @override
  String toString() {
    // TODO: implement toString
    return "UsersLoaded ${users.length}";
  }
}
