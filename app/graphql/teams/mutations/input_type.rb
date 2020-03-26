Teams::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'TeamInputType'
  description 'Properties for updating a Team'
  argument :player_ids, types[types.String]

  argument :name, types.String
  argument :prefix, types.String
  argument :slug, types.String

end
