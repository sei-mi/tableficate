class FiltersController < ApplicationController
  before_filter :get_npw

  def get_npw
    @npw = NobelPrizeWinner.select('nobel_prize_winners.*, nobel_prizes.category, nobel_prizes.year').joins(:nobel_prizes).tableficate(params[:nobel_prize_winners])
  end
end
