class CreateNobelPrizes < ActiveRecord::Migration
  def up
    create_table :nobel_prizes do |t|
      t.integer :nobel_prize_winner_id
      t.string  :category
      t.integer :year
    end

    execute(
      'INSERT INTO nobel_prizes("nobel_prize_winner_id", "category", "year") ' +
      'SELECT id, category, year ' +
      'FROM nobel_prize_winners'
    )

    NobelPrizeWinner.find_by_first_name_and_last_name('Marie', 'Curie').nobel_prizes.create(category: 'Physics', year: 1903)

    remove_column :nobel_prize_winners, :category, :year
  end

  def down
    add_column :nobel_prize_winners, :category, :string
    add_column :nobel_prize_winners, :year, :integer

    NobelPrizeWinner.find_by_first_name_and_last_name('Marie', 'Curie').nobel_prizes.order(:year).first.delete

    execute(
      'UPDATE nobel_prize_winners ' +
      'SET category = (SELECT nobel_prizes.category FROM nobel_prizes WHERE nobel_prize_winners.id = nobel_prizes.nobel_prize_winner_id), ' +
        'year = (SELECT nobel_prizes.year FROM nobel_prizes WHERE nobel_prize_winners.id = nobel_prizes.nobel_prize_winner_id)'
    )

    drop_table :nobel_prizes
  end
end
