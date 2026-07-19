import '../../../../core/result/result.dart';
import '../entities/home_entity.dart';

abstract interface class HomeRepository {
  Future<Result<HomeEntity>> getHomeData();
}
