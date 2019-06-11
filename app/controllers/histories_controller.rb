class HistoriesController < ApplicationController
  before_action :set_history, only: [:show, :edit, :update, :destroy]
  before_action :logged_user!, except: [:index, :show]
  before_action :check_user_author, only: [:edit, :destroy]

  # GET /histories
  # GET /histories.json
  def index
    @histories = History.all
  end

  # GET /histories/1
  # GET /histories/1.json
  def show
  end

  # GET /histories/new
  def new
    @history = History.new
  end

  # GET /histories/1/edit
  def edit
  end

  # POST /histories
  # POST /histories.json
  def create

    @history = History.new(history_params)
    @history.user_id = current_user.id
    respond_to do |format|
      if @history.save
        format.html { redirect_to @history, notice: 'History was successfully created.' }
        format.json { render :show, status: :created, location: @history }
      else
        format.html { render :new }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /histories/1
  # PATCH/PUT /histories/1.json
  def update
    respond_to do |format|
      if @history.update(history_params)
        format.html { redirect_to @history, notice: 'History was successfully updated.' }
        format.json { render :show, status: :ok, location: @history }
      else
        format.html { render :edit }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /histories/1
  # DELETE /histories/1.json
  def destroy
    @history.destroy
    respond_to do |format|
      format.html { redirect_to histories_url, notice: 'History was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def user_histories
    @user_histories = []
    @histories = History.all
    @user = current_user
    @histories.each do |h|
      @user_histories.push(h) if h.user.id == @user.id
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_history
      @history = History.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def history_params
      params.require(:history).permit(:title, :picture, :content, :remote_picture_url, :user_id)
    end

    def logged_user!
      redirect_to root_path, alert: 'Acceso denegado. Primero Inicia sesión.' unless user_signed_in?
    end

    def check_user_author
      set_history
      redirect_to root_path, alert: 'Solo puedes modificar tus posts .' unless (@history.user.id == current_user.id) || (current_user.admin?)
    end
end
