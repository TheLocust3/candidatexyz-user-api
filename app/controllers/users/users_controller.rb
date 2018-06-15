class Api::Users::UsersController < Api::ApiController

    before_action :authenticate_user!, only: [ :index, :show, :update, :destroy ]
    before_action :authenticate_admin!, only: [ :update, :create_invite ]

    def index
        render :json => User.all
    end

    def show
        render :json => User.find(params[:id])
    end

    def get_current_user
      render :json => current_user
    end

    def create_invite
        token = PerishableToken.create_good_until_tomorrow(current_user.id)

        Mailer.staff_invite(params[:email], token.encode).deliver_later

        render_success
    end

    def create
        token = PerishableToken.decode(params[:token])

        if DateTime.now < token.good_until && User.find(token.data).admin
            token.destroy
            user = User.new(create_params(params))

            if user.save
                render :json => User.find(user.id)
            else
                render_errors(user)
            end
        else
            render_unauthorized
        end
    end

    def update
        user = User.find(params[:id])

        if user.update(update_params(params))
            render :json => User.find(user.id)
        else
            render_errors(user)
        end
    end

    def destroy
        user = User.find(params[:id])
        user.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end

    def update_params(params)
        params.permit(:email, :first_name, :last_name, :admin)
    end
end
