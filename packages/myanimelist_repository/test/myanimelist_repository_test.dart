// ingore_for_file: must_be_immutable
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;
import 'package:flutter_test/flutter_test.dart';
import 'package:myanimelist_repository/myanimelist_repository.dart';

const _mockMALUserId = 1;
const _mockMALUserName = 'mock-name';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dot_env.load(fileName: '.env');
  final _clientId = dot_env.env['HIDDEN_CLIENT_ID'];

  const email = 'test@gmail.com';
  const password = 't0ps3cret42';
  const user = User(
    id: _mockMALUserId,
    email: email,
    name: 'John Doe',
    photo: null,
  );
  group('MyAnimeListRepository', () {
    test('Constructor creates repository', () {
      expect(
        () => MyAnimeListRepository(clientId: _clientId!),
        isNot(throwsException),
      );
    });
  });
}
