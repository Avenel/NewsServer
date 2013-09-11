require 'nokogiri'
require 'open-uri'
require 'net/http'

class NewsController < ApplicationController
  after_filter :set_access_control_headers

  def set_access_control_headers 
    headers['Access-Control-Allow-Origin'] = '*' 
    headers['Access-Control-Request-Method'] = '*' 
  end

  # GET /news
  # GET /news.json
  def index
    domain = 'www.hs-karlsruhe.de'
    site_master = '/fakultaeten/fk-iwi/masterstudiengaenge/fk-iwiim/aktuell.html'    
    site_bachelor = '/fakultaeten/fk-iwi/bachelorstudiengaenge/fk-iwiib/aktuell.html'    
    site_general = '/fakultaeten/fk-iwi/aktuelles.html'

    file_master = "aktuell_master"
    file_bachelor = "aktuell_bachelor"
    file_general = "aktuell_general"

    downloadWebsite(domain, site_master, file_master)
    downloadWebsite(domain, site_bachelor, file_bachelor)
    downloadWebsite(domain, site_master, file_general)

    # delete all stored news
    @news = Array.new
    News.delete_all
    @newsCount = 1

    # Fetch Bachelor News
    parseForNews(file_master, "IM")
    parseForNews(file_bachelor, "IB")
    parseForNews(file_general, "IWI")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @news }
    end
  end

  # GET /news/1
  # GET /news/1.json
  def show
    @news = News.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @news }
    end
  end

  # GET /news/new
  # GET /news/new.json
  def new
    @news = News.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @news }
    end
  end

  # GET /news/1/edit
  def edit
    @news = News.find(params[:id])
  end

  # POST /news
  # POST /news.json
  def create
    @news = News.new(params[:news])

    respond_to do |format|
      if @news.save
        format.html { redirect_to @news, notice: 'News was successfully created.' }
        format.json { render json: @news, status: :created, location: @news }
      else
        format.html { render action: "new" }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /news/1
  # PUT /news/1.json
  def update
    @news = News.find(params[:id])

    respond_to do |format|
      if @news.update_attributes(params[:news])
        format.html { redirect_to @news, notice: 'News was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    @news = News.find(params[:id])
    @news.destroy

    respond_to do |format|
      format.html { redirect_to news_index_url }
      format.json { head :no_content }
    end
  end


  def downloadWebsite(domain, site, file)
    Net::HTTP.start(domain) do |http|
      resp = http.get(site)
      open(file, "wb") do |file|
        file.write(resp.body)
      end
    end
  end

  def parseForNews(file, organisation) 
    doc = Nokogiri::HTML(File.open(file))
    doc.css('.csc-default').each do |cwrapper|
      news = News.new
      news.title = cwrapper.css('.content-center-inner').text.rstrip.lstrip

      if news.title.empty? then 
        break
      end

      news.content = cwrapper.css('.content-right-inner').text.rstrip.lstrip
      news.date = Time.new.strftime("%d.%m.%Y")
      news.organisation = "[#{organisation}]"
      news.id = @newsCount
      news.save
      puts news.inspect
      @newsCount += 1
      @news.push(news)
    end 
  end

end
