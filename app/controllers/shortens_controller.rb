class ShortensController < ApplicationController
  before_action :set_shorten
  before_action :set_default_response_format
  protect_from_forgery with: :null_session
  
  # GET /shortens
  # GET /shortens.json
  def index
    @shortens = Shorten.all
  end

  #GET /:shortcode/stats
  def stats
    respond_to do |format|
      
      redirectcount = @shorten.redirectcount
      
      if redirectcount == 0
        format.json { render json: @shorten, :only => [:startdate, :redirectcount]}
      else
        format.json { render json: @shorten, :only => [:startdate, :redirectcount, :lastseendate]}
      end
    end
  end

  #GET /:shortcode
  def show
    render text: "Local: " +  @shorten.url, :status => 302
  end

  #POST /shorten
  def create
    
    @shorten = Shorten.new(shorten_params)

    respond_to do |format|
      if @shorten.save
        #TODO redirect to success and compose json
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
      @shorten = Shorten.find_by shortcode: params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shorten_params
      
      url = params[:shorten][:url]
      
      if url.nil? 
        # TODO Throw 400
      end
      
      shortcode = params[:shorten][:shortcode]
      
      if !( shortcode.match("^[0-9a-zA-Z_]{4,}$") )
        #TODO throw 422
      end
      
      if Shorten.find_by shortcode: shortcode
        # TODO Throw 409
      end
      
      if shortcode.nil? 
        shortcode = rand(36**6).to_s(36)
      end
      
      time = Time.now.to_s
      time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M")
      
      params = ActionController::Parameters.new( url:url, shortcode:shortcode, startdate: time )
      
      params.permit(:url, :shortcode, :startdate )
      
    end

    protected
    def set_default_response_format
      request.format = :json
    end
end
