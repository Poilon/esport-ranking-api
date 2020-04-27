Players::Type = GraphQL::ObjectType.define do
  name 'Player'
  field :id, !types.String
  field :hide, types.Boolean
  field :winning_matches, types[Matches::Type]
  field :losing_matches, types[Matches::Type]
  field :elo_by_time_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :elo_by_times, types[EloByTimes::Type]

  field :elo_map, types.String do
    resolve ->(obj, _, _) { Player.find(obj.id).elo_map }
  end
  field :rank, types.Int do
    resolve ->(obj, _, _) { Player.find(obj.id).rank }
  end
  field :country_rank, types.Int do
    resolve ->(obj, _, _) { Player.find(obj.id).country_rank }
  end
  field :state_rank, types.Int do
    resolve ->(obj, _, _) { Player.find(obj.id).state_rank }
  end
  field :city_rank, types.Int do
    resolve ->(obj, _, _) { Player.find(obj.id).city_rank }
  end

  field :tournaments_diffs, types.String do
    resolve ->(obj, _, _) { Player.find(obj.id).tournaments_diffs }
  end

  field :character_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :characters, types[Characters::Type]

  field :profile_picture_url, types.String
  field :twitch, types.String
  field :steam, types.String
  field :discord, types.String
  field :mixer, types.String
  field :elo, types.Int
  field :smashgg_user_id, types.Int
  field :current_mpgr_ranking, types.Int
  field :player_character_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :player_characters, types[PlayerCharacters::Type]
  field :result_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :results, types[Results::Type]
  field :team_ids, types[types.String] do
    resolve CollectionIdsResolver
  end
  field :teams, types[Teams::Type]
  field :created_at, types.String
  field :updated_at, types.String
  field :smashgg_id, types.Int
  field :name, types.String
  field :location, types.String
  field :city, types.String
  field :sub_state, types.String
  field :state, types.String
  field :country, types.String
  field :latitude, types.Float
  field :longitude, types.Float
  field :twitter, types.String
  field :youtube, types.String
  field :wiki, types.String
  field :score, types.Int

  field :best_win, Matches::Type do
    resolve ->(obj, _, _) { Player.find(obj.id).best_win }
  end

  field :worst_lose, Matches::Type do
    resolve ->(obj, _, _) { Player.find(obj.id).worst_lose }
  end

  field :matches_count, types.Int do
    resolve ->(obj, _, _) { Player.find(obj.id).winning_matches.count + Player.find(obj.id).losing_matches.count }
  end

end
