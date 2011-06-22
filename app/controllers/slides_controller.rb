class SlidesController < ApplicationController
  # GET /slides
  # GET /slides.xml
  def index
    @title = t :'view.slides.index_title'
    @slides = Slide.order("#{Slide.table_name}.number ASC").paginate(
      :page => params[:page],
      :per_page => APP_LINES_PER_PAGE
    )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @slides }
    end
  end

  # GET /slides/1
  # GET /slides/1.xml
  def show
    @title = t :'view.slides.show_title'
    @slide = Slide.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @slide }
    end
  end

  # GET /slides/new
  # GET /slides/new.xml
  def new
    @title = t :'view.slides.new_title'
    @slide = Slide.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @slide }
    end
  end

  # GET /slides/1/edit
  def edit
    @title = t :'view.slides.edit_title'
    @slide = Slide.find(params[:id])
  end

  # POST /slides
  # POST /slides.xml
  def create
    @title = t :'view.slides.new_title'
    @slide = Slide.new(params[:slide])

    respond_to do |format|
      if @slide.save
        format.html { redirect_to(@slide, :notice => t(:'view.slides.correctly_created')) }
        format.xml  { render :xml => @slide, :status => :created, :location => @slide }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @slide.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /slides/1
  # PUT /slides/1.xml
  def update
    @title = t :'view.slides.edit_title'
    @slide = Slide.find(params[:id])

    respond_to do |format|
      if @slide.update_attributes(params[:slide])
        format.html { redirect_to(@slide, :notice => t(:'view.slides.correctly_updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @slide.errors, :status => :unprocessable_entity }
      end
    end
    
  rescue ActiveRecord::StaleObjectError
    flash.alert = t :'view.slides.stale_object_error'
    redirect_to edit_slide_url(@slide)
  end

  # DELETE /slides/1
  # DELETE /slides/1.xml
  def destroy
    @slide = Slide.find(params[:id])
    @slide.destroy

    respond_to do |format|
      format.html { redirect_to(slides_url) }
      format.xml  { head :ok }
    end
  end
end
