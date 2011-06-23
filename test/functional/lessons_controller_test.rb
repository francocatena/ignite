require 'test_helper'

class LessonsControllerTest < ActionController::TestCase
  setup do
    @lesson = lessons(:introduction)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:lessons)
    assert_select '#error_body', false
    assert_template 'lessons/index'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_select '#error_body', false
    assert_template 'lessons/new'
  end

  test 'should create lesson' do
    assert_difference 'Lesson.count' do
      post :create, :lesson => {
        :name => 'New lesson',
        :sequence => '3'
      }
    end

    assert_redirected_to lesson_path(assigns(:lesson))
  end

  test 'should show lesson' do
    get :show, :id => @lesson.to_param
    assert_response :success
    assert_select '#error_body', false
    assert_template 'lessons/show'
  end

  test 'should get edit' do
    get :edit, :id => @lesson.to_param
    assert_response :success
    assert_select '#error_body', false
    assert_template 'lessons/edit'
  end

  test 'should update lesson' do
    assert_no_difference 'Lesson.count' do
      put :update, :id => @lesson.to_param, :lesson => {
          :name => 'Updated lesson',
          :sequence => '1'
        }
    end
    
    assert_redirected_to lesson_path(assigns(:lesson))
    assert_equal 'Updated lesson', @lesson.reload.name
  end

  test 'should destroy lesson' do
    assert_difference 'Lesson.count', -1 do
      delete :destroy, :id => @lesson.to_param
    end

    assert_redirected_to lessons_path
  end
end
