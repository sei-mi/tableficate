class CreatedAtSpecificDates < ActiveRecord::Migration
  def up
    NobelPrizeWinner.all.each do |npw|
      npw.created_at = DateTime.new(2011, 1, npw.id, 11, npw.id, 12)
      npw.save
    end
  end

  def down
  end
end
