class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    # @users = User.all

    render json: {users: User.includes(:wallet).all.map{|user| [user.id, user.email, user.wallet.balance]} }
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
      render json: { user_id: @user.id, token: }
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def send_funds
    # funds can be sent from one user to another (could be extended to stocks or teams, but for now just users)
    # funds can only be sent from the logged in user to another user.
    # The sender is identified by the token, AND IN THIS METHOD, we asume that the token securely identifiers the user

    user_id = Base64.urlsafe_decode64(params[:token])
    sender = User.find_by(id: user_id.to_i)

    receiver = User.find_by(email: params[:receiver_email])
    sender_wallet = Wallet.find_by(owner: sender)
    receiver_wallet = Wallet.find_by(owner: receiver)
    amount = params[:amount]

    success = Transfer.new(sender_wallet, receiver_wallet, amount).call

    render json: { success:, balance: sender_wallet.balance }
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
      # this token, returned to the client to identify the user, is the user's id encoded in base64.
      # in a real application, this would be a JWT token or similar
      # this is a simple example to show how a token could be generated
      # and used to identify the user in subsequent requests
      # but, of course it is not secure. At the least the encoding should be signed to prvent one use spoofing as another user
      # and the token should have an expiry time
      Base64.urlsafe_encode64(@user.id.to_s)
    end
end
