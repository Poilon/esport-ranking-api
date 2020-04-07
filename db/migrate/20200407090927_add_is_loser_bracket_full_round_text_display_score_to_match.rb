class AddIsLoserBracketFullRoundTextDisplayScoreToMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :is_loser_bracket, :boolean, default: false
    add_column :matches, :full_round_text, :string
    add_column :matches, :display_score, :string
  end
end
