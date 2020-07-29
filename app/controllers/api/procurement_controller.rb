# typed: ignore
class Api::ProcurementController < ApplicationController
  def index
    #hacky temp solution to have a dev environment
    if params[:env] == "dev"
      date = OpDay.first.date
    else
      date = Time.now
    end

    @procurement_orders = ProcurementOrder
      .where("for_date >= ?", 
        date.in_time_zone("America/Toronto").beginning_of_day)
      .includes([:vendor, :procurement_items])

    render formats: :json
  end
end