class Character < ApplicationRecord

  has_many :player_characters, dependent: :destroy
  belongs_to :game

  MAPPING = {
    1 => 'Bowser',
    2 => 'Captain Falcon',
    3 => 'Donkey Kong',
    4 => 'Dr. Mario',
    5 => 'Falco',
    6 => 'Fox',
    7 => 'Ganondorf',
    8 => 'Ice Climbers',
    9 => 'Jigglypuff',
    10 => 'Kirby',
    11 => 'Link',
    12 => 'Luigi',
    13 => 'Mario',
    14 => 'Marth',
    15 => 'Mewtwo',
    16 => 'Mr. Game & Watch',
    17 => 'Ness',
    18 => 'Peach',
    19 => 'Pichu',
    20 => 'Pikachu',
    21 => 'Roy',
    22 => 'Samus',
    23 => 'Sheik',
    24 => 'Yoshi',
    25 => 'Young Link',
    26 => 'Zelda'
  }.freeze

  def self.seed
    g = Game.find_or_create_by(name: 'Super Smash Bros. Melee', slug: 'super-smash-bros-melee', smashgg_id: 1)
    Character.destroy_all
    MAPPING.each do |k, v|
      Character.find_or_create_by(name: v, game_id: g.id, smashgg_id: k, slug: v.parameterize.underscore)
    end
  end

end
