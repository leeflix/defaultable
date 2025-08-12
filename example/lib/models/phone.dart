import 'package:defaultable/defaultable.dart';
import 'phone_type.dart';

part 'phone.defaultable.g.dart';

@Defaultable()
class Phone extends Defaultable {
  final String number;
  final PhoneType type;

  Phone({
    required this.number,
    required this.type,
  });

  factory Phone.fromDefaults() => _$phoneFromDefaults();

  @override
  String toString() => 'Phone(number: $number, type: $type)';
}
