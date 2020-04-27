Players::Mutations::InputType = GraphQL::InputObjectType.define do
  name 'PlayerInputType'
  description 'Properties for updating a Player'

  argument :character_ids, types[types.String]
  argument :hide, types.Boolean
  argument :elo_by_time_ids, types[types.String]
  argument :profile_picture_url, types.String
  argument :twitch, types.String
  argument :steam, types.String
  argument :discord, types.String
  argument :mixer, types.String
  argument :elo, types.Int
  argument :smashgg_user_id, types.Int
  argument :current_mpgr_ranking, types.Int
  argument :player_character_ids, types[types.String]
  argument :result_ids, types[types.String]
  argument :team_ids, types[types.String]

  argument :smashgg_id, types.Int
  argument :name, types.String
  argument :location, types.String
  argument :city, types.String
  argument :sub_state, types.String
  argument :state, types.String
  argument :country, types.String
  argument :latitude, types.Float
  argument :longitude, types.Float
  argument :twitter, types.String
  argument :youtube, types.String
  argument :wiki, types.String
  argument :score, types.Int

end
