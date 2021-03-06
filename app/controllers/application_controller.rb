class ApplicationController < ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken

    before_action :configure_permitted_parameters, if: :devise_controller?
    respond_to :json

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :first_name, :middle_name, :last_name, :position, :address, :city, :state, :country, :zipcode, :phone_number, :party, :created])
        devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :first_name, :middle_name, :last_name, :position, :address, :city, :state, :country, :zipcode, :phone_number, :party, :campaign_id, :created])
    end

    def authenticate_admin!
        unless current_user.admin
            render :json => { 'errors': { 'user': [ 'not admin' ] } }, :status => 401
        end
    end

    def render_success
        render :json => { 'status': 'ok' }
    end

    def render_error(error)
        render :json => { 'errors': { error: [error] } }, :status => 400
    end

    def render_errors(model)
        render :json => { 'errors': model.errors.messages }, :status => 400
    end

    def not_found
        render :json => {}, :status => 404
    end
end
