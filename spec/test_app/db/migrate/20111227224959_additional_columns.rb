class AdditionalColumns < ActiveRecord::Migration
  def up
    add_column :nobel_prize_winners, :birthdate, :date
    add_column :nobel_prize_winners, :created_at, :datetime
    add_column :nobel_prize_winners, :updated_at, :timestamp
    add_column :nobel_prize_winners, :meaningless_time, :time
    add_column :nobel_prizes, :shared, :boolean
    add_column :nobel_prizes, :meaningless_decimal, :decimal
    add_column :nobel_prizes, :meaningless_float, :float

    npw_updates = {
      1  => {birthdate: '19140325'},
      2  => {birthdate: '19100619'},
      3  => {birthdate: '18790314'},
      4  => {birthdate: '19060413'},
      5  => {birthdate: '18851007'},
      6  => {birthdate: '18870812'},
      7  => {birthdate: '19020808'},
      8  => {birthdate: '19010929'},
      9  => {birthdate: '19180511'},
      10 => {birthdate: '18671107'},
      11 => {birthdate: '19280406'},
      12 => {birthdate: '18720518'},
      13 => {birthdate: '19020227'},
      14 => {birthdate: '19180718'},
      15 => {birthdate: '19100209'}
    }

    np_updates = {
      1  => {shared: false},
      2  => {shared: false},
      3  => {shared: false},
      4  => {shared: false},
      5  => {shared: false},
      6  => {shared: true},
      7  => {shared: true},
      8  => {shared: false},
      9  => {shared: true},
      10 => {shared: true},
      16 => {shared: false},
      11 => {shared: true},
      12 => {shared: false},
      13 => {shared: false},
      14 => {shared: true},
      15 => {shared: true}
    }

    npw_updates.each do |id, attrs|
      NobelPrizeWinner.find(id).update_attributes(attrs.merge(
        created_at:       Time.now,
        updated_at:       Time.now,
        meaningless_time: "#{id}:#{id}:#{id}"
      ))
    end

    np_updates.each do |id, attrs|
      NobelPrize.find(id).update_attributes(attrs.merge(
        meaningless_decimal: "#{id}.#{id}",
        meaningless_float:   "#{id}.#{id}"
      ))
    end
  end

  def down
    remove_column :nobel_prize_winners, :birthdate
    remove_column :nobel_prize_winners, :created_at
    remove_column :nobel_prize_winners, :updated_at
    remove_column :nobel_prize_winners, :meaningless_time
    remove_column :nobel_prizes, :shared
    remove_column :nobel_prizes, :meaningless_decimal
    remove_column :nobel_prizes, :meaningless_float
  end
end
