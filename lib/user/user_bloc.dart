import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:green_apex_demo/model/user_response.dart';
import 'package:green_apex_demo/user/user_list.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final http.Client httpClient;

  UserBloc(this.httpClient) : super(InitialUserState());

  @override
  UserState get initialState => InitialUserState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is Fetch && (state is UsersLoaded) == false) {
      try {
        var users = await fetchUser();
        yield UsersLoaded(users: users);
      } catch (_) {
        yield UserError();
      }
    }
  }

  Future<List<Data>> fetchUser() async {
    final response = await httpClient
        .get('https://5fd9fcd06cf2e7001737edec.mockapi.io/api/user_contacts');
    if (response.statusCode == 200) {
      Map userMap = jsonDecode(response.body);
      List<Data> data = UserResponse.fromJson(userMap).data;
      return data;
    } else {
      throw Exception('error fetching data');
    }
  }
}
