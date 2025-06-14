class Api::BaseController < ActionController::API
  private
  
  def render_json_success(data = {}, status: :ok)
    render json: data, status: status
  end
  
  def render_json_error(message, status: :bad_request)
    render json: { error: message }, status: status
  end
end
