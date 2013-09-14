class LessonsController < ApplicationController
  before_filter :require_local, except: [:index, :show]
  before_filter :load_course
  
  # GET /lessons
  # GET /lessons.json
  def index
    @title = t('view.lessons.index_title')
    @lessons = @course.lessons.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render json: @lessons }
    end
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
    @title = t('view.lessons.show_title')
    @lesson = @course.lessons.find(params[:id])
    @feedback = Feedback.find_by ip: request.remote_ip, lesson_id: @lesson.id
    @feedback ||= @lesson.feedbacks.build

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render json: @lesson }
    end
  end

  # GET /lessons/new
  # GET /lessons/new.json
  def new
    @title = t('view.lessons.new_title')
    @lesson = @course.lessons.build

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render json: @lesson }
    end
  end

  # GET /lessons/1/edit
  def edit
    @title = t('view.lessons.edit_title')
    @lesson = @course.lessons.find(params[:id])
  end

  # POST /lessons
  # POST /lessons.json
  def create
    @title = t('view.lessons.new_title')
    @lesson = @course.lessons.build lesson_params

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to([@course, @lesson], notice: t('view.lessons.correctly_created')) }
        format.json  { render json: @lesson, status: :created, location: @lesson }
      else
        format.html { render action: 'new' }
        format.json  { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lessons/1
  # PUT /lessons/1.json
  def update
    @title = t('view.lessons.edit_title')
    @lesson = @course.lessons.find(params[:id])

    respond_to do |format|
      if @lesson.update lesson_params
        format.html { redirect_to([@course, @lesson], notice: t('view.lessons.correctly_updated')) }
        format.json  { head :ok }
      else
        format.html { render action: 'edit' }
        format.json  { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
    
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_course_lesson_url(@course, @lesson), alert: t('view.lessons.stale_object_error')
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @lesson = @course.lessons.find(params[:id])
    @lesson.destroy

    respond_to do |format|
      format.html { redirect_to(course_lessons_url) }
      format.json  { head :ok }
    end
  end
  
  private
  
  def load_course
    @course = Course.find(params[:course_id]) if params[:course_id]
  end

  def lesson_params
    params.require(:lesson).permit(:name, :sequence, :lock_version)
  end
end
