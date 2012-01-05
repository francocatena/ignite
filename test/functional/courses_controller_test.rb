require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  setup do
    @course = courses(:ignite)
    @request.remote_addr = '127.0.0.1'
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:courses)
    assert_select '#error_body', false
    assert_template 'courses/index'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_select '#error_body', false
    assert_template 'courses/new'
  end

  test 'should create course' do
    assert_difference 'Course.count' do
      post :create, course: {
        name: 'New name',
        notes: 'New notes'
      }
    end

    assert_redirected_to course_path(assigns(:course))
  end

  test 'should show course' do
    get :show, id: @course.to_param
    assert_response :success
    assert_select '#error_body', false
    assert_template 'courses/show'
  end

  test 'should get edit' do
    get :edit, id: @course.to_param
    assert_response :success
    assert_select '#error_body', false
    assert_template 'courses/edit'
  end

  test 'should update course' do
    assert_no_difference 'Course.count' do
      put :update, id: @course.to_param, course: {
        name: 'Updated course',
        notes: 'Updated notes'
      }
    end
    
    assert_redirected_to course_path(assigns(:course))
    assert_equal 'Updated course', @course.reload.name
  end

  test 'should destroy course' do
    assert_difference 'Course.count', -1 do
      delete :destroy, id: @course.to_param
    end

    assert_redirected_to courses_path
  end
end
