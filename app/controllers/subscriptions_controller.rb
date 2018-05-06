class SubscriptionsController < ApplicationController 
	before_action :authenticate_user!, except: [:new]
	before_action :redirect_to_signup, only: [:new]
	def show 
	end 

	def new 
	end 

	def create
		 # Amount in cents
		  @amount = 500


		  if current_user.stripe_id? 
		  		customer = Stripe::Customer.retrieve(current_user.stripe_id)
		  else 
			  customer = Stripe::Customer.create(
			    :email => current_user.email,
			    :source  => params[:stripeToken],
			  )
		  end 

		  charge = Stripe::Charge.create(
		    :customer    => customer.id,
		    :amount      => @amount,
		    :description => 'Rails Stripe customer',
		    :currency    => 'usd'
		  )

		rescue Stripe::CardError => e
		  flash[:error] = e.message
		  redirect_to new_subscription_path
	end 

	def destroy
	end 


	private 

	def redirect_to_signup
		if !user_signed_in?
			session["user_return_to"] = new_subscription_path
			redirect_to new_user_registration_path
		end
	end 

end 