import '../GetItDependencies.dart';
import '../model/recipes/v1/recept.dart';
import '../repositories/RecipesRepository.dart';

class RecipesService {
  var _recipesRepository = getIt<RecipesRepository>();


  Future<void> saveRecept(Recept recept)  {
    return _recipesRepository.saveRecept(recept);
  }


}
