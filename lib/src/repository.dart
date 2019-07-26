// ignore: one_member_abstracts
abstract class Repository<KeyType, ValueType> {
  Future<ValueType> get(KeyType query);
}
