class PasswordsController < DeviseTokenAuth::PasswordsController
    include Request

    def create
        super do |resource|
            token = resource.reset_password_token
            body = "
                <p>Someone has requested a link to change your password. You can do this through the link below.</p>
        
                <p><a href='#{request.base_url}/auth/password/edit?config=default&redirect_url=#{URI::encode(params[:redirect_url])}&reset_password_token=#{token}'>Change my password</a></p>
                
                <p>If you didn&#39;t request this, please ignore this email.</p>
                <p>Your password won&#39;t change until you access the link above and create a new one.</p>
            "
      
            post("#{Rails.application.secrets.mailer_api}/company", { to: resource.email, subject: 'Reset Password Request', body: body })

            render :json => { 'status': 'ok' }
        end
    end
end
