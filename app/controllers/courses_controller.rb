class CoursesController < ApplicationController
  before_filter :require_local, except: [:index, :show]

  # GET /courses
  # GET /courses.json
  def index
    @title = t('view.courses.index_title')
    @courses = Course.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @title = t('view.courses.show_title')
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @title = t('view.courses.new_title')
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @title = t('view.courses.edit_title')
    @course = Course.find(params[:id])
  end

  # POST /courses
  # POST /courses.json
  def create
    @title = t('view.courses.new_title')
    @course = Course.new course_params

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: t('view.courses.correctly_created') }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: 'new' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @title = t('view.courses.edit_title')
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update course_params
        format.html { redirect_to @course, notice: t('view.courses.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end

  rescue ActiveRecord::StaleObjectError
    redirect_to edit_lesson_url(@lesson), alert: t('view.courses.stale_object_error')
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :ok }
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :notes, :lock_version)
  end
end
