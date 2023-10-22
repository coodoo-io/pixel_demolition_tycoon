/// Interface for mapping between model and entity
abstract class EntityMapper<Model, Entity> {
  Model toModel(Entity entity);
  Entity toEntity(Model model);
}
