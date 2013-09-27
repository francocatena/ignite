require 'test_helper'

class LessonsControllerTest < ActionController::TestCase
  setup do
    @lesson = lessons(:introduction)
    @course = courses(:ignite)
    @request.remote_addr = '127.0.0.1'
  end

  test 'should get index' do
    get :index, course_id: @course.to_param
    assert_response :success
    assert_not_nil assigns(:lessons)
    assert_template 'lessons/index'
  end

  test 'should get new' do
    get :new, course_id: @course.to_param
    assert_response :success
    assert_template 'lessons/new'
  end

  test 'should create lesson' do
    assert_difference 'Lesson.count' do
      post :create, course_id: @course.to_param, lesson: {
        name: 'New lesson',
        sequence: '3'
      }
    end

    assert_redirected_to course_lesson_path(@course, assigns(:lesson))
  end

  test 'should show lesson' do
    get :show, course_id: @course.to_param, id: @lesson.to_param
    assert_response :success
    assert_template 'lessons/show'
  end

  test 'should get edit' do
    get :edit, course_id: @course.to_param, id: @lesson.to_param
    assert_response :success
    assert_template 'lessons/edit'
  end

  test 'should update lesson' do
    assert_no_difference 'Lesson.count' do
      put :update, course_id: @course.to_param, id: @lesson.to_param, lesson: {
        name: 'Updated lesson',
        sequence: '1'
      }
    end
    
    assert_redirected_to course_lesson_path(@course, assigns(:lesson))
    assert_equal 'Updated lesson', @lesson.reload.name
  end

  test 'should destroy lesson' do
    assert_difference 'Lesson.count', -1 do
      delete :destroy, course_id: @course.to_param, id: @lesson.to_param
    end

    assert_redirected_to course_lessons_path(@course)
  end
end
