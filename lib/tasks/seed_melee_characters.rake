namespace :db do
  task seed_melee_characters: :environment do

    Game.create(name: 'Super Smash Bros. Melee', slug: 'super-smash-bros-melee', smashgg_id: 1)

    [
      'Bowser', 'Captain Falcon', 'Donkey Kong', 'Dr Mario', 'Falco', 'Fox', 'Ganondorf',
      'Ice Climbers', 'Jigglypuff', 'Kirby', 'Link', 'Luigi', 'Mario', 'Marth', 'Mewtwo',
      'Mr Game&Watch', 'Ness', 'Peach', 'Pichu', 'Pikachu', 'Roy', 'Samus', 'Sheik', 'Yoshi',
      'Young Link', 'Zelda'
    ].each do |name|
      Character.create(game_id: Game.find_by(slug: 'super-smash-bros-melee').id, name: name, slug: name.parameterize.underscore)
    end

  end
end
