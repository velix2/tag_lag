import 'package:firebase_database/firebase_database.dart';

class DbTest {
  FirebaseDatabase database = FirebaseDatabase.instance;

  void test() async {
    print("hey");

    DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");
    await ref.set({
      "name": "John",
      "age": 18,
      "address": {"line1": "100 Mountain View"}
    });
  }
}
