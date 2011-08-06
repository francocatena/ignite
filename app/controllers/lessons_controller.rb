class LessonsController < ApplicationController
  before_filter :require_local, :except => [:index, :show]
  
  # GET /lessons
  # GET /lessons.xml
  def index
    @title = t :'view.lessons.index_title'
    @lessons = Lesson.order("#{Lesson.table_name}.sequence ASC").paginate(
      :page => params[:page],
      :per_page => APP_LINES_PER_PAGE
    )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lessons }
    end
  end

  # GET /lessons/1
  # GET /lessons/1.xml
  def show
    @title = t :'view.lessons.show_title'
    @lesson = Lesson.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lesson }
    end
  end

  # GET /lessons/new
  # GET /lessons/new.xml
  def new
    @title = t :'view.lessons.new_title'
    @lesson = Lesson.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lesson }
    end
  end

  # GET /lessons/1/edit
  def edit
    @title = t :'view.lessons.edit_title'
    @lesson = Lesson.find(params[:id])
  end

  # POST /lessons
  # POST /lessons.xml
  def create
    @title = t :'view.lessons.new_title'
    @lesson = Lesson.new(params[:lesson])

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to(@lesson, :notice => t(:'view.lessons.correctly_created')) }
        format.xml  { render :xml => @lesson, :status => :created, :location => @lesson }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @lesson.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lessons/1
  # PUT /lessons/1.xml
  def update
    @title = t :'view.lessons.edit_title'
    @lesson = Lesson.find(params[:id])

    respond_to do |format|
      if @lesson.update_attributes(params[:lesson])
        format.html { redirect_to(@lesson, :notice => t(:'view.lessons.correctly_updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @lesson.errors, :status => :unprocessable_entity }
      end
    end
    
  rescue ActiveRecord::StaleObjectError
    flash.alert = t :'view.lessons.stale_object_error'
    redirect_to edit_lesson_url(@lesson)
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.xml
  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy

    respond_to do |format|
      format.html { redirect_to(lessons_url) }
      format.xml  { head :ok }
    end
  end
end