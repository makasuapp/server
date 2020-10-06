# typed: ignore
class Api::VendorsController < ApplicationController
  before_action :set_vendor, only: [:update]

  def index
    @kitchen = Kitchen.find_by(id: params[:kitchen_id])

    set_vendors

    render formats: :json
  end

  def create
    @kitchen = Kitchen.find_by(id: params[:kitchen_id])

    @vendor = Vendor.new(vendor_params)
    @vendor.organization_id = @kitchen.organization_id

    unless @vendor.save
      render json: @vendor.errors, status: :unprocessable_entity
      return
    end

    set_vendors

    render :index, status: :ok
  end

  def update
    @kitchen = Kitchen.find_by(id: params[:kitchen_id])

    unless @vendor.update(vendor_params)
      render json: @vendor.errors, status: :unprocessable_entity
      return
    end

    set_vendors

    render :index, status: :ok
  end

  private
  def set_vendors
    @vendors = Vendor.where(organization_id: @kitchen.organization_id)
  end


  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:name)
  end
end