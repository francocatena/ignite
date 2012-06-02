class SlidesController < ApplicationController
  before_filter :require_local, except: [:index, :show]
  before_filter :load_lesson
  
  layout ->(controller) { controller.request.xhr? ? false : 'application' }
  
  # GET /lessons/1/slides
  # GET /lessons/1/slides.json
  def index
    @title = t('view.slides.index_title')
    @slides = @lesson.slides.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render json: @slides }
    end
  end

  # GET /lessons/1/slides/1
  # GET /lessons/1/slides/1.json
  def show
    @title = t('view.slides.show_title')
    @slide = @lesson.slides.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render json: @slide }
    end
  end

  # GET /lessons/1/slides/new
  # GET /lessons/1/slides/new.json
  def new
    @title = t('view.slides.new_title')
    @slide = @lesson.slides.build

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render json: @slide }
    end
  end

  # GET /lessons/1/slides/1/edit
  def edit
    @title = t('view.slides.edit_title')
    @slide = @lesson.slides.find(params[:id])
  end

  # POST /lessons/1/slides
  # POST /lessons/1/slides.json
  def create
    @title = t('view.slides.new_title')
    @slide = @lesson.slides.build(params[:slide])

    respond_to do |format|
      if @slide.save
        format.html { redirect_to(course_lesson_url(@lesson.course, @lesson, anchor: @slide.anchor), notice: t('view.slides.correctly_created')) }
        format.json  { render json: @slide, status: :created, location: @slide }
      else
        format.html { render action: 'new' }
        format.json  { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lessons/1/slides/1
  # PUT /lessons/1/slides/1.json
  def update
    @title = t('view.slides.edit_title')
    @slide = @lesson.slides.find(params[:id])

    respond_to do |format|
      if @slide.update_attributes(params[:slide])
        format.html { redirect_to(course_lesson_url(@lesson.course, @lesson, anchor: @slide.anchor), notice: t('view.slides.correctly_updated')) }
        format.json  { head :ok }
      else
        format.html { render action: 'edit' }
        format.json  { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
    
  rescue ActiveRecord::StaleObjectError
    flash.alert = t('view.slides.stale_object_error')
    redirect_to edit_lesson_slide_url(@lesson, @slide)
  end

  # DELETE /lessons/1/slides/1
  # DELETE /lessons/1/slides/1.json
  def destroy
    @slide = @lesson.slides.find(params[:id])
    @slide.destroy

    respond_to do |format|
      format.html { redirect_to(lesson_slides_url(@lesson)) }
      format.json  { head :ok }
    end
  end
  
  # POST /lessons/1/slides/execute_ruby
  def execute_ruby
    code = <<-RUBY
      begin
        $stdout = StringIO.new
        #{params[:code]}
        $stdout.string
      ensure
        $stdout = STDOUT
      end
    RUBY

    render inline: ROOT_BINDING.eval(code)
  end
  
  private

  def load_lesson
    @lesson = Lesson.find(params[:lesson_id]) if params[:lesson_id]
  end
end