class SessionsController < ApplicationController
  # GET /sessions/new
  def new
  end

  # POST /sessions
  def create
    oauth_session = new_session
    if !oauth_session.has_errors?
      oauth_session.save_to(session)
      redirect_to session.delete(:intented_url) || library_index_path
    else
      redirect_back alert: oauth_session.errors.join(', '), fallback_location: new_session_path
    end
  end

  # DELETE /sessions
  def destroy
    session.clear
    redirect_back fallback_location: new_session_path, notice: 'You are now signed out'
  end

private

  def new_session
    OauthSession.create(**session_params)
  end

  def session_params
    params.permit(:username, :password).to_h.symbolize_keys
  end
end
