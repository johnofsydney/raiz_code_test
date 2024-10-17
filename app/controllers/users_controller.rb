class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  def sign_in
    # Find the user by email, authenticate password and return a token which identifies the user.

    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      render json: { token: }
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def send_funds
    begin
      user_id = Tokenizer.decrypt(params[:token])
    rescue ActiveSupport::MessageEncryptor::InvalidMessage
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    rescue ActiveSupport::MessageVerifier::InvalidSignature
    end

    begin
      sender = User.find(user_id)
    rescue ActiveRecord::RecordNotFound => e
      return render json: { error: 'User not found. Check if Token Expired' }, status: :unauthorized
    end

    receiver = User.find_by!(email: params[:receiver_email])
    amount = params[:amount]

    success = Transfer.new(sender.wallet, receiver.wallet, amount).call

    render json: { success:, balance: sender.wallet.balance }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password_digest)
    end

    def token
      Tokenizer.encrypt(@user.id)
    end
end
