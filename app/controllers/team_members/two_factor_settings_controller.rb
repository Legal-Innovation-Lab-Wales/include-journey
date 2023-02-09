module TeamMember
    # app/controller/team_member/two_factor_settings_controller.rb
    class TwoFactorSettingsController < TeamMembersApplicationController
        def new
            if current_team_member.otp_required_for_login
              flash[:alert] = 'Two Factor Authentication is already enabled.'
              return #redirect_to somewhere
            end
            
            current_team_member.generate_two_factor_secret_if_missing!
        end

        def create
            unless current_team_member.valid_password?(enable_2fa_params[:password])
              flash.now[:alert] = 'Incorrect password'
              return render :new
            end
        
            if current_team_member.validate_and_consume_otp!(enable_2fa_params[:code])
              current_team_member.enable_two_factor!
        
              flash[:notice] = 'Successfully enabled two factor authentication, please make note of your backup codes.'
              redirect_to edit_two_factor_settings_path
            else
              flash.now[:alert] = 'Incorrect Code'
              render :new
            end
        end

        def edit
            unless current_team_member.otp_required_for_login
              flash[:alert] = 'Please enable two factor authentication first.'
              return redirect_to new_two_factor_settings_path
            end
        
            if current_team_member.two_factor_backup_codes_generated?
              flash[:alert] = 'You have already seen your backup codes.'
              return #redirect_to somewhere
            end
        
            @backup_codes = current_team_member.generate_otp_backup_codes!
            current_team_member.save!
        end

        private

        def enable_2fa_params
            params.require(:two_fa).permit(:code, :password)
        end
    end
end