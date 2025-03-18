class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_booking, only: [:new, :create]
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :authorize_review, only: [:edit, :update, :destroy]
  
  def new
    @review = Review.new(booking: @booking, property: @booking.property)
  end

  def create
    @review = current_user.reviews.build(review_params)
    @review.booking = @booking
    @review.property = @booking.property
    
    if @review.save
      flash[:success] = "Your review has been submitted!"
      redirect_to @booking.property
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Just render the edit form
  end

  def update
    if @review.update(review_params)
      flash[:success] = "Review updated successfully!"
      redirect_to @review.property
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    property = @review.property
    @review.destroy
    flash[:success] = "Review deleted successfully!"
    redirect_to property
  end
  
  private
  
  def set_booking
    @booking = Booking.find(params[:booking_id])
    
    unless @booking.user == current_user && @booking.completed?
      flash[:error] = "You can only review bookings that are completed"
      redirect_to bookings_path
    end
  end
  
  def set_review
    @review = Review.find(params[:id])
  end
  
  def review_params
    params.require(:review).permit(:rating, :comment)
  end
  
  def authorize_review
    authorize_user(@review)
  end
end
