/// Interface for mapping between model and data transfer objects
abstract class DtoMapper<Model, Dto> {
  Model toModel(Dto dto);
  Dto toDto(Model model) {
    throw UnimplementedError();
  }
}
