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
        format.json { render json: @shorten, :only => [:startdate, :redirectcount] }
      else
        format.json { render json: @shorten, :only => [:startdate, :redirectcount, :lastseendate] }
      end
    end
  end

  #GET /:shortcode
  def show
    
    time = Time.now.to_s
    time = DateTime.parse( time ).strftime( "%d/%m/%Y %H:%M" )
    @shorten.update_attribute( :lastseendate, time )
    @shorten.update_attribute( :redirectcount, @shorten.redirectcount + 1 )
    render text: "Local: " +  @shorten.url, :status => 302
    
  end

  #POST /shorten
  def create
    
    @shorten = Shorten.new(shorten_params)
    
    url = @shorten.url
    shortcode = @shorten.shortcode
    
    if url.nil? 
        render text: "The url is not present." , :status => 400
      elsif !( shortcode.match( "^[0-9a-zA-Z_]{4,}$" ) )
        render text: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$. " , :status => 422
      elsif Shorten.find_by shortcode: shortcode
        render text: "The the desired shortcode is already in use. Shortcodes are case-sensitive. " , :status => 409
      elsif @shorten.save
        respond_to do |format|
          format.json { render json: @shorten, :only => [:shortcode]}
        end
    end
  end

  private

    def set_shorten
      @shorten = Shorten.find_by shortcode: params[:id]
    end

    def shorten_params
      
      url = params[:shorten][:url]
      shortcode = params[:shorten][:shortcode]

      if shortcode.nil? 
        shortcode = rand( 36**6 ).to_s( 36 )
      end
      
      time = Time.now.to_s
      time = DateTime.parse( time ).strftime( "%d/%m/%Y %H:%M" )
      
      params = ActionController::Parameters.new( url:url, shortcode:shortcode, startdate: time, redirectcount: 0 )
      
      params.permit(:url, :shortcode, :startdate, :redirectcount )
      
    end

    protected
    def set_default_response_format
      request.format = :json
    end
end
