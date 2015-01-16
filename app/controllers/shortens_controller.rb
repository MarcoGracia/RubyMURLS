class ShortensController < ApplicationController
  before_action :set_shorten
  before_action :set_default_response_format
  protect_from_forgery with: :null_session

  #GET /:shortcode/stats
  def stats
    
      begin
        redirectcount = @shorten.redirectcount
        
        respond_to do |format|
          
          if redirectcount == 0
            format.json { render json: @shorten, :only => [:startdate, :redirectcount] }
          else
            format.json { render json: @shorten, :only => [:startdate, :redirectcount, :lastseendate] }
          end
          
        end
      rescue
        render text: "The shortcode cannot be found in the system", :status => 404
      end
    
  end

  #GET /:shortcode
  def show

    begin
      @shorten.update_attribute( :lastseendate, get_current_date )
      @shorten.update_attribute( :redirectcount, @shorten.redirectcount + 1 )
      render text: "Local: " +  @shorten.url, :status => 302
    rescue
      render text: "The shortcode cannot be found in the system", :status => 404
    end
    
    
    
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

      params = ActionController::Parameters.new( url:url, shortcode:shortcode, startdate: get_current_date, redirectcount: 0 )
      
      params.permit(:url, :shortcode, :startdate, :redirectcount )
      
    end

    protected
    def set_default_response_format
      request.format = :json
    end
    
    def get_current_date
      time = Time.now.to_s
      time = DateTime.parse( time ).strftime( "%d/%m/%Y %H:%M" )
    end
end
