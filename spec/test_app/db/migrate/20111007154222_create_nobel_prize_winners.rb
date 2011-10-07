class CreateNobelPrizeWinners < ActiveRecord::Migration
  def change
    create_table :nobel_prize_winners do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :category
      t.integer :year
    end

    [
      {first_name: 'Norman',   last_name: 'Borlaug',     category: 'Peace',                  year: 1970},
      {first_name: 'Paul',     last_name: 'Flory',       category: 'Chemistry',              year: 1974},
      {first_name: 'Albert',   last_name: 'Eintein',     category: 'Physics',                year: 1921},
      {first_name: 'Samuel',   last_name: 'Beckett',     category: 'Literature',             year: 1969},
      {first_name: 'Niels',    last_name: 'Bohr',        category: 'Physics',                year: 1922},
      {first_name: 'Erwin',    last_name: 'Schrodinger', category: 'Physics',                year: 1933},
      {first_name: 'Paul',     last_name: 'Dirac',       category: 'Physics',                year: 1933},
      {first_name: 'Enrico',   last_name: 'Fermi',       category: 'Physics',                year: 1938},
      {first_name: 'Richard',  last_name: 'Feynman',     category: 'Physics',                year: 1965},
      {first_name: 'Marie',    last_name: 'Curie',       category: 'Chemistry',              year: 1911},
      {first_name: 'James',    last_name: 'Watson',      category: 'Physiology or Medicine', year: 1962},
      {first_name: 'Bertrand', last_name: 'Russell',     category: 'Literature',             year: 1950},
      {first_name: 'John',     last_name: 'Steinbeck',   category: 'Literature',             year: 1962},
      {first_name: 'Nelson',   last_name: 'Mandela',     category: 'Peace',                  year: 1993},
      {first_name: 'Jacques',  last_name: 'Monod',       category: 'Physiology or Medicine', year: 1965}
    ].each do |winner|
      NobelPrizeWinner.create(winner)
    end
  end
end
