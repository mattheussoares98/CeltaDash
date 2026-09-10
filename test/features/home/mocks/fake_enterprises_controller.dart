import 'package:celta_dash/features/home/domain/entities/entities.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';

class FakeEnterprisesController extends EnterprisesController {
  final List<HomeEnterpriseEntity> enterprises;

  FakeEnterprisesController(this.enterprises);

  @override
  Future<List<HomeEnterpriseEntity>> build() async => enterprises;
}
