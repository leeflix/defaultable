import 'package:defaultable/defaultable.dart';

part 'address.defaultable.g.dart';

@Defaultable()
class Address implements Defaultable {
  final String street;
  final String city;

  Address({
    required this.street,
    required this.city,
  });

  factory Address.fromDefaults() => _$addressFromDefaults();

  @override
  String toString() => 'Address(street: $street, city: $city)';
}
