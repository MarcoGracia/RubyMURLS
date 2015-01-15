class ShortensController < ApplicationController
  before_action :set_shorten, only: [:show, :edit, :update, :destroy]
  protect_from_forgery with: :null_session

  # GET /shortens
  # GET /shortens.json
  def index
    @shortens = Shorten.all
  end

  # GET /shortens/1
  # GET /shortens/1.json
  def show
  end

  # GET /shortens/new
  def new
    @shorten = Shorten.new
  end

  # POST /shortens
  # POST /shortens.json
  def create
    @shorten = Shorten.new(shorten_params)

    respond_to do |format|
      if @shorten.save
        format.html { redirect_to @shorten, notice: 'Shorten was successfully created.' }
        format.json { render :show, status: :created, location: @shorten }
      else
        format.html { render :new }
        format.json { render json: @shorten.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shorten
      @shorten = Shorten.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shorten_params
      params.require(:shorten).permit(:url, :shortcode )
    end
end
