class PropertiesController < ApplicationController
  before_action :require_login, except: [:index, :show, :search]
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  before_action :authorize_property, only: [:edit, :update, :destroy]
  
  def index
    @properties = Property.available.order(created_at: :desc)
  end

  def show
    @booking = Booking.new
    @reviews = @property.reviews.includes(:user).order(created_at: :desc)
    @average_rating = @property.average_rating
  end

  def new
    @property = Property.new
  end

  def create
    @property = current_user.properties.build(property_params)
    
    if @property.save
      flash[:success] = "Property created successfully!"
      redirect_to @property
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Just render the edit form
  end

  def update
    if @property.update(property_params)
      flash[:success] = "Property updated successfully!"
      redirect_to @property
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @property.destroy
    flash[:success] = "Property deleted successfully!"
    redirect_to properties_path
  end
  
  def search
    @query = params[:query]
    @min_price = params[:min_price]
    @max_price = params[:max_price]
    @properties = Property.available
    
    @properties = @properties.by_city(@query) if @query.present?
    @properties = @properties.by_price_range(@min_price, @max_price) if @min_price.present? && @max_price.present?
    
    render :index
  end
  
  private
  
  def set_property
    @property = Property.find(params[:id])
  end
  
  def property_params
    params.require(:property).permit(
      :title, :description, :address, :city, :state, :country,
      :price_per_night, :property_type, :max_guests, :bedrooms, :bathrooms,
      images: []
    )
  end
  
  def authorize_property
    authorize_user(@property)
  end
end
