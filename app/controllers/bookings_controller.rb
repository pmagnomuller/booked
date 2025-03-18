class BookingsController < ApplicationController
  before_action :require_login
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_property, only: [:new, :create]
  before_action :authorize_booking, only: [:edit, :update, :destroy]
  
  def index
    @upcoming_bookings = current_user.bookings.upcoming.includes(:property)
    @past_bookings = current_user.bookings.past.includes(:property)
    @current_bookings = current_user.bookings.current.includes(:property)
  end

  def show
    @property = @booking.property
    @review = @booking.review || Review.new(booking: @booking)
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = current_user.bookings.build(booking_params)
    @booking.property = @property
    @booking.total_price = calculate_total_price
    
    if @booking.save
      flash[:success] = "Your booking has been created and is awaiting confirmation"
      redirect_to @booking
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Just render the edit form
  end

  def update
    if @booking.update(booking_params)
      @booking.total_price = calculate_total_price
      @booking.save
      
      flash[:success] = "Booking updated successfully!"
      redirect_to @booking
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.canceled!
    flash[:success] = "Booking canceled successfully!"
    redirect_to bookings_path
  end
  
  private
  
  def set_booking
    @booking = Booking.find(params[:id])
  end
  
  def set_property
    @property = Property.find(params[:property_id])
  end
  
  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
  
  def calculate_total_price
    start_date = booking_params[:start_date].to_date
    end_date = booking_params[:end_date].to_date
    nights = (end_date - start_date).to_i
    nights * @property.price_per_night
  end
  
  def authorize_booking
    authorize_user(@booking)
  end
end
