class ShortensController < ApplicationController
  before_action :set_shorten
  before_action :set_default_response_format
  before_action :set_header_type
  protect_from_forgery with: :null_session

  #GET /:shortcode/stats
  def stats
      #Encapsulate to recognize when the code is not in the database (could do this from retrieve at set_shorten)
      begin
        redirectcount = @shorten.redirectcount
        #set response type
        respond_to do |format|
          #Condition that determines whenever show the last seen date
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
    #Encapsulate to recognize when the code is not in the database (could do this from retrieve at set_shorten)
    begin
      @shorten.update_attribute( :lastseendate, get_current_date )
      @shorten.update_attribute( :redirectcount, @shorten.redirectcount + 1 )
      redirect_to @shorten.url
    rescue
      render text: "The shortcode cannot be found in the system", :status => 404
    end
  end

  #POST /shorten
  def create
    
    @shorten = Shorten.new(shorten_params)
    
    #Retrieve values to determine different output
    url = @shorten.url
    shortcode = @shorten.shortcode
    
    if url.nil? 
      #Url is not providen in the json
      render text: "The url is not present." , :status => 400
    elsif !( shortcode.match( "^[0-9a-zA-Z_]{4,}$" ) )
      #UShort code has less than 4 valid characters
      render text: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$. " , :status => 422
    elsif Shorten.find_by shortcode: shortcode
      #Already in use providen shortcode
      render text: "The the desired shortcode is already in use. Shortcodes are case-sensitive. " , :status => 409
    elsif @shorten.save
      #In case the save is successfull render the generated shortcode
      respond_to do |format|
        format.json { render json: @shorten, :only => [:shortcode], status: :created}
      end
    end
  end

  private
    #Retrieve the shortcode, this allways happens on request
    def set_shorten
      @shorten = Shorten.find_by shortcode: params[:id]
    end
    #Fill the shorten object to save it in db
    def shorten_params
      
      url = params[:shorten][:url]
      shortcode = params[:shorten][:shortcode]
      #In case not providen shortcode, generate a random one
      if shortcode.nil? 
        shortcode = rand( 36**6 ).to_s( 36 )
      end
      #Fill the object
      params = ActionController::Parameters.new( url:url, shortcode:shortcode, startdate: get_current_date, redirectcount: 0 )
      #Restrictions
      params.permit(:url, :shortcode, :startdate, :redirectcount )
      
    end

    #Set response type for all the requests
    protected
    def set_default_response_format
      request.format = :json
    end
    #Get current date in desired format
    def get_current_date
      time = Time.now.to_s
      time = DateTime.parse( time ).strftime( "%d/%m/%Y %H:%M" )
    end
    
    def set_header_type
      response.headers["Content-Type"] = '"application/json"'
    end
end
